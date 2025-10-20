-- Optional: create a dedicated database
CREATE DATABASE IF NOT EXISTS jobintech CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE jobintech;

  
-- -----------------------------
-- Phase 1.1: Schema Definition
-- -----------------------------

DROP TABLE IF EXISTS Inscriptions;
DROP TABLE IF EXISTS Cours;
DROP TABLE IF EXISTS Etudiants;

CREATE TABLE Etudiants (
  id_etudiant INT PRIMARY KEY AUTO_INCREMENT,
  nom VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  date_inscription DATE
) ENGINE=InnoDB;

CREATE TABLE Cours (
  id_cours INT PRIMARY KEY AUTO_INCREMENT,
  titre_cours VARCHAR(150) NOT NULL,
  duree_heures INT NOT NULL CHECK (duree_heures > 0)
) ENGINE=InnoDB;

CREATE TABLE Inscriptions (
  id_inscription INT PRIMARY KEY AUTO_INCREMENT,
  id_etudiant INT NOT NULL,
  id_cours INT NOT NULL,
  statut VARCHAR(50) NOT NULL,
  note_finale INT NULL,
  CONSTRAINT fk_insc_etudiant FOREIGN KEY (id_etudiant) REFERENCES Etudiants(id_etudiant) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_insc_cours    FOREIGN KEY (id_cours)    REFERENCES Cours(id_cours)     ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT chk_note_range   CHECK (note_finale IS NULL OR (note_finale BETWEEN 0 AND 100)),
  CONSTRAINT chk_statut       CHECK (statut IN ('En cours','Terminé','Abandonné'))
) ENGINE=InnoDB;

-- Helpful indexes
CREATE INDEX idx_insc_etudiant ON Inscriptions(id_etudiant);
CREATE INDEX idx_insc_cours ON Inscriptions(id_cours);
CREATE INDEX idx_cours_titre ON Cours(titre_cours);

-- --------------------------------
-- Phase 1.2: Test Data Insertion
-- --------------------------------

-- Students (10). Ensure at least one has no inscriptions (elias).
INSERT INTO Etudiants (nom, email, date_inscription) VALUES
('Benzerouala Oussama', 'benzeroualaossama@gmail.com', '2025-09-15'),
('El Moutaouakkel Houssam', 'houssammoutaouakkel1994@gmail.com', '2025-09-15'),
('Tabchi Achraf', 'tabchiachraf@gmail.com', '2025-09-15'),
('Isfi Abderrahmane', 'abderrahmaneisfi12@gmail.com', '2025-09-15'),
('Bahi Salma', 'salmabh2004@gmail.com', '2025-09-15'),
('Chlih Islam', 'islamchlih492@gmail.com', '2025-09-15'),
('Amakhmouj hanane', 'amakhmoujhanane@gmail.com', '2025-09-15'),
('Ouafir Saad', 'ouafirsaad2@gmail.com', '2025-09-15'),
('Ounassi Ali', 'aliounassi@gmail.com', '2025-09-15'),
('Elbelghiti Elias', 'eliaselbelghiti@gmail.com', '2025-09-15');

-- Courses (5)
INSERT INTO Cours (titre_cours, duree_heures) VALUES
('SQL Database Basics', 24),
('Development Full-Stack', 40),
('Data Structures', 36),
('Cloud Fundamentals', 28),
('Intro to Data Science', 32);

-- Inscriptions (>=20). Mix statuses and notes. Ensure some NULL notes for "En cours" or newly "Terminé".
-- Assume (student_id, course_id) pairs; ids start from 1 in insertion order.
INSERT INTO Inscriptions (id_etudiant, id_cours, statut, note_finale) VALUES
-- oussama(1)
(1, 1, 'Terminé',  NULL),     -- we'll update this to 85 in Task 5
(1, 2, 'En cours', NULL),
(1, 5, 'Terminé',  65),
-- Houssam (2)
(2, 1, 'Terminé',  92),
(2, 3, 'Terminé',  88),
(2, 4, 'En cours', NULL),
-- Achraf (3)
(3, 2, 'En cours', NULL),
(3, 3, 'Terminé',  67),
-- Abderrahmane (4)
(4, 1, 'Terminé',  61),
(4, 5, 'Terminé',  73),
-- Salma (5)
(5, 2, 'En cours', NULL),
(5, 4, 'Terminé',  84),
-- Islam (6)
(6, 1, 'En cours', NULL),
(6, 3, 'Terminé',  55),
(6, 5, 'Terminé',  62),
-- hanane (7)
(7, 4, 'Terminé',  79),
(7, 2, 'Terminé',  81),
-- Saad (8)
(8, 5, 'En cours', NULL),
(8, 3, 'Terminé',  69),
(8, 1, 'Terminé', 78);
-- ali and eliass are unenrolled in any course

-- --------------------------------
-- Task 3: Basic Reporting Queries
-- --------------------------------

-- 3.a List all students enrolled in a specific course (e.g., 'SQL Database Basics')
-- Includes status and grade if available
SELECT e.id_etudiant, e.nom, e.email, i.statut, i.note_finale
FROM Inscriptions i
JOIN Etudiants e ON e.id_etudiant = i.id_etudiant
JOIN Cours c ON c.id_cours = i.id_cours
WHERE c.titre_cours = 'SQL Database Basics'
ORDER BY e.nom;

-- 3.b List all courses a specific student (e.g., 'Alice') is enrolled in
SELECT c.id_cours, c.titre_cours, c.duree_heures, i.statut, i.note_finale
FROM Inscriptions i
JOIN Cours c ON c.id_cours = i.id_cours
JOIN Etudiants e ON e.id_etudiant = i.id_etudiant
WHERE e.nom LIKE 'El Moutaouakkel Houssam%'
ORDER BY c.titre_cours;

-- --------------------------------
-- Task 4: Find Unenrolled Students
-- --------------------------------

SELECT e.id_etudiant, e.nom, e.email
FROM Etudiants e
LEFT JOIN Inscriptions i ON i.id_etudiant = e.id_etudiant
WHERE i.id_inscription IS NULL
ORDER BY e.nom;

-- --------------------------------
-- Task 5: Data Modification
-- --------------------------------

-- 5.a UPDATE: Change oussama's grade in 'SQL Database Basics' from NULL to 85 (for a completed course)
UPDATE Inscriptions i
JOIN Etudiants e ON e.id_etudiant = i.id_etudiant
JOIN Cours c ON c.id_cours = i.id_cours
SET i.note_finale = 85
WHERE e.nom = 'Benzerouala Oussama'
  AND c.titre_cours = 'SQL Database Basics'
  AND i.statut = 'Terminé'
  AND i.note_finale IS NULL;

-- 5.b DELETE: Remove one inscription for a different student (e.g., islam on 'Data Structures' if exists)
-- In our seed, islam has 'Terminé' Data Structures; we'll delete that row.
DELETE i FROM Inscriptions i
JOIN Etudiants e ON e.id_etudiant = i.id_etudiant
JOIN Cours c ON c.id_cours = i.id_cours
WHERE e.nom = 'Chlih islam'
  AND c.titre_cours = 'Data Structures';

-- --------------------------------
-- Task 6: Advanced Analytical Queries
-- --------------------------------

-- 6.a Average grade per course (ignoring NULL grades)
SELECT c.id_cours, c.titre_cours, ROUND(AVG(i.note_finale), 2) AS moyenne_cours
FROM Inscriptions i
JOIN Cours c ON c.id_cours = i.id_cours
WHERE i.note_finale IS NOT NULL
GROUP BY c.id_cours, c.titre_cours
ORDER BY moyenne_cours DESC;

-- 6.b Top 3 most engaged students by number of completed courses
SELECT e.id_etudiant, e.nom,
       SUM(CASE WHEN i.statut = 'Terminé' THEN 1 ELSE 0 END) AS nb_cours_termines
FROM Etudiants e
LEFT JOIN Inscriptions i ON i.id_etudiant = e.id_etudiant
GROUP BY e.id_etudiant, e.nom
ORDER BY nb_cours_termines DESC, e.nom
LIMIT 3;

-- 6.c Most popular course by total inscriptions
SELECT c.id_cours, c.titre_cours, COUNT(*) AS total_inscriptions
FROM Inscriptions i
JOIN Cours c ON c.id_cours = i.id_cours
GROUP BY c.id_cours, c.titre_cours
ORDER BY total_inscriptions DESC, c.titre_cours
LIMIT 1;

-- 6.d Courses with average grade below 70/100 (courses needing review)
SELECT c.id_cours, c.titre_cours, ROUND(AVG(i.note_finale), 2) AS moyenne_cours
FROM Inscriptions i
JOIN Cours c ON c.id_cours = i.id_cours
WHERE i.note_finale IS NOT NULL
GROUP BY c.id_cours, c.titre_cours
HAVING AVG(i.note_finale) < 70
ORDER BY moyenne_cours ASC;
