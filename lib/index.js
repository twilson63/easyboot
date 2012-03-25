var destFile, fs, manifest, request, sourceUrl, zipfile;

request = require('request');

fs = require('fs');

zipfile = require('zipfile');

sourceUrl = 'https://github.com/twitter/bootstrap/raw/master/docs/assets/bootstrap.zip';

destFile = '/tmp/bootstrap.zip';

manifest = [
  {
    dir: 'css',
    name: 'bootstrap.min.css'
  }, {
    dir: 'css',
    name: 'bootstrap-responsive.min.css'
  }, {
    dir: 'js',
    name: 'bootstrap.min.js'
  }, {
    dir: 'img',
    name: 'glyphicons-halflings-white.png'
  }, {
    dir: 'img',
    name: 'glyphicons-halflings.png'
  }
];

module.exports = function(dir, callback) {
  var bs, xtract;
  if (dir == null) dir = '.';
  xtract = function(zfile, src, dest) {
    var wf;
    wf = fs.createWriteStream(dest);
    wf.write(zfile.readFileSync(src));
    return wf.end();
  };
  bs = fs.createWriteStream(destFile);
  bs.on('close', function() {
    var assetDir, item, zf, _i, _j, _len, _len2, _ref;
    console.log('Downloaded ZipFile');
    try {
      _ref = ['css', 'js', 'img'];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        assetDir = _ref[_i];
        fs.mkdirSync("" + dir + "/" + assetDir);
      }
      zf = new zipfile.ZipFile(destFile);
      for (_j = 0, _len2 = manifest.length; _j < _len2; _j++) {
        item = manifest[_j];
        xtract(zf, "bootstrap/" + item.dir + "/" + item.name, "" + dir + "/" + item.dir + "/" + item.name);
      }
      console.log('Extracted Contents');
      fs.unlinkSync(destFile);
      console.log('Removed ZipFile');
    } catch (err) {
      console.log("error occurred: " + err);
    }
    return callback(null, 'done');
  });
  return request(sourceUrl).pipe(bs);
};
