const fs = require('fs');

//const options = {
//  key: fs.readFileSync('orekey.pem'),
//  cert: fs.readFileSync('orecert.pem')
//};
const express = require('express')
const app = express()

var server = require("http").Server(app)
app.get('/', (req, res) => {
  res.sendFile(__dirname+'/index.html');
});
var io = require('socket.io')(server);

io.on('connection', function(socket) {
    console.log("client connected")

    socket.on('disconnect', function() {
        console.log("client disconnected")
    });

    socket.on("from_client", function(msg){
        console.log("receive: " + msg);

        console.log("send message");
        io.emit("from_server", msg);
    });
});

server.listen(3000);
