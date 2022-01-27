const { Field } = require("./field")

class Controller {
    constructor () {
        this.field = new Field();
        console.log(this.field.toString());

        this.field.move(1, 1, -1, {});
        console.log(this.field.toString());

        this.field.move(1, 0, 1, {});
        console.log(this.field.toString());
    }
}

exports.Controller = Controller;