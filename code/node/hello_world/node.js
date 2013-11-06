var JS = require("jstest")

JS.Test.describe("Hello, world!", function() { with(this) {
  it("runs a test", function() { with(this) {
    assertEqual( "Hello, world!", ["Hello", "world!"].join(", ") )
  }})
}})

JS.Test.autorun()

