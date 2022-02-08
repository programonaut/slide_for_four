const {
    Field
} = require("./field")

let field = new Field();

console.log(field.field);
// field.field = [1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0]
// field.field = [1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0]
// field.field = [1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1]
field.field = [0,0,0,1,0,0,1,0,0,1,0,0,1,0,0,0]
console.log(field.field);
field.checkWin();