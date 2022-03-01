var compression = require('compression')
var express = require('express')
var path = require('path')

var app = express()

// compress all responses
app.use(compression())
app.use(express.static('web'));

// add all routes
const port = 3000

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, "/build/index.html"));
})

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})