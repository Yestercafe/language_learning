function pascal(row, pos) {
    return row === 0 && pos === 0
         ? 1
         : pos < 0 || pos > row
         ? 0
         : pascal(row - 1, pos - 1) + pascal(row - 1, pos);
}

// ======================================
function test() {
    for (let irow = 0; irow < 10; ++irow) {
        for (let ipos = 0; ipos <= irow; ++ipos) {
            process.stdout.write(`${pascal(irow, ipos)} `);
        }
        process.stdout.write("\n");
    }
}

test()

