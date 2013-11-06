var JS    = require("jstest"),
    async = require("async"),
    steps = require("./server_steps")

JS.Test.describe("Storage server (async.series)", function() { with(this) {
  include(steps)

  before(function(resume) { with(this) {
    startServer(4180, resume)
  }})

  after(function(resume) { with(this) {
    async.series([
      function(cb) { clearData(cb) },
      function(cb) { stopServer(cb) }
    ], resume)
  }})

  it("saves and retrieves a value", function(resume) { with(this) {
    async.series([
      function(cb) { put("/meaning_of_life", {value: "42"}, cb) },
      function(cb) { get("/meaning_of_life", cb) },
      function(cb) { checkBody("42", cb) }
    ], resume)
  }})

  it("deletes all the data", function(resume) { with(this) {
    async.series([
      function(cb) { put("/meaning_of_life", {value: "42"}, cb) },
      function(cb) { clearData(cb) },
      function(cb) { get("/meaning_of_life", cb) },
      function(cb) { checkBody("Not found", cb) }
    ], resume)
  }})
}})

