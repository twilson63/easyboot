request = require 'request'
fs = require 'fs'
zipfile = require 'zipfile'
sourceUrl = 'https://github.com/twitter/bootstrap/raw/master/docs/assets/bootstrap.zip'

manifest = [
  { dir: 'css', name: 'bootstrap.min.css' }
  { dir: 'css', name: 'bootstrap-responsive.min.css' }
  { dir: 'js', name: 'bootstrap.min.js' }
  { dir: 'img', name: 'glyphicons-halflings-white.png'}
  { dir: 'img', name: 'glyphicons-halflings.png'}
]

# # easyboot(dir, callback)
#
# command application to pull current bootstrap assets from 
# the cloud and deploy to your assets folder
#
#     Parameters    |  Type    |  Required   | Description
#     --------------|----------|-------------|----------------------
#     dir           | string   | optional    | the directory you want to extract to
#     callback      | function | optional    | callback which will fire when completed
#
# usage
#
#     easyboot = require 'easyboot'
#
#     easyboot 'foo', (err, results) ->
#       return console.log(err) if err?
#       console.log results
#
module.exports = (dir='.', callback) ->
  # xtract(zfile, src, dest)
  #
  # extracts a file in the zip file to the local file system
  #
  #     Parameters     |  Type   | Required | Description
  #     ---------------|---------|----------|-------------------
  #     zfile          | object  | Required | zipfile object
  #     src            | string  | Required | source of file in zipfile
  #     dest           | string  | Required | destination file on file system
  #
  # usage
  #
  #     zf = new zipfile.ZipFile('foobar.zip')
  #     xtract zf, 'foo.txt', './foo.txt'
  xtract = (zfile, src, dest) ->
    wf = fs.createWriteStream(dest)
    wf.write zfile.readFileSync(src)
    wf.end()

  # create file write stream that we can pipe the downloaded file to.
  bs = fs.createWriteStream('bootstrap.zip')
  # when file is completely written to fs then extract contents
  bs.on 'close', -> 
    console.log 'Downloaded ZipFile'
    # extract
    try
      fs.mkdirSync directory for directory in ['css','js','img']
      zf = new zipfile.ZipFile('./bootstrap.zip')

      for item in manifest
        xtract zf, "bootstrap/#{item.dir}/#{item.name}", "#{dir}/#{item.dir}/#{item.name}"

      console.log 'Extracted Contents'
      fs.unlinkSync('./bootstrap.zip')
      console.log 'Removed ZipFile'
    catch err
      console.log "error occurred: #{err}"

  # get zip file and pipe it to the local filesystem
  request(sourceUrl).pipe(bs)
