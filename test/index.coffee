easyboot = require '../lib'
fs = require 'fs'
wrench = require 'wrench'
describe 'easyboot', ->
  describe '#main()', ->
    it 'should download and extract bootstrap.zip', (done) ->
      fs.mkdirSync('foo')
      easyboot './foo', (err, result) ->
        result.should.equal 'done'
        fs.statSync('./foo/css').should.be.ok
        fs.statSync('./foo/js').should.be.ok
        ( -> fs.statSync('/tmp/bootstrap.zip')).should.throw()
        wrench.rmdirSyncRecursive('./foo', true)
        done()
    it 'should return error for invalid directory', (done) ->
      easyboot './bar', (err, results) ->
        err.should.be.ok
        fs.unlinkSync('/tmp/bootstrap.zip')
        done()
