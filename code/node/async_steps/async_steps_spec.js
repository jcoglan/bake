var JS    = require("jstest"),
    steps = require("./server_steps")

steps = JS.Test.asyncSteps(steps)

JS.Test.describe("Storage server (async steps)", function() { with(this) {
  include(steps)

  before(function() { with(this) {
    startServer(4180)
  }})

  after(function() { with(this) {
    clearData()
    stopServer()
  }})

  it("saves and retrieves a value", function() { with(this) {
    put("/meaning_of_life", {value: "42"})
    get("/meaning_of_life")
    checkBody("42")
  }})

  it("deletes all the data", function() { with(this) {
    put("/meaning_of_life", {value: "42"})
    clearData()
    get("/meaning_of_life")
    checkBody("Not found")
  }})
}})

