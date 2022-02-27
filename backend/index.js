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
const players = {}

const server = new WebSocketServer({
  "port": 3000,
})

server.on('connection', function connection(socket, req) {
  console.log(`somone joined ${req.socket.remoteAddress}`);
  const ip = `${req.socket.remoteAddress}`;
  socket.on('message', function message(json) {
    const msg = JSON.parse(json);
    const type = msg.type;
    const params = msg.params;
    console.log('received: %s %s', type, params);

    switch (msg.type) {
      case 'create':
        createGame();
        break;
      case 'join':
        joinGame(params);
        break;
      case 'reconnect':
        reconnectGame(params);
        break;
      case 'connect':
        connect();
        break;
      case 'disconnect':
        disconnect();
        break;
      default:
        if (socket.room !== undefined)
          games[socket.room].handle(msg);
        break;
    }
  });

  socket.on('close', function close() {
    disconnect();
  });

  function createGame() {
    let room = createId(5);
    console.log('create', room);
    games[room] = new Controller();

    socket.room = room;
    socket.id = 1;
    
    games[room].joinGame(socket);
    players[ip] = room;
    
    socket.sendJSON({
      type: 'init',
      params: {
        player: 1,
        code: room
      }
    });
  }

  function joinGame(params) {
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
        return;
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

    console.log(`join with code ${params.code}`);
  }

  function reconnectGame(params) {
    if (Object.keys(games).includes(params.code)) {
      // max two players per room
      console.log("current player:", games[params.code].players.size)
      if (games[params.code].players.size >= 2) {
        console.log("full");
        socket.sendJSON({
          type: "full",
          params: {}
        })
        return;
      }

      socket.room = params.code;

      let player = games[params.code].getPlayer();

      socket.id = player;
      socket.sendJSON({
        type: 'init',
        params: {
          player: player,
          code: params.code
        }
      });

      games[params.code].rejoinGame(socket);
    } else {
      console.log('Game', params.code, 'does not exist');
    }
  }

  function connect() {
    socket.sendJSON({
      type: 'connected',
      params: {}
    });
  }

  function disconnect() {
    // disconnected
    socket.sendJSON({
      type: 'disconnected',
      params: {}
    });
    // leave game
    if (socket.room !== undefined && socket.room !== '' && games[socket.room] !== undefined) {
      games[socket.room].leaveGame(socket);
      if (games[socket.room].players.size === 0) {
        removeGame(socket.room);
      }

    }
  }

  function removeGame(room) {
    delete games[room];
    console.log(`Remove Room:`, room);
  }
});



WebSocket.prototype.sendJSON = async function (msg, later = false) {
  if (later)
    await new Promise(resolve => setTimeout(resolve, 100));
  console.log("send", msg);
  this.send(JSON.stringify(msg));
}