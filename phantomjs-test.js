
var System = require('system');
var port = System.args[1];
var page = require('webpage').create();
page.open('http://' + port, function(status) {
  if (status !== 'success') {
    console.log('FAIL to load the address');
  } else {
    console.log(page.content);
  }
  phantom.exit();
});
