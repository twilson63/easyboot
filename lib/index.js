var fs, request, zipfile;

request = require('request');

fs = require('fs');

zipfile = require('zipfile');

module.exports = function() {
  var bs;
  bs = fs.createWriteStream('bootstrap.zip');
  bs.on('close', function() {
    var bcss, bimg1, bimg2, bjs, brcss, zf;
    console.log('Download Complete');
    try {
      fs.mkdirSync('css');
      fs.mkdirSync('js');
      fs.mkdirSync('img');
      zf = new zipfile.ZipFile('./bootstrap.zip');
      bcss = fs.createWriteStream('./css/bootstrap.min.css');
      bcss.write(zf.readFileSync('bootstrap/css/bootstrap.min.css'));
      bcss.end();
      brcss = fs.createWriteStream('./css/bootstrap-responsive.min.css');
      brcss.write(zf.readFileSync('bootstrap/css/bootstrap-responsive.min.css'));
      brcss.end();
      bjs = fs.createWriteStream('./js/bootstrap.min.js');
      bjs.write(zf.readFileSync('bootstrap/js/bootstrap.min.js'));
      bjs.end();
      bimg1 = fs.createWriteStream('./img/glyphicons-halflings-white.png');
      bimg1.write(zf.readFileSync('bootstrap/img/glyphicons-halflings-white.png'));
      bimg1.end();
      bimg2 = fs.createWriteStream('./img/glyphicons-halflings.png');
      bimg2.write(zf.readFileSync('bootstrap/img/glyphicons-halflings.png'));
      bimg2.end();
      return console.log('Extract Complete');
    } catch (err) {
      return console.log("error occurred: " + err);
    }
  });
  return request('https://github.com/twitter/bootstrap/raw/master/docs/assets/bootstrap.zip').pipe(bs);
};
