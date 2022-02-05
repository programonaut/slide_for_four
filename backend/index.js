//https://www.youtube.com/watch?v=cXxEiWudIUY&t=2658s
const {
  WebSocketServer,
  WebSocket
} = require("ws")
const {
  Controller
} = require("./logic/controller")
const {
  createId
} = require("./logic/utils")

const games = {}

const server = new WebSocketServer({
  "port": 3000,
})

server.on('connection', function connection(socket) {
  console.log("somone joined");
  socket.on('message', function message(json) {
    const msg = JSON.parse(json);
    const type = msg.type;
    const params = msg.params;
    console.log('received: %s %s', type, params);

    switch (msg.type) {
      case 'create':
        let id = createId(5);
        console.log('create', id);
        games[id] = new Controller();

        socket.room = id;
        socket.id = 1;
        
        games[id].joinGame(socket);
        
        socket.sendJSON({
          type: 'init',
          params: {
            player: 1,
            code: id
          }
        });
        break;
      case 'join':
        if (Object.keys(games).includes(params.code)) {
          console.log('Game', params.code, 'exists');

          // max two players per room
          console.log("current player:", games[params.code].players.size)
          if (games[params.code].players.size >= 2) {
            console.log("full");
            socket.sendJSON({
              type: "full",
              params: {}
            })
            break;
          }

          socket.room = params.code;
          socket.id = 2;
          
          socket.sendJSON({
            type: 'init',
            params: {
              player: 2,
              code: params.code
            }
          });

          games[params.code].joinGame(socket);

        } else {
          console.log('Game', params.code, 'does not exist');
        }

        console.log(`join with code ${msg.params.code}`);
        break;

      default:
        if (socket.room !== undefined)
          games[socket.room].handle(msg);
        break;
    }
  });

  // socket.send('something');
});

WebSocket.prototype.sendJSON = async function (msg, later = false) {
  if (later)
    await new Promise(resolve => setTimeout(resolve, 100));
  console.log("send", msg);
  this.send(JSON.stringify(msg));
}