easyboot = require '../lib'
fs = require 'fs'
wrench = require 'wrench'
describe 'easyboot', ->
  describe '#main()', ->
    it 'should download and extract bootstrap.zip', (done) ->
      fs.mkdirSync('foo')
      easyboot './foo', (err, result) ->
        fs.statSync('./foo/css').should.be.ok
        fs.statSync('./foo/js').should.be.ok
        ( -> fs.statSync('/tmp/bootstrap.zip')).should.throw()
        wrench.rmdirSyncRecursive('./foo', true)
        done()
