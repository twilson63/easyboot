request = require 'request'
fs = require 'fs'
zipfile = require 'zipfile'
sourceUrl = 'https://github.com/twitter/bootstrap/raw/master/docs/assets/bootstrap.zip'
destFile = '/tmp/bootstrap.zip'

# log(msg)
#
# writes timestamped message to stdout if env var DEBUG is set to true
#
# private
#
#     Parameter    |  Type   |  Required   |  Description
#     -------------|---------|-------------|------------------
#     msg          | string  | Required    | write msg to stdout
#
# usage
#
#    log 'downloaded file'
log = (msg) ->
  console.log "#{(new Date()).toString()} - #{msg}" if process.env.DEBUG is 'true'

# # manifest
#
# array of files to extract and where to extract them.
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
    log "extracted -> #{src}"

  # create file write stream that we can pipe the downloaded file to.
  bs = fs.createWriteStream destFile
  # when file is completely written to fs then extract contents
  bs.on 'close', -> 
    log "Downloaded #{destFile}"
    # extract
    try
      fs.mkdirSync "#{dir}/#{assetDir}" for assetDir in ['css','js','img']
      zf = new zipfile.ZipFile(destFile)

      for item in manifest
        xtract zf, "bootstrap/#{item.dir}/#{item.name}", "#{dir}/#{item.dir}/#{item.name}"

      fs.unlinkSync(destFile)
      log "Removed #{destFile}"
    catch err
      console.log "error occurred: #{err}"
    callback null, 'done'

  # get zip file and pipe it to the local filesystem
  request(sourceUrl).pipe(bs)
