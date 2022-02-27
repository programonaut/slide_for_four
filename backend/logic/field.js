class Field {
    //  0 = movable
    //  1 = player 1
    //  2 = player 2

    constructor(width = 4) {
        this.width = width;
        let size = width ** 2;
        this.field = [
            ...Array(size - 2 * width).fill(0),
            ...Array(width).fill(1),
            ...Array(width).fill(2)
        ];
        this.shuffle(this.field);
    }


    checkWin() {
        let winner = 0;
        // rows
        for (let y = 0; y < this.width; y++) {
            winner = this.checkRow(y);
            if (winner !== 0)
                return winner
        }
        // columns
        for (let x = 0; x < this.width; x++) {
            winner = this.checkColumn(x);

            if (winner !== 0)
            return winner
        }
        // diagonals
        winner = this.checkDiagonals();
        return winner;
    }

    checkRow(row) {
        let winner = this.field[row * this.width];
        for (let x = 0; x < this.width; x++) {
            if (this.field[row * this.width + x] !== winner)
                winner = 0;
        }
        return winner;
    }

    checkColumn(col) {
        let winner = this.field[col];
        let over = this.field.filter((v, i) => {
            if (i % this.width === col)
            return i % this.width === col
        }).every(v => v === winner)
        if (over)
            return winner;
        return 0;
    }

    // diag = 0 or diag = 1
    checkDiagonals() {
        // lr
        let winner = this.field[0];
        for (let i = 0; i < this.width; i++) {
            if (this.field[i * (this.width + 1)] !== winner)
                winner = 0;
        }

        if (winner !== 0)
            return winner;
        // rl
        winner = this.field[this.width - 1];
        for (let i = 1; i < this.width + 1; i++) {
            if (this.field[i * (this.width - 1)] !== winner)
                winner = 0;
        }

        return winner;
    }

    /**
     * 
     * @param {int} player 
     * @param {int} index 
     * @param {int} direction -1=left, +4=down, -4=up, +1=right
     * @param {object} rules 
     */
    move(player, index, direction, rules) {
        if (this.checkValidMove(player, index, direction, rules)) {
            let tmp = this.field[index + direction];
            this.field[index + direction] = this.field[index];
            this.field[index] = tmp;
        }
    }

    checkValidMove(player, index, direction, rules) {
        return true;
    }

    /**
     * Shuffles array in place.
     * @param {Array} a items An array containing the items.
     */
    shuffle(a) {
        var j, x, i;
        for (i = a.length - 1; i > 0; i--) {
            j = Math.floor(Math.random() * (i + 1));
            x = a[i];
            a[i] = a[j];
            a[j] = x;
        }
        return a;
    }

    toString() {
        let res = "";
        this.field.forEach((el, index) => {
            if (index % 4 === 0) {
                if (el.toString().length === 2)
                    res += `${el} |`;
                else
                    res += ` ${el} |`;
            } else if (index % 4 === 3) {
                if (el.toString().length === 2)
                    res += ` ${el}\n`;
                else
                    res += `  ${el}\n`;
            } else {
                if (el.toString().length === 2)
                    res += ` ${el} |`;
                else
                    res += `  ${el} |`;
            }
        });
        return res;
    }
}

exports.Field = Field;