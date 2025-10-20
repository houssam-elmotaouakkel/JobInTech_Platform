
// JobInTech Platform — Part 2 (MongoDB)
// Flexible student profiles: skills + project portfolios

// Use or create a database
const db = connect("mongodb://127.0.0.1:27017/jobintech");
//use jobintech;
// Optional: reset collection for a clean slate during prototyping
db.profils_etudiants.drop();

// -------------------------------
// Phase 2.1/2.2: insertMany seed
// --------     -----------------------
db.profils_etudiants.insertMany([
    {
    etudiant_id: 1,
    nom_complet: "Benzerouala Oussama",
    email: "benzeroualaossama@gmail.com",
    competences: ["Python", "SQL", "Git", "API REST"],
    projets: [
      {
        titre_projet: "Sales KPI Dashboard",
        description: "Tableau de bord des ventes avec filtres dynamiques.",
        technologies: ["Pandas", "Matplotlib", "SQL"],
        annee: 2025
      },
      {
        titre_projet: "Blog REST API",
        description: "API REST avec authentification et CRUD.",
        technologies: ["Python", "Flask", "JWT"],
        annee: 2025
      }
    ],
    statut: "Actif"
  },
  {
    etudiant_id: 2,
    nom_complet: "El Moutaouakkel Houssam",
    email: "houssammoutaouakkel1994@gmail.com",
    competences: ["JavaScript", "Node.js", "MongoDB", "Git"],
    projets: [
      {
        titre_projet: "Real-time Chat",
        description: "Messagerie temps réel avec Socket.IO.",
        technologies: ["Node.js", "Express", "Socket.IO"],
        annee: 2025
      }
    ],
    statut: "Actif"
  },
  {
    etudiant_id: 3,
    nom_complet: "Tabchi Achraf",
    email: "tabchiachraf@gmail.com",
    competences: ["Python", "SQL", "Pandas", "Data Analysis"],
    projets: [
      {
        titre_projet: "Customer Churn Analysis",
        description: "EDA + modèle de churn.",
        technologies: ["Pandas", "scikit-learn", "SQL"],
        annee: 2025
      }
    ],
    statut: "Actif"
  },
  {
    etudiant_id: 4,
    nom_complet: "Abderrahmane Isfi",
    email: "abderrahmaneisfi12@gmail.com",
    competences: ["Cloud", "Docker", "Linux"],
    projets: [
      {
        titre_projet: "CI/CD Pipeline",
        description: "Build & déploiement automatisés.",
        technologies: ["Docker", "GitHub Actions", "AWS"],
        annee: 2025
      },
      {
        titre_projet: "Monitoring Stack",
        description: "Observabilité d’un microservice.",
        technologies: ["Prometheus", "Grafana", "Docker"],
        annee: 2025
      }
    ],
    statut: "Actif"
  },
  {
    etudiant_id: 5,
    nom_complet: "Bahi Salma",
    email: "salmabh2004@gmail.com",
    competences: ["HTML", "CSS", "JavaScript", "Git"],
    projets: [
      {
        titre_projet: "Portfolio Web",
        description: "Site portfolio responsive.",
        technologies: ["HTML", "CSS", "JavaScript"],
        annee: 2025
      }
    ],
    statut: "Actif"
  },
  {
    etudiant_id: 6,
    nom_complet: "Chlih Islam",
    email: "islamchlih492@gmail.com",
    competences: ["C++", "Data Structures", "Algorithms"],
    projets: [
      {
        titre_projet: "DSA Practice Suite",
        description: "Implémentation d’algorithmes classiques.",
        technologies: ["C++", "GoogleTest"],
        annee: 2025
      }
    ],
    statut: "Actif"
  },
  {
    etudiant_id: 7,
    nom_complet: "Amakhmouj Hanane",
    email: "amakhmoujhanane@gmail.com",
    competences: ["Python", "SQL", "Power BI"],
    projets: [
      {
        titre_projet: "HR Analytics",
        description: "Reporting RH et indicateurs de rétention.",
        technologies: ["Power BI", "SQL", "Excel"],
        annee: 2025
      }
    ],
    statut: "Actif"
  },
  {
    etudiant_id: 8,
    nom_complet: "Ouafir Saad",
    email: "ouafirsaad2@gmail.com",
    competences: ["Node.js", "MongoDB", "Express", "API REST"],
    projets: [
      {
        titre_projet: "Inventory Manager",
        description: "API stocks + visualisation.",
        technologies: ["Node.js", "MongoDB", "Chart.js"],
        annee: 2025
      }
    ],
    statut: "Actif"
  },
  {
    etudiant_id: 9,
    nom_complet: "Ounassi Ali",
    email: "aliounassi@gmail.com",
    competences: ["Python", "Git"],
    projets: [],
    statut: "Actif"
  },
  {
    etudiant_id: 10,
    nom_complet: "Elbelghiti Elias",
    email: "eliaselbelghiti@gmail.com",
    competences: ["Java", "Spring Boot", "SQL"],
    projets: [
      {
        titre_projet: "Course Registration API",
        description: "Gestion inscriptions et cours.",
        technologies: ["Java", "Spring Boot", "MySQL"],
        annee: 2025
      }
    ],
    statut: "Actif"
  }
]);

// --------------------------------
// Talent Search Queries (Task 2)
// --------------------------------

// Index utiles pour la recherche (recommandé)
db.profils_etudiants.createIndex({ competences: 1 });
db.profils_etudiants.createIndex({ "projets.technologies": 1 });

// 2.a Students who have the 'Python' skill
db.profils_etudiants.find({ competences: "Python" });

// 2.b Students who worked on a project using 'Pandas'
db.profils_etudiants.find({ "projets.technologies": "Pandas" });

// 2.c Students who have both 'Python' AND 'SQL' in their skills
db.profils_etudiants.find({ competences: { $all: ["Python", "SQL"] } });

// -------------------------------
// Profile Updates (Task 3)
// -------------------------------

// 3.a Add 'Docker' to a student's competences (example: houssam)
db.profils_etudiants.updateOne(
  { email: "houssammoutaouakkel1994@gmail.com" },
  { $addToSet: { competences: "Docker" } }
);

// 3.b Add a new project object to a student's projets (example: achraf)
db.profils_etudiants.updateOne(
  { email: "tabchiachraf@gmail.com" },
  {
    $push: {
      projets: {
        titre_projet: "ETL Mini Pipeline",
        description: "Extraction-transformation-charge de données CSV vers MongoDB.",
        technologies: ["Python", "Pandas", "MongoDB"],
        annee: 2025
      }
    }
  }
);

// 3.c Remove the 'Git' skill from a student's competences (example: salma)
db.profils_etudiants.updateOne(
  { email: "salmabh2004@gmail.com" },
  { $pull: { competences: "Git" } }
);

// --------------------------------
// Aggregations (Task 4)
// --------------------------------

// 4.a Most in-demand skills (frequency across profiles)
db.profils_etudiants.aggregate([
  { $unwind: "$competences" },
  { $group: { _id: "$competences", count: { $sum: 1 } } },
  { $sort: { count: -1, _id: 1 } }
]);

// 4.b Most commonly used technology across all projects
db.profils_etudiants.aggregate([
  { $unwind: "$projets" },
  { $unwind: "$projets.technologies" },
  { $group: { _id: "$projets.technologies", count: { $sum: 1 } } },
  { $sort: { count: -1, _id: 1 } },
  { $limit: 10 }
]);
