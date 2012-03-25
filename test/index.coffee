easyboot = require '../lib'
fs = require 'fs'
describe 'easyboot', ->
  describe '#main()', ->
    it 'should download and extract bootstrap.zip', (done) ->
      fs.mkdirSync('foo')
      easyboot './foo', (err, result) ->
        console.log fs.statSync('css')
        done()
