generate();

function generate() {
    for (var index = 1; index <= 100; index++) {
        var name = "./av" + index.toString();
        var jdenticon = require("jdenticon"),
            fs = require("fs"),
            size = 300,
            value = name,
            png = jdenticon.toPng(value, size);
        name += ".png";
        fs.writeFileSync(name, png);
    }
}