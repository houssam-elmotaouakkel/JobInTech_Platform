const os = require("os");

console.log("platforme :", os.platform());
console.log("architecturee :", os.arch());
console.log("CPU :", os.cpus().length, "coeurs");
console.log("memoire totale :", os.totalmem());
console.log("memoire libre :", os.freemem());
console.log("uptime (en heures) :", (os.uptime() / 3600).toFixed(2));