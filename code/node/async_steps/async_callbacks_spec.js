var JS    = require("jstest"),
    steps = require("./server_steps")

JS.Test.describe("Storage server (callbacks)", function() { with(this) {
  include(steps)

  before(function(resume) { with(this) {
    startServer(4180, resume)
  }})

  after(function(resume) { with(this) {
    clearData(function() {
      stopServer(resume)
    })
  }})

  it("saves and retrieves a value", function(resume) { with(this) {
    put("/meaning_of_life", {value: "42"}, function() {
      get("/meaning_of_life", function() {
        resume(function(resume) {
          checkBody("42", resume)
        })
      })
    })
  }})

  it("deletes all the data", function(resume) { with(this) {
    put("/meaning_of_life", {value: "42"}, function() {
      clearData(function() {
        get("/meaning_of_life", function() {
          resume(function(resume) {
            checkBody("Not found", resume)
          })
        })
      })
    })
  }})
}})

