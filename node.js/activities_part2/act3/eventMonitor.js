const EventEmitter = require('events');
const emitter = new EventEmitter();

emitter.on("utilisateurConnecte", (data) => {
    console.log(`nouvelle connexion : ${data.nom} (${data.id})`);
});

emitter.emit("utilisateurConnecte", { id: 1, nom: "asma" });