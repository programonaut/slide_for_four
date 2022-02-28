const {
    Field
} = require("./field")

class Controller {
    players = new Map();
    turnsCompleted = 1;
    activePlayer = 0;

    constructor() {
        this.field = new Field();
    }

    leaveGame(socket) {
        this.players.delete(socket.id);
    }

    getPlayer() {
        let availablePlayers = [1, 2];

        this.players.forEach((val) => {
            delete availablePlayers[availablePlayers.indexOf(val.id)];
        });

        return availablePlayers.filter(val => val !== undefined)[0];
    }

    joinGame(socket) {
        this.players.set(socket.id, socket);

        if (this.players.size == 2) {
            this.startGame();
        }
    }

    rejoinGame(socket) {
        this.players.set(socket.id, socket);

        if (this.players.size == 2) {
            this.continueGame();
        }
    }

    startGame() {
        this.activePlayer = 2;
        this.broadcast({
            type: "start",
            params: {
                player: this.activePlayer,
                field: this.field.field,
            }
        }, true);
    }

    continueGame() {
        this.broadcast({
            type: "start",
            params: {
                player: this.activePlayer,
                field: this.field.field,
            }
        }, true);
    }

    async checkWin(player) {
        const winner = this.field.checkWin(); 
        if (winner !== 0) {
            this.broadcast({
                type: "win",
                params: {
                    player: winner,
                }
            }, true);
        }
    }

    validMove(params) {
        if(params !== null && params["player"] !== null && params["player"] !== this.activePlayer)
            return false;
        return true;
    }


    turn(params) {
        if (!this.validMove(params))
            return;

        if (!this.field.move(params.player, params.index, params.direction))
            return;

        this.activePlayer = 3 - params.player;

        this.broadcast({
            type: "turn",
            params: {
                player: this.activePlayer,
                field: this.field.field,
            }
        });

        this.checkWin(params.player);
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

    handle(msg) {
        const type = msg.type;
        const params = msg.params;

        switch (type) {
            case 'turn':
                this.turn(params);
            break;
        
            default:
            break;
        }
    }
}

exports.Controller = Controller;