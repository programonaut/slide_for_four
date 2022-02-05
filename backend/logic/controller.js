const {
    Field
} = require("./field")

class Controller {
    players = new Map();
    turn = 1;

    constructor() {
        this.field = new Field();
        // console.log(this.field.toString());

        // this.field.move(1, 1, -1, {});
        // console.log(this.field.toString());

        // this.field.move(1, 0, 1, {});
        // console.log(this.field.toString());
    }

    joinGame(socket) {
        this.players.set(socket.id, socket);
        this.printPlayers();

        if (this.players.size == 2) {
            this.startGame();
        }
    }

    startGame() {
        this.broadcast({
            type: "start",
            params: {
                player: 1,
                field: this.field.field,
            }
        });
    }

    async checkWin() {
        this.broadcast({
            type: "win",
            params: {
                player: 1,
            }
        }, true);
    }

    handle(msg) {
        const type = msg.type;
        const params = msg.params;

        switch (type) {
            case 'turn':
                    this.turn();
                break;
        
            default:
                break;
        }
    }

    turn(params) {
        this.field.move(params.player, params.index, params.direction);

        this.broadcast({
            type: "turn",
            params: {
                player: 3 - params.player,
                field: this.field.field,
            }
        });

        this.checkWin();
    }

    broadcast(msg, later) {
        for (const player of this.players.values()) {
            console.log(player.id);
            player.sendJSON(msg, later);
        }
    }

    printPlayers() {
        this.players.forEach(val => console.log(val.id));
    }
}

exports.Controller = Controller;