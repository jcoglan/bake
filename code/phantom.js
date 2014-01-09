// This is a PhantomJS script that can run any of the browser-based examples
// and display the results. You can run it like so:
//
//     $ phantomjs phantom.js browser/hello_world/test.html
//
// Run it with any of the `test.html` files in this tree. You can download
// PhantomJS from http://phantomjs.org/.

var system = require("system"),
    JS     = require("./node_modules/jstest/jstest"),
    file   = system.args[1]

if (file === undefined) {
  console.error("You need to give me an HTML file to run!")
  phantom.exit(1)
}

var reporter = new JS.Test.Reporters.Headless({})
reporter.open(file)

