var express = require("express"),
    app     = express(),
    storage = {}

app.use(express.bodyParser())

app.get("/:key", function(request, response) {
  var key = request.param("key")
  if (storage.hasOwnProperty(key)) {
    response.send(200, storage[key])
  } else {
    response.send(404, "Not found")
  }
})

app.put("/:key", function(request, response) {
  storage[request.param("key")] = request.param("value")
  response.send(201, "Created")
})

app.delete("/", function(request, response) {
  storage = {}
  response.send(200, "OK")
})

module.exports = app

