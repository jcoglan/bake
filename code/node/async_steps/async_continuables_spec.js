var JS     = require("jstest"),
    async  = require("async"),
    steps  = require("./server_steps"),
    curry  = require("./curry")

steps = curry.object(steps)

JS.Test.describe("Storage server (continuables)", function() { with(this) {
  include(steps)

  before(function(resume) { with(this) {
    async.series([
      startServer(4180)
    ], resume)
  }})

  after(function(resume) { with(this) {
    async.series([
      clearData(),
      stopServer()
    ], resume)
  }})

  it("saves and retrieves a value", function(resume) { with(this) {
    async.series([
      put("/meaning_of_life", {value: "42"}),
      get("/meaning_of_life"),
      checkBody("42")
    ], resume)
  }})

  it("deletes all the data", function(resume) { with(this) {
    async.series([
      put("/meaning_of_life", {value: "42"}),
      clearData(),
      get("/meaning_of_life"),
      checkBody("Not found")
    ], resume)
  }})
}})

