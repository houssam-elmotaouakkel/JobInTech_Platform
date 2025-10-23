const fs = require("fs");
const path = require("path");

fs.readdir(__dirname, (err, files) => {
  if (err) return console.error("erreur :", err.message);
    console.log("contenu du dossier :", files);

    files.forEach(f => console.log(path.join(__dirname, f)));
});

