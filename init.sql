-- ================================================
-- Visions Portfolio - Database Init Script
-- Generated automatically from frontend JSON data
-- ================================================

BEGIN;

-- Extensions
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Enum types
DO $$ BEGIN
  CREATE TYPE cv_skill_level AS ENUM ('advanced', 'intermediate', 'beginner', 'basic');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$ BEGIN
  CREATE TYPE skill_category AS ENUM ('frontend', 'backend', 'other');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

-- ================================================
-- CREATE TABLES
-- ================================================

CREATE TABLE IF NOT EXISTS "languages" (
  "id" SERIAL PRIMARY KEY,
  "code" VARCHAR(5) NOT NULL UNIQUE,
  "name" VARCHAR(50) NOT NULL,
  "isActive" BOOLEAN NOT NULL DEFAULT true,
  "isDefault" BOOLEAN NOT NULL DEFAULT false,
  "createdAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS "admins" (
  "id" SERIAL PRIMARY KEY,
  "username" VARCHAR(100) NOT NULL UNIQUE,
  "passwordHash" VARCHAR(255) NOT NULL,
  "createdAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS "projects" (
  "id" SERIAL PRIMARY KEY,
  "languageId" INTEGER NOT NULL REFERENCES "languages"("id"),
  "title" VARCHAR(200) NOT NULL,
  "description" TEXT NOT NULL,
  "imageUrl" VARCHAR(500),
  "demoLink" VARCHAR(500),
  "codeLink" VARCHAR(500),
  "featured" BOOLEAN NOT NULL DEFAULT false,
  "showDemo" BOOLEAN NOT NULL DEFAULT true,
  "showCode" BOOLEAN NOT NULL DEFAULT true,
  "orderIndex" INTEGER NOT NULL DEFAULT 0,
  "createdAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS "project_technologies" (
  "id" SERIAL PRIMARY KEY,
  "projectId" INTEGER NOT NULL REFERENCES "projects"("id") ON DELETE CASCADE,
  "technology" VARCHAR(100) NOT NULL,
  "orderIndex" INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS "skills" (
  "id" SERIAL PRIMARY KEY,
  "languageId" INTEGER NOT NULL REFERENCES "languages"("id"),
  "category" skill_category NOT NULL,
  "name" VARCHAR(100) NOT NULL,
  "level" VARCHAR(100) NOT NULL,
  "description" TEXT NOT NULL,
  "orderIndex" INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS "tech_stack_items" (
  "id" SERIAL PRIMARY KEY,
  "languageId" INTEGER NOT NULL REFERENCES "languages"("id"),
  "name" VARCHAR(100) NOT NULL,
  "orderIndex" INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS "cv_profiles" (
  "id" SERIAL PRIMARY KEY,
  "languageId" INTEGER NOT NULL UNIQUE REFERENCES "languages"("id"),
  "content" TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS "cv_skills" (
  "id" SERIAL PRIMARY KEY,
  "languageId" INTEGER NOT NULL REFERENCES "languages"("id"),
  "level" cv_skill_level NOT NULL,
  "name" VARCHAR(100) NOT NULL,
  "orderIndex" INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS "work_experiences" (
  "id" SERIAL PRIMARY KEY,
  "languageId" INTEGER NOT NULL REFERENCES "languages"("id"),
  "period" VARCHAR(100) NOT NULL,
  "title" VARCHAR(200) NOT NULL,
  "location" VARCHAR(200) NOT NULL,
  "responsibilities" JSONB NOT NULL DEFAULT '[]',
  "orderIndex" INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS "educations" (
  "id" SERIAL PRIMARY KEY,
  "languageId" INTEGER NOT NULL REFERENCES "languages"("id"),
  "period" VARCHAR(100) NOT NULL,
  "degree" VARCHAR(200) NOT NULL,
  "institution" VARCHAR(200),
  "location" VARCHAR(200) NOT NULL,
  "details" JSONB NOT NULL DEFAULT '[]',
  "orderIndex" INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS "certifications" (
  "id" SERIAL PRIMARY KEY,
  "languageId" INTEGER NOT NULL REFERENCES "languages"("id"),
  "degree" VARCHAR(300) NOT NULL,
  "period" VARCHAR(100) NOT NULL,
  "location" VARCHAR(200) NOT NULL,
  "details" JSONB NOT NULL DEFAULT '[]',
  "orderIndex" INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS "cv_languages" (
  "id" SERIAL PRIMARY KEY,
  "languageId" INTEGER NOT NULL REFERENCES "languages"("id"),
  "name" VARCHAR(100) NOT NULL,
  "level" VARCHAR(100) NOT NULL,
  "orderIndex" INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS "cv_references" (
  "id" SERIAL PRIMARY KEY,
  "languageId" INTEGER NOT NULL REFERENCES "languages"("id"),
  "name" VARCHAR(200) NOT NULL,
  "position" VARCHAR(300) NOT NULL,
  "contact" VARCHAR(200) NOT NULL,
  "website" VARCHAR(300),
  "phone" VARCHAR(50),
  "orderIndex" INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS "hobbies" (
  "id" SERIAL PRIMARY KEY,
  "languageId" INTEGER NOT NULL REFERENCES "languages"("id"),
  "name" VARCHAR(100) NOT NULL,
  "description" TEXT NOT NULL,
  "orderIndex" INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS "contact_info" (
  "id" SERIAL PRIMARY KEY,
  "languageId" INTEGER NOT NULL UNIQUE REFERENCES "languages"("id"),
  "nationality" VARCHAR(100),
  "birthdate" VARCHAR(20),
  "email" VARCHAR(200),
  "phone" VARCHAR(50),
  "address" VARCHAR(300),
  "linkedin" VARCHAR(300),
  "portfolio" VARCHAR(300),
  "github" VARCHAR(300)
);

CREATE TABLE IF NOT EXISTS "translations" (
  "id" SERIAL PRIMARY KEY,
  "languageCode" VARCHAR(5) NOT NULL,
  "namespace" VARCHAR(150) NOT NULL,
  "key" VARCHAR(150) NOT NULL,
  "value" TEXT NOT NULL,
  UNIQUE ("languageCode", "namespace", "key")
);

CREATE TABLE IF NOT EXISTS "blog_posts" (
  "id" SERIAL PRIMARY KEY,
  "slug" VARCHAR(300) NOT NULL UNIQUE,
  "coverImageUrl" VARCHAR(500),
  "isPublished" BOOLEAN NOT NULL DEFAULT false,
  "publishedAt" TIMESTAMP,
  "createdAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS "blog_post_translations" (
  "id" SERIAL PRIMARY KEY,
  "postId" INTEGER NOT NULL REFERENCES "blog_posts"("id") ON DELETE CASCADE,
  "languageId" INTEGER NOT NULL REFERENCES "languages"("id"),
  "title" VARCHAR(300) NOT NULL,
  "description" TEXT,
  "isVisible" BOOLEAN NOT NULL DEFAULT true,
  UNIQUE ("postId", "languageId")
);

CREATE TABLE IF NOT EXISTS "blog_blocks" (
  "id" SERIAL PRIMARY KEY,
  "translationId" INTEGER NOT NULL REFERENCES "blog_post_translations"("id") ON DELETE CASCADE,
  "type" VARCHAR(50) NOT NULL,
  "content" TEXT,
  "metadata" JSONB,
  "orderIndex" INTEGER NOT NULL DEFAULT 0
);

-- Add FK for translations if not exists (languageCode → languages.code)
DO $$ BEGIN
  ALTER TABLE "translations" ADD CONSTRAINT "fk_translations_language"
    FOREIGN KEY ("languageCode") REFERENCES "languages"("code") ON DELETE CASCADE;
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

-- ================================================
-- INSERT SEED DATA
-- ================================================

-- Languages
INSERT INTO "languages" ("code", "name", "isActive", "isDefault") VALUES ('en', 'English', true, true) ON CONFLICT ("code") DO NOTHING;
INSERT INTO "languages" ("code", "name", "isActive", "isDefault") VALUES ('de', 'Deutsch', true, false) ON CONFLICT ("code") DO NOTHING;
INSERT INTO "languages" ("code", "name", "isActive", "isDefault") VALUES ('ru', 'Russian', true, false) ON CONFLICT ("code") DO NOTHING;
INSERT INTO "languages" ("code", "name", "isActive", "isDefault") VALUES ('tr', 'Turkish', true, false) ON CONFLICT ("code") DO NOTHING;
INSERT INTO "languages" ("code", "name", "isActive", "isDefault") VALUES ('ua', 'Ukrainian', true, false) ON CONFLICT ("code") DO NOTHING;

-- Admin (password: admin123 - CHANGE THIS!)
INSERT INTO "admins" ("username", "passwordHash") VALUES ('admin', '$2b$10$EIXe0Rx6EGfyRjL9JkFmxeJfYhOSaRqiKn5e6IfjMdI./O8Bp8UXO') ON CONFLICT ("username") DO NOTHING;

-- ================================================
-- Projects & Technologies
-- ================================================

-- Projects for en
INSERT INTO "projects" ("languageId", "title", "description", "imageUrl", "demoLink", "codeLink", "featured", "showDemo", "showCode", "orderIndex")
  VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'visions.shkrsltn', 'Me newest responsive portfolio what you are seeing now, built with Angular, OpenAI API, and SASS/SCSS, featuring animations and interactive elements', '/images/project-images/visions-shkrsltnv.png', 'https://shkrsltn.github.io/visions.shkrsltn/', 'https://github.com/ShkrSltn/visions.shkrsltn.git', true, false, true, 0);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Angular', 0);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'TypeScript', 1);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'OpenAI API', 2);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'SASS/SCSS', 3);

INSERT INTO "projects" ("languageId", "title", "description", "imageUrl", "demoLink", "codeLink", "featured", "showDemo", "showCode", "orderIndex")
  VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'SAFI', 'SAFI visualizes social relationships, well-being and the climate in school classes and thus supports teachers in promoting social processes.', '/images/project-images/safi-survey.png', 'https://safi-demo.example.com', 'https://github.com/ShkrSltn/dashboard', true, false, false, 1);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Vue.js', 0);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'JavaScript/TypeScript', 1);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'HTML/CSS', 2);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'D3.js', 3);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'FastAPI/Python', 4);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'PostgreSQL', 5);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Docker', 6);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'GitLab/Git', 7);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Google Cloud Platform', 8);

INSERT INTO "projects" ("languageId", "title", "description", "imageUrl", "demoLink", "codeLink", "featured", "showDemo", "showCode", "orderIndex")
  VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'Green Kidney App', 'Interactive quiz application focused on eco-friendly kidney health, developed for a medical conference in Bangalore, India', '/images/project-images/green-admin.png', 'https://green-kidney.example.com', 'private-repository', true, false, false, 2);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Vue.js/JavaScript', 0);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'TypeScript', 1);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'FastAPI/Python', 2);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Docker', 3);

INSERT INTO "projects" ("languageId", "title", "description", "imageUrl", "demoLink", "codeLink", "featured", "showDemo", "showCode", "orderIndex")
  VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'FaciMath', 'Hobby project about generating math problems and solving them.', '/images/project-images/facimath1-main.png', 'https://shkrsltn.github.io/Recede-the-math/', 'https://github.com/ShkrSltn/Recede-the-math', false, true, true, 3);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Angular', 0);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'TypeScript', 1);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'HTML/CSS', 2);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Spring Boot/Java', 3);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'PostgreSQL', 4);

INSERT INTO "projects" ("languageId", "title", "description", "imageUrl", "demoLink", "codeLink", "featured", "showDemo", "showCode", "orderIndex")
  VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'FaciMathPro', 'Updated version of FaciMath, with a more user-friendly interface and improved functionality.', '/images/project-images/facimath2.png', 'https://shkrsltn.github.io/Recede-the-math/', 'https://github.com/ShkrSltn/faci-math2.0.git', false, false, true, 4);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Angular', 0);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'TypeScript', 1);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'HTML/CSS', 2);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Spring Boot/Java', 3);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'PostgreSQL', 4);

INSERT INTO "projects" ("languageId", "title", "description", "imageUrl", "demoLink", "codeLink", "featured", "showDemo", "showCode", "orderIndex")
  VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'Legacy portfolio', 'My old portfolio, built with vanilla JavaScript, HTML, and SCSS. There also my old projects for learning purposes and some other stuff.', '/images/project-images/legacy-portfolio.png', 'https://tourmaline-gingersnap-95959a.netlify.app/projects/', 'https://github.com/ShkrSltn/carpool-app-vue', false, true, false, 5);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'JavaScript', 0);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'HTML', 1);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'SCSS', 2);

-- Projects for de
INSERT INTO "projects" ("languageId", "title", "description", "imageUrl", "demoLink", "codeLink", "featured", "showDemo", "showCode", "orderIndex")
  VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'visions.shkrsltn', 'Mein neuestes responsive Portfolio, das du jetzt siehst, wurde mit Angular, OpenAI API und SASS/SCSS erstellt, mit Animationen und interaktiven Elementen', '/images/project-images/visions-shkrsltnv.png', 'https://shkrsltn.github.io/visions.shkrsltn/', 'https://github.com/ShkrSltn/visions.shkrsltn.git', true, false, true, 0);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Angular', 0);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'TypeScript', 1);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'OpenAI API', 2);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'SASS/SCSS', 3);

INSERT INTO "projects" ("languageId", "title", "description", "imageUrl", "demoLink", "codeLink", "featured", "showDemo", "showCode", "orderIndex")
  VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'SAFI', 'SAFI visualisiert soziale Beziehungen, Wohlbefinden und Klima in Schulklassen und unterstützt somit Lehrkräfte bei der Förderung sozialer Prozesse.', '/images/project-images/safi-survey.png', 'https://safi-demo.example.com', 'https://github.com/ShkrSltn/dashboard', true, false, false, 1);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Vue.js', 0);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'JavaScript/TypeScript', 1);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'HTML/CSS', 2);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'D3.js', 3);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'FastAPI/Python', 4);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'PostgreSQL', 5);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Docker', 6);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'GitLab/Git', 7);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Google Cloud Platform', 8);

INSERT INTO "projects" ("languageId", "title", "description", "imageUrl", "demoLink", "codeLink", "featured", "showDemo", "showCode", "orderIndex")
  VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'Green Kidney App', 'Interaktive Quiz-Anwendung, die sich auf umweltfreundliche Nierengesundheit konzentriert, entwickelt für ein Medizin-Konferenz in Bangalore, Indien', '/images/project-images/green-admin.png', 'https://green-kidney.example.com', 'private-repository', true, false, false, 2);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Vue.js/JavaScript', 0);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'TypeScript', 1);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'FastAPI/Python', 2);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Docker', 3);

INSERT INTO "projects" ("languageId", "title", "description", "imageUrl", "demoLink", "codeLink", "featured", "showDemo", "showCode", "orderIndex")
  VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'FaciMath', 'Ein Hobby-Projekt über das Generieren von Mathe-Problemen und das Lösen von ihnen.', '/images/project-images/facimath1-main.png', 'https://shkrsltn.github.io/Recede-the-math/', 'https://github.com/ShkrSltn/Recede-the-math', false, true, true, 3);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Angular', 0);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'TypeScript', 1);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'HTML/CSS', 2);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Spring Boot/Java', 3);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'PostgreSQL', 4);

INSERT INTO "projects" ("languageId", "title", "description", "imageUrl", "demoLink", "codeLink", "featured", "showDemo", "showCode", "orderIndex")
  VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'FaciMathPro', 'Aktualisierte Version von FaciMath, mit einer benutzerfreundlicheren Oberfläche und verbesserten Funktionen.', '/images/project-images/facimath2.png', 'https://shkrsltn.github.io/Recede-the-math/', 'https://github.com/ShkrSltn/faci-math2.0.git', false, false, true, 4);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Angular', 0);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'TypeScript', 1);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'HTML/CSS', 2);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Spring Boot/Java', 3);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'PostgreSQL', 4);

INSERT INTO "projects" ("languageId", "title", "description", "imageUrl", "demoLink", "codeLink", "featured", "showDemo", "showCode", "orderIndex")
  VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'Legacy portfolio', 'Mein altes Portfolio, das mit Vanilla JavaScript, HTML und SCSS erstellt wurde. Dort sind auch meine alten Projekte für Lernzwecke und andere Dinge.', '/images/project-images/legacy-portfolio.png', 'https://tourmaline-gingersnap-95959a.netlify.app/projects/', 'https://github.com/ShkrSltn/carpool-app-vue', false, true, false, 5);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'JavaScript', 0);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'HTML', 1);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'SCSS', 2);

-- Projects for ru
INSERT INTO "projects" ("languageId", "title", "description", "imageUrl", "demoLink", "codeLink", "featured", "showDemo", "showCode", "orderIndex")
  VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'visions.shkrsltn', 'Мой самый новый responsive портфолио, построенный с помощью Angular, OpenAI API и SASS/SCSS, с анимациями и интерактивными элементами', '/images/project-images/visions-shkrsltnv.png', 'https://shkrsltn.github.io/visions.shkrsltn/', 'https://github.com/ShkrSltn/visions.shkrsltn.git', true, false, true, 0);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Angular', 0);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'TypeScript', 1);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'OpenAI API', 2);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'SASS/SCSS', 3);

INSERT INTO "projects" ("languageId", "title", "description", "imageUrl", "demoLink", "codeLink", "featured", "showDemo", "showCode", "orderIndex")
  VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'SAFI', 'SAFI визуализирует социальные отношения, благополучие и климат в классах школы и, таким образом, поддерживает учителей в продвижении социальных процессов.', '/images/project-images/safi-survey.png', 'https://safi-demo.example.com', 'https://github.com/ShkrSltn/dashboard', true, false, false, 1);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Vue.js', 0);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'JavaScript/TypeScript', 1);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'HTML/CSS', 2);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'D3.js', 3);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'FastAPI/Python', 4);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'PostgreSQL', 5);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Docker', 6);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'GitLab/Git', 7);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Google Cloud Platform', 8);

INSERT INTO "projects" ("languageId", "title", "description", "imageUrl", "demoLink", "codeLink", "featured", "showDemo", "showCode", "orderIndex")
  VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'Green Kidney App', 'Интерактивное приложение для викторины, фокусирующееся на экологически чистом здоровье почек, разработанное для медицинской конференции в Бангалоре, Индия', '/images/project-images/green-admin.png', 'https://green-kidney.example.com', 'private-repository', true, false, false, 2);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Vue.js/JavaScript', 0);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'TypeScript', 1);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'FastAPI/Python', 2);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Docker', 3);

INSERT INTO "projects" ("languageId", "title", "description", "imageUrl", "demoLink", "codeLink", "featured", "showDemo", "showCode", "orderIndex")
  VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'FaciMath', 'Хобби-проект по генерации математических задач и их решениям.', '/images/project-images/facimath1-main.png', 'https://shkrsltn.github.io/Recede-the-math/', 'https://github.com/ShkrSltn/Recede-the-math', false, true, true, 3);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Angular', 0);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'TypeScript', 1);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'HTML/CSS', 2);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Spring Boot/Java', 3);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'PostgreSQL', 4);

INSERT INTO "projects" ("languageId", "title", "description", "imageUrl", "demoLink", "codeLink", "featured", "showDemo", "showCode", "orderIndex")
  VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'FaciMathPro', 'Обновленная версия FaciMath, с более удобным интерфейсом и улучшенной функциональностью.', '/images/project-images/facimath2.png', 'https://shkrsltn.github.io/Recede-the-math/', 'https://github.com/ShkrSltn/faci-math2.0.git', false, false, true, 4);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Angular', 0);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'TypeScript', 1);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'HTML/CSS', 2);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Spring Boot/Java', 3);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'PostgreSQL', 4);

INSERT INTO "projects" ("languageId", "title", "description", "imageUrl", "demoLink", "codeLink", "featured", "showDemo", "showCode", "orderIndex")
  VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'Legacy portfolio', 'Мой старый портфолио, построенный с помощью vanilla JavaScript, HTML и SCSS. Там также мои старые проекты для обучения и другие вещи.', '/images/project-images/legacy-portfolio.png', 'https://tourmaline-gingersnap-95959a.netlify.app/projects/', 'https://github.com/ShkrSltn/carpool-app-vue', false, true, false, 5);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'JavaScript', 0);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'HTML', 1);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'SCSS', 2);

-- Projects for tr
INSERT INTO "projects" ("languageId", "title", "description", "imageUrl", "demoLink", "codeLink", "featured", "showDemo", "showCode", "orderIndex")
  VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'visions.shkrsltn', 'Benim en yeni responsive portfölüm, Angular, OpenAI API ve SASS/SCSS kullanılarak oluşturulmuştur, animasyonlar ve etkileşimli öğeler içerir', '/images/project-images/visions-shkrsltnv.png', 'https://shkrsltn.github.io/visions.shkrsltn/', 'https://github.com/ShkrSltn/visions.shkrsltn.git', true, false, true, 0);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Angular', 0);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'TypeScript', 1);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'OpenAI API', 2);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'SASS/SCSS', 3);

INSERT INTO "projects" ("languageId", "title", "description", "imageUrl", "demoLink", "codeLink", "featured", "showDemo", "showCode", "orderIndex")
  VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'SAFI', 'SAFI, sosyal ilişkiler, mutluluk ve okul sınıflarındaki iklimi görselleştirir ve böylece öğretmenlerin sosyal süreçleri teşvik etmesine destek olur.', '/images/project-images/safi-survey.png', 'https://safi-demo.example.com', 'https://github.com/ShkrSltn/dashboard', true, false, false, 1);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Vue.js', 0);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'JavaScript/TypeScript', 1);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'HTML/CSS', 2);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'D3.js', 3);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'FastAPI/Python', 4);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'PostgreSQL', 5);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Docker', 6);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'GitLab/Git', 7);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Google Cloud Platform', 8);

INSERT INTO "projects" ("languageId", "title", "description", "imageUrl", "demoLink", "codeLink", "featured", "showDemo", "showCode", "orderIndex")
  VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'Green Kidney App', 'Ekolojik olarak temiz sağlık için odaklanan bir etkileşimli uygulama, Hindistan''daki bir tıp konferansı için geliştirildi', '/images/project-images/green-admin.png', 'https://green-kidney.example.com', 'private-repository', true, false, false, 2);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Vue.js/JavaScript', 0);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'TypeScript', 1);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'FastAPI/Python', 2);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Docker', 3);

INSERT INTO "projects" ("languageId", "title", "description", "imageUrl", "demoLink", "codeLink", "featured", "showDemo", "showCode", "orderIndex")
  VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'FaciMath', 'Matematiksel problemler üretmek ve çözmek için bir hobiproje.', '/images/project-images/facimath1-main.png', 'https://shkrsltn.github.io/Recede-the-math/', 'https://github.com/ShkrSltn/Recede-the-math', false, true, true, 3);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Angular', 0);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'TypeScript', 1);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'HTML/CSS', 2);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Spring Boot/Java', 3);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'PostgreSQL', 4);

INSERT INTO "projects" ("languageId", "title", "description", "imageUrl", "demoLink", "codeLink", "featured", "showDemo", "showCode", "orderIndex")
  VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'FaciMathPro', 'Geliştirilmiş bir versiyonu, daha kullanışlı bir arayüz ve geliştirilmiş işlevsellik.', '/images/project-images/facimath2.png', 'https://shkrsltn.github.io/Recede-the-math/', 'https://github.com/ShkrSltn/faci-math2.0.git', false, false, true, 4);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Angular', 0);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'TypeScript', 1);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'HTML/CSS', 2);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Spring Boot/Java', 3);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'PostgreSQL', 4);

INSERT INTO "projects" ("languageId", "title", "description", "imageUrl", "demoLink", "codeLink", "featured", "showDemo", "showCode", "orderIndex")
  VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'Legacy portfolio', 'Benim eski portfölümüm, vanilla JavaScript, HTML ve SCSS kullanılarak oluşturulmuştur. Orada aynı zamanda benim eski projelerim öğrenme amacıyla ve diğer şeyler için de vardır.', '/images/project-images/legacy-portfolio.png', 'https://tourmaline-gingersnap-95959a.netlify.app/projects/', 'https://github.com/ShkrSltn/carpool-app-vue', false, true, false, 5);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'JavaScript', 0);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'HTML', 1);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'SCSS', 2);

-- Projects for ua
INSERT INTO "projects" ("languageId", "title", "description", "imageUrl", "demoLink", "codeLink", "featured", "showDemo", "showCode", "orderIndex")
  VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'visions.shkrsltn', 'Найновеший респонсивний портфоліо, яке ви бачите зараз, побудований з Angular, OpenAI API та SASS/SCSS, з анімаціями та інтерактивними елементами', '/images/project-images/visions-shkrsltnv.png', 'https://shkrsltn.github.io/visions.shkrsltn/', 'https://github.com/ShkrSltn/visions.shkrsltn.git', true, false, true, 0);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Angular', 0);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'TypeScript', 1);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'OpenAI API', 2);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'SASS/SCSS', 3);

INSERT INTO "projects" ("languageId", "title", "description", "imageUrl", "demoLink", "codeLink", "featured", "showDemo", "showCode", "orderIndex")
  VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'SAFI', 'SAFI візуалізує соціальні відносини, благополуччя та клімат у школах і підтримує вчителів у просуванні соціальних процесів.', '/images/project-images/safi-survey.png', 'https://safi-demo.example.com', 'https://github.com/ShkrSltn/dashboard', true, false, false, 1);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Vue.js', 0);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'JavaScript/TypeScript', 1);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'HTML/CSS', 2);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'D3.js', 3);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'FastAPI/Python', 4);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'PostgreSQL', 5);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Docker', 6);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'GitLab/Git', 7);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Google Cloud Platform', 8);

INSERT INTO "projects" ("languageId", "title", "description", "imageUrl", "demoLink", "codeLink", "featured", "showDemo", "showCode", "orderIndex")
  VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'Green Kidney App', 'Інтерактивна запитання-відповідь програма, яка зосереджена на екологічно чистому здоров''я нирок, розроблена для медичної конференції в Бангалорі, Індія', '/images/project-images/green-admin.png', 'https://green-kidney.example.com', 'private-repository', true, false, false, 2);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Vue.js/JavaScript', 0);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'TypeScript', 1);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'FastAPI/Python', 2);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Docker', 3);

INSERT INTO "projects" ("languageId", "title", "description", "imageUrl", "demoLink", "codeLink", "featured", "showDemo", "showCode", "orderIndex")
  VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'FaciMath', 'Хоббі-проект про генерацію математичних завдань та їх розв''язання.', '/images/project-images/facimath1-main.png', 'https://shkrsltn.github.io/Recede-the-math/', 'https://github.com/ShkrSltn/Recede-the-math', false, true, true, 3);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Angular', 0);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'TypeScript', 1);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'HTML/CSS', 2);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Spring Boot/Java', 3);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'PostgreSQL', 4);

INSERT INTO "projects" ("languageId", "title", "description", "imageUrl", "demoLink", "codeLink", "featured", "showDemo", "showCode", "orderIndex")
  VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'FaciMathPro', 'Оновлена версія FaciMath, з більш користувацьким інтерфейсом та покращеною функціональністю.', '/images/project-images/facimath2.png', 'https://shkrsltn.github.io/Recede-the-math/', 'https://github.com/ShkrSltn/faci-math2.0.git', false, false, true, 4);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Angular', 0);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'TypeScript', 1);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'HTML/CSS', 2);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'Spring Boot/Java', 3);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'PostgreSQL', 4);

INSERT INTO "projects" ("languageId", "title", "description", "imageUrl", "demoLink", "codeLink", "featured", "showDemo", "showCode", "orderIndex")
  VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'Legacy portfolio', 'Мій старий портфоліо, побудований з vanilla JavaScript, HTML та SCSS. Там також мої старі проекти для навчальних цілей та інші речі.', '/images/project-images/legacy-portfolio.png', 'https://tourmaline-gingersnap-95959a.netlify.app/projects/', 'https://github.com/ShkrSltn/carpool-app-vue', false, true, false, 5);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'JavaScript', 0);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'HTML', 1);
INSERT INTO "project_technologies" ("projectId", "technology", "orderIndex")
  VALUES (currval(pg_get_serial_sequence('"projects"', 'id')), 'SCSS', 2);

-- ================================================
-- Skills & Tech Stack
-- ================================================

-- Skills for en
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'frontend', 'HTML5 & CSS3', 'Good enough', 'Creating responsive, accessible, and semantically structured web pages using modern CSS techniques, including Grid and Flexbox.', 0);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'frontend', 'JavaScript', 'Good enough', 'Developing interactive web applications using ES6+ features, asynchronous programming, and DOM manipulation.', 1);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'frontend', 'TypeScript', 'Not bad', 'Developing type-safe applications using interfaces, generics, and advanced typing capabilities.', 2);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'frontend', 'Angular', 'I think not bad', 'Creating component-oriented applications using services, routing, and state management.', 3);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'frontend', 'Vue.js', 'A lot', 'Have experience with Vue.js, we are using Vue in almost every our projects.', 4);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'frontend', 'React', 'Basic knowledge', 'Understanding of component-based architecture, hooks, and state management with Redux.', 5);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'frontend', 'SASS/SCSS', 'Comfortable', 'Using preprocessors for more maintainable and organized CSS with variables, mixins, and nesting.', 6);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'backend', 'Spring Boot', 'Worked some', 'Developing server applications using event-driven architecture and non-blocking I/O operations.', 0);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'backend', 'FastAPI', 'More than enough', 'Creating RESTful APIs using middleware, routing, and error handling.', 1);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'backend', 'PostgreSQL', 'I am good at this', 'Working with advanced relational database features including indexing, transactions, and stored procedures.', 2);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'backend', 'SQL', 'Good enough', 'Working with relational databases, writing queries, and managing database relationships.', 3);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'backend', 'Java', 'More than basics', 'Developing enterprise applications using Spring Boot and other frameworks.', 4);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'backend', 'Python', 'Current active', 'Creating automation scripts, data analysis, and developing web applications using Django and Flask.', 5);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'backend', 'C#', 'Basics', 'Knowledge in syntax and understanding object-oriented principles.', 6);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'other', 'Git & GitHub', 'Using every day', 'Version control, collaborative development, branching strategies, and CI/CD workflows.', 0);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'other', 'RESTful APIs', 'Standart way', 'Designing and consuming APIs according to REST principles, with proper status codes and error handling.', 1);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'other', 'Responsive Design', 'Should know', 'Creating layouts that adapt to different screen sizes using media queries and mobile-first approach.', 2);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'other', 'Docker', 'Did lots of times', 'Containerizing applications, creating and managing Docker images and containers.', 3);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'other', 'CI/CD', 'Few times', 'Setting up and maintaining continuous integration and delivery pipelines using GitHub Actions, GitLab CI/CD, and other tools.', 4);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'other', 'Google Cloud', 'Have some experience', 'Deployed all our projects in BFH to the Googe Cloud, using Docker Cloud Run, Cloud SQL and Artifact registry', 5);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'other', 'Agile Methodologies', 'Knowledge', 'Cons working for University, had chance to attend at the one week workshops related to the SCRUM and AGILE project management. Which I used in the further working process.', 6);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'JavaScript', 0);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'TypeScript', 1);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'Angular', 2);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'Vue.js', 3);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'Vanilla JS', 4);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'Python', 5);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'FastAPI', 6);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'Java', 7);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'Spring Boot', 8);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'C#', 9);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'Git - GitHub/GitLab', 10);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'Docker', 11);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'CI/CD', 12);

-- Skills for de
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'frontend', 'HTML5 & CSS3', 'Gut genug', 'Erstellung von responsiven, zugänglichen und semantisch strukturierten Webseiten mit modernen CSS-Techniken, einschließlich Grid und Flexbox.', 0);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'frontend', 'JavaScript', 'Gut genug', 'Entwicklung interaktiver Webanwendungen mit ES6+ Funktionen, asynchroner Programmierung und DOM-Manipulation.', 1);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'frontend', 'TypeScript', 'Nicht schlecht', 'Entwicklung typsicherer Anwendungen mit Interfaces, Generics und fortgeschrittenen Typisierungsfunktionen.', 2);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'frontend', 'Angular', 'Ich denke nicht schlecht', 'Erstellung komponentenorientierter Anwendungen mit Services, Routing und Zustandsmanagement.', 3);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'frontend', 'Vue.js', 'Viel', 'Habe Erfahrung mit Vue.js, wir verwenden Vue in fast allen unseren Projekten.', 4);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'frontend', 'React', 'Grundkenntnisse', 'Verständnis der komponentenbasierten Architektur, Hooks und Zustandsmanagement mit Redux.', 5);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'frontend', 'SASS/SCSS', 'Komfortabel', 'Verwendung von Präprozessoren für besser wartbares und organisiertes CSS mit Variablen, Mixins und Verschachtelung.', 6);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'backend', 'Spring Boot', 'Etwas gearbeitet', 'Entwicklung von Serveranwendungen mit ereignisgesteuerter Architektur und nicht-blockierenden I/O-Operationen.', 0);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'backend', 'FastAPI', 'Mehr als genug', 'Erstellung von RESTful APIs mit Middleware, Routing und Fehlerbehandlung.', 1);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'backend', 'PostgreSQL', 'Ich bin gut darin', 'Arbeit mit fortgeschrittenen relationalen Datenbankfunktionen einschließlich Indizierung, Transaktionen und gespeicherten Prozeduren.', 2);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'backend', 'SQL', 'Gut genug', 'Arbeit mit relationalen Datenbanken, Schreiben von Abfragen und Verwaltung von Datenbankbeziehungen.', 3);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'backend', 'Java', 'Mehr als Grundlagen', 'Entwicklung von Unternehmensanwendungen mit Spring Boot und anderen Frameworks.', 4);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'backend', 'Python', 'Aktuell aktiv', 'Erstellung von Automatisierungsskripten, Datenanalyse und Entwicklung von Webanwendungen mit Django und Flask.', 5);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'backend', 'C#', 'Grundlagen', 'Kenntnisse in Syntax und Verständnis objektorientierter Prinzipien.', 6);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'other', 'Git & GitHub', 'Täglich im Einsatz', 'Versionskontrolle, kollaborative Entwicklung, Branching-Strategien und CI/CD-Workflows.', 0);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'other', 'RESTful APIs', 'Standardweg', 'Design und Nutzung von APIs gemäß REST-Prinzipien, mit korrekten Statuscodes und Fehlerbehandlung.', 1);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'other', 'Responsive Design', 'Sollte man kennen', 'Erstellung von Layouts, die sich an verschiedene Bildschirmgrößen anpassen, mit Media Queries und Mobile-First-Ansatz.', 2);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'other', 'Docker', 'Viele Male gemacht', 'Containerisierung von Anwendungen, Erstellung und Verwaltung von Docker-Images und Containern.', 3);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'other', 'CI/CD', 'Einige Male', 'Einrichtung und Wartung von Continuous Integration und Delivery Pipelines mit GitHub Actions, GitLab CI/CD und anderen Tools.', 4);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'other', 'Google Cloud', 'Habe einige Erfahrung', 'Alle unsere Projekte in BFH in der Google Cloud bereitgestellt, mit Docker Cloud Run, Cloud SQL und Artifact Registry.', 5);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'other', 'Agile Methodologien', 'Kenntnisse', 'Vorteil der Arbeit an der Universität - hatte die Möglichkeit, an einwöchigen Workshops zu SCRUM und AGILE Projektmanagement teilzunehmen. Diese habe ich im weiteren Arbeitsprozess eingesetzt.', 6);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'JavaScript', 0);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'TypeScript', 1);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'Angular', 2);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'Vue.js', 3);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'Vanilla JS', 4);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'Python', 5);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'FastAPI', 6);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'Java', 7);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'Spring Boot', 8);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'C#', 9);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'Git - GitHub/GitLab', 10);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'Docker', 11);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'CI/CD', 12);

-- Skills for ru
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'frontend', 'HTML5 & CSS3', 'Достаточно хорошо', 'Создание адаптивных, доступных и семантически структурированных веб-страниц с использованием современных CSS-техник, включая Grid и Flexbox.', 0);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'frontend', 'JavaScript', 'Достаточно хорошо', 'Разработка интерактивных веб-приложений с использованием возможностей ES6+, асинхронного программирования и манипуляций с DOM.', 1);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'frontend', 'TypeScript', 'Неплохо', 'Разработка типобезопасных приложений с использованием интерфейсов, дженериков и продвинутых возможностей типизации.', 2);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'frontend', 'Angular', 'Думаю, неплохо', 'Создание компонентно-ориентированных приложений с использованием сервисов, маршрутизации и управления состоянием.', 3);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'frontend', 'Vue.js', 'Много', 'Имею опыт работы с Vue.js, мы используем Vue практически во всех наших проектах.', 4);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'frontend', 'React', 'Базовые знания', 'Понимание компонентной архитектуры, хуков и управления состоянием с помощью Redux.', 5);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'frontend', 'SASS/SCSS', 'Комфортно', 'Использование препроцессоров для более поддерживаемого и организованного CSS с переменными, миксинами и вложенностью.', 6);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'backend', 'Spring Boot', 'Немного работал', 'Разработка серверных приложений с использованием событийно-ориентированной архитектуры и неблокирующих операций ввода-вывода.', 0);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'backend', 'FastAPI', 'Более чем достаточно', 'Создание RESTful API с использованием промежуточного ПО, маршрутизации и обработки ошибок.', 1);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'backend', 'PostgreSQL', 'Хорошо разбираюсь', 'Работа с продвинутыми возможностями реляционных баз данных, включая индексирование, транзакции и хранимые процедуры.', 2);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'backend', 'SQL', 'Достаточно хорошо', 'Работа с реляционными базами данных, написание запросов и управление отношениями в базе данных.', 3);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'backend', 'Java', 'Больше чем основы', 'Разработка корпоративных приложений с использованием Spring Boot и других фреймворков.', 4);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'backend', 'Python', 'Текущий активный', 'Создание скриптов автоматизации, анализ данных и разработка веб-приложений с использованием Django и Flask.', 5);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'backend', 'C#', 'Основы', 'Знание синтаксиса и понимание принципов объектно-ориентированного программирования.', 6);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'other', 'Git & GitHub', 'Использую каждый день', 'Контроль версий, совместная разработка, стратегии ветвления и рабочие процессы CI/CD.', 0);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'other', 'RESTful APIs', 'Стандартный подход', 'Проектирование и использование API в соответствии с принципами REST, с правильными кодами состояния и обработкой ошибок.', 1);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'other', 'Responsive Design', 'Должен знать', 'Создание макетов, адаптирующихся к различным размерам экрана, с использованием медиа-запросов и подхода mobile-first.', 2);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'other', 'Docker', 'Делал много раз', 'Контейнеризация приложений, создание и управление Docker-образами и контейнерами.', 3);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'other', 'CI/CD', 'Несколько раз', 'Настройка и поддержка конвейеров непрерывной интеграции и доставки с использованием GitHub Actions, GitLab CI/CD и других инструментов.', 4);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'other', 'Google Cloud', 'Имею некоторый опыт', 'Развернул все наши проекты в BFH в Google Cloud, используя Docker Cloud Run, Cloud SQL и Artifact registry.', 5);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'other', 'Agile Методологии', 'Знания', 'Плюс работы в университете - была возможность посетить недельные семинары, связанные с управлением проектами по SCRUM и AGILE. Которые я использовал в дальнейшем рабочем процессе.', 6);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'JavaScript', 0);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'TypeScript', 1);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'Angular', 2);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'Vue.js', 3);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'Vanilla JS', 4);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'Python', 5);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'FastAPI', 6);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'Java', 7);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'Spring Boot', 8);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'C#', 9);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'Git - GitHub/GitLab', 10);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'Docker', 11);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'CI/CD', 12);

-- Skills for tr
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'frontend', 'HTML5 & CSS3', 'Yeterince iyi', 'Grid ve Flexbox dahil modern CSS teknikleri kullanarak duyarlı, erişilebilir ve anlamsal olarak yapılandırılmış web sayfaları oluşturma.', 0);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'frontend', 'JavaScript', 'Yeterince iyi', 'ES6+ özellikleri, asenkron programlama ve DOM manipülasyonu ile etkileşimli web uygulamaları geliştirme.', 1);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'frontend', 'TypeScript', 'Fena değil', 'Arayüzler, jenerikler ve gelişmiş tipleme özellikleri ile tip güvenli uygulamalar geliştirme.', 2);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'frontend', 'Angular', 'Sanırım fena değil', 'Servisler, yönlendirme ve durum yönetimi ile bileşen odaklı uygulamalar oluşturma.', 3);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'frontend', 'Vue.js', 'Çok', 'Vue.js ile deneyimim var, neredeyse tüm projelerimizde Vue kullanıyoruz.', 4);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'frontend', 'React', 'Temel bilgiler', 'Bileşen tabanlı mimari, kancalar ve Redux ile durum yönetimi anlayışı.', 5);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'frontend', 'SASS/SCSS', 'Rahat', 'Değişkenler, mixin''ler ve iç içe geçme ile daha sürdürülebilir ve organize CSS için ön işlemcilerin kullanımı.', 6);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'backend', 'Spring Boot', 'Biraz çalıştım', 'Olay odaklı mimari ve engellenmeyen G/Ç işlemleri ile sunucu uygulamaları geliştirme.', 0);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'backend', 'FastAPI', 'Fazlasıyla yeterli', 'Ara yazılım, yönlendirme ve hata işleme ile RESTful API''ler oluşturma.', 1);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'backend', 'PostgreSQL', 'İyi biliyorum', 'İndeksleme, işlemler ve saklı prosedürler dahil gelişmiş ilişkisel veritabanı özellikleriyle çalışma.', 2);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'backend', 'SQL', 'Yeterince iyi', 'İlişkisel veritabanlarıyla çalışma, sorgular yazma ve veritabanı ilişkilerini yönetme.', 3);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'backend', 'Java', 'Temellerden fazlası', 'Spring Boot ve diğer çerçevelerle kurumsal uygulamalar geliştirme.', 4);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'backend', 'Python', 'Şu anda aktif', 'Otomasyon komut dosyaları oluşturma, veri analizi ve Django ve Flask ile web uygulamaları geliştirme.', 5);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'backend', 'C#', 'Temeller', 'Sözdizimi bilgisi ve nesne yönelimli programlama ilkelerini anlama.', 6);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'other', 'Git & GitHub', 'Her gün kullanıyorum', 'Sürüm kontrolü, işbirlikçi geliştirme, dallanma stratejileri ve CI/CD iş akışları.', 0);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'other', 'RESTful APIs', 'Standart yaklaşım', 'Doğru durum kodları ve hata işleme ile REST ilkelerine göre API''lerin tasarımı ve kullanımı.', 1);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'other', 'Responsive Design', 'Bilmek gerekir', 'Medya sorguları ve mobil öncelikli yaklaşım kullanarak farklı ekran boyutlarına uyum sağlayan düzenler oluşturma.', 2);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'other', 'Docker', 'Çok kez yaptım', 'Uygulamaların konteynerleştirilmesi, Docker imajları ve konteynerlerinin oluşturulması ve yönetilmesi.', 3);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'other', 'CI/CD', 'Birkaç kez', 'GitHub Actions, GitLab CI/CD ve diğer araçlarla sürekli entegrasyon ve teslimat boru hatlarının kurulumu ve bakımı.', 4);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'other', 'Google Cloud', 'Biraz deneyimim var', 'BFH''deki tüm projelerimizi Docker Cloud Run, Cloud SQL ve Artifact Registry kullanarak Google Cloud''da dağıttık.', 5);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'other', 'Agile Metodolojileri', 'Bilgi', 'Üniversitede çalışmanın avantajı - SCRUM ve AGILE proje yönetimiyle ilgili bir haftalık çalıştaylara katılma fırsatım oldu. Bunları daha sonraki iş sürecimde kullandım.', 6);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'JavaScript', 0);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'TypeScript', 1);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'Angular', 2);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'Vue.js', 3);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'Vanilla JS', 4);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'Python', 5);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'FastAPI', 6);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'Java', 7);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'Spring Boot', 8);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'C#', 9);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'Git - GitHub/GitLab', 10);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'Docker', 11);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'CI/CD', 12);

-- Skills for ua
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'frontend', 'HTML5 & CSS3', 'Достатньо добре', 'Створення адаптивних, доступних та семантично структурованих веб-сторінок з використанням сучасних CSS-технік, включаючи Grid та Flexbox.', 0);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'frontend', 'JavaScript', 'Достатньо добре', 'Розробка інтерактивних веб-додатків з використанням можливостей ES6+, асинхронного програмування та маніпуляцій з DOM.', 1);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'frontend', 'TypeScript', 'Непогано', 'Розробка типобезпечних додатків з використанням інтерфейсів, дженериків та просунутих можливостей типізації.', 2);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'frontend', 'Angular', 'Думаю, непогано', 'Створення компонентно-орієнтованих додатків з використанням сервісів, маршрутизації та управління станом.', 3);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'frontend', 'Vue.js', 'Багато', 'Маю досвід роботи з Vue.js, ми використовуємо Vue практично у всіх наших проектах.', 4);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'frontend', 'React', 'Базові знання', 'Розуміння компонентної архітектури, хуків та управління станом за допомогою Redux.', 5);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'frontend', 'SASS/SCSS', 'Комфортно', 'Використання препроцесорів для більш підтримуваного та організованого CSS з змінними, міксинами та вкладеністю.', 6);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'backend', 'Spring Boot', 'Трохи працював', 'Розробка серверних додатків з використанням подієво-орієнтованої архітектури та неблокуючих операцій введення-виведення.', 0);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'backend', 'FastAPI', 'Більш ніж достатньо', 'Створення RESTful API з використанням проміжного ПЗ, маршрутизації та обробки помилок.', 1);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'backend', 'PostgreSQL', 'Добре розбираюсь', 'Робота з просунутими можливостями реляційних баз даних, включаючи індексування, транзакції та збережені процедури.', 2);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'backend', 'SQL', 'Достатньо добре', 'Робота з реляційними базами даних, написання запитів та управління відносинами в базі даних.', 3);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'backend', 'Java', 'Більше ніж основи', 'Розробка корпоративних додатків з використанням Spring Boot та інших фреймворків.', 4);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'backend', 'Python', 'Поточний активний', 'Створення скриптів автоматизації, аналіз даних та розробка веб-додатків з використанням Django та Flask.', 5);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'backend', 'C#', 'Основи', 'Знання синтаксису та розуміння принципів об''єктно-орієнтованого програмування.', 6);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'other', 'Git & GitHub', 'Використовую щодня', 'Контроль версій, спільна розробка, стратегії гілкування та робочі процеси CI/CD.', 0);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'other', 'RESTful APIs', 'Стандартний підхід', 'Проектування та використання API відповідно до принципів REST, з правильними кодами стану та обробкою помилок.', 1);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'other', 'Responsive Design', 'Повинен знати', 'Створення макетів, що адаптуються до різних розмірів екрану, з використанням медіа-запитів та підходу mobile-first.', 2);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'other', 'Docker', 'Робив багато разів', 'Контейнеризація додатків, створення та управління Docker-образами та контейнерами.', 3);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'other', 'CI/CD', 'Кілька разів', 'Налаштування та підтримка конвеєрів безперервної інтеграції та доставки з використанням GitHub Actions, GitLab CI/CD та інших інструментів.', 4);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'other', 'Google Cloud', 'Маю деякий досвід', 'Розгорнув усі наші проекти в BFH в Google Cloud, використовуючи Docker Cloud Run, Cloud SQL та Artifact registry.', 5);
INSERT INTO "skills" ("languageId", "category", "name", "level", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'other', 'Agile Методології', 'Знання', 'Плюс роботи в університеті - була можливість відвідати тижневі семінари, пов''язані з управлінням проектами за SCRUM та AGILE. Які я використовував у подальшому робочому процесі.', 6);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'JavaScript', 0);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'TypeScript', 1);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'Angular', 2);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'Vue.js', 3);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'Vanilla JS', 4);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'Python', 5);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'FastAPI', 6);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'Java', 7);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'Spring Boot', 8);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'C#', 9);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'Git - GitHub/GitLab', 10);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'Docker', 11);
INSERT INTO "tech_stack_items" ("languageId", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'CI/CD', 12);

-- ================================================
-- CV Data
-- ================================================

-- CV data for en
INSERT INTO "cv_profiles" ("languageId", "content") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'I am a hard working and ambitious person with a positive mindset and a never ending desire to continuously learn and grow professionally. Along my academic and self-educational journey, I have had the opportunity to explore various areas of IT working on a variety of projects. I am passionate about further expanding my experience and skills to become a highly skilled and successful developer.') ON CONFLICT ("languageId") DO NOTHING;
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'advanced', 'JavaScript/TypeScript', 0);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'advanced', 'HTML', 1);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'advanced', 'CSS', 2);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'intermediate', 'Vue.js', 0);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'intermediate', 'Angular', 1);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'intermediate', 'Python', 2);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'intermediate', 'FastAPI', 3);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'intermediate', 'PostgreSQL', 4);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'intermediate', 'Git', 5);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'intermediate', 'Docker', 6);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'beginner', 'Spring Boot', 0);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'basic', 'Java', 0);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'basic', 'C#', 1);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'basic', 'Android Studio', 2);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'basic', 'Figma', 3);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'basic', 'Gitlab', 4);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'basic', 'CI/CD', 5);
INSERT INTO "work_experiences" ("languageId", "period", "title", "location", "responsibilities", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), '08.2024 - Present', 'Fullstack Developer (Praktikant), BFH', 'Biel/Bienne, Switzerland', '["Full-stack development based on project needs using Vue.js and FastAPI","Implement RESTful APIs and database integrations with PostgreSQL","Deploy and manage applications using Docker and containerized environments","Collaborate with cross-functional teams to implement business logic and ensure functionality","Manage GitLab repositories and optimize CI/CD pipelines for efficient development","Work with AI-powered solutions, including LangChain for LLM-based applications","Active collaboration with stakeholders and product teams in agile environments"]'::jsonb, 0);
INSERT INTO "work_experiences" ("languageId", "period", "title", "location", "responsibilities", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), '11.2022 - 03.2024', 'Frontend Developer, Part-time Freelance', 'Odesa, Ukraine', '["Designed and developed responsive user interfaces using HTML, CSS, and JavaScript","Created custom website layouts based on client requirements","Implemented mobile-friendly designs to ensure cross-platform compatibility","Collaborated directly with clients to gather requirements and deliver solutions that met their needs"]'::jsonb, 1);
INSERT INTO "work_experiences" ("languageId", "period", "title", "location", "responsibilities", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), '02.2018 - 01.2021', 'Warehouse Associate, LLC "Manufactured goods market"', 'Odesa, Ukraine', '["Managed inventory logistics and warehouse operations","Organized warehouse inventory to maximize efficiency and accessibility","Processed and fulfilled customer orders with attention to detail and accuracy","Maintained accurate records of stock levels and product locations"]'::jsonb, 2);
INSERT INTO "educations" ("languageId", "period", "degree", "institution", "location", "details", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), '09.2018 - 07.2022', 'Bachelor of Computer Engineering', 'Odesa Mechnikov National University', 'Odesa, Ukraine', '["Programming fundamentals","Computer Engineering fundamentals","Data structures and algorithms","Computer networks","Operating systems","Web and mobile development"]'::jsonb, 0);
INSERT INTO "educations" ("languageId", "period", "degree", "institution", "location", "details", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), '04.2024 - 07.2024', 'Powercoders Bootcamp - ICT Work Integration Program', NULL, 'Bern, Switzerland', '["Foundations in HTML, CSS, JavaScript","Weekly business & social skills training (teamwork, communication, etc.)"]'::jsonb, 1);
INSERT INTO "certifications" ("languageId", "degree", "period", "location", "details", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'The Complete 2024 Web Development Bootcamp (Online), Udemy', 'January 2024 - April 2024', 'Zürich, Switzerland', '["Comprehensive training in modern web development technologies including HTML5, CSS3, JavaScript ES6+","Hands-on experience with React, Node.js, Express, and MongoDB","Version control with Git and GitHub","Responsive design principles and best practices"]'::jsonb, 0);
INSERT INTO "cv_languages" ("languageId", "name", "level", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'Russian', 'Native', 0);
INSERT INTO "cv_languages" ("languageId", "name", "level", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'Ukrainian', 'Native', 1);
INSERT INTO "cv_languages" ("languageId", "name", "level", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'Turkish', 'Mother Tongue', 2);
INSERT INTO "cv_languages" ("languageId", "name", "level", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'English', 'B2', 3);
INSERT INTO "cv_languages" ("languageId", "name", "level", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'German', 'A1', 4);
INSERT INTO "cv_references" ("languageId", "name", "position", "contact", "website", "phone", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'Kenneth Ritley', 'Prof. Dr. Kenneth Ritley, Dozent, BFH', 'kenneth.ritley@bfh.ch', 'https://ritley.com/', '+41 79 509 57 22', 0);
INSERT INTO "hobbies" ("languageId", "name", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'Reading', 'I enjoy exploring psychological literature and books that deepen my understanding of human behavior, personal development, and the world around us.', 0);
INSERT INTO "hobbies" ("languageId", "name", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'Music', 'I find inspiration in classical music, particularly violin compositions, which helps me maintain focus and creativity while working on complex programming tasks.', 1);
INSERT INTO "contact_info" ("languageId", "nationality", "birthdate", "email", "phone", "address", "linkedin", "portfolio", "github") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'en'), 'Ukrainian, S Permit', '31.03.2000', 'sultanovshakir12@gmail.com', '+41 76 454 7413', 'Tösstalstrasse 74, 8636 Wald ZH', 'https://www.linkedin.com/in/shkrsltn/', 'https://shkrsltn.github.io/visions.shkrsltn/', 'https://github.com/ShkrSltn') ON CONFLICT ("languageId") DO NOTHING;

-- CV data for de
INSERT INTO "cv_profiles" ("languageId", "content") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'Ich bin eine fleißige und ehrgeizige Person mit positiver Denkweise und einem endlosen Streben nach kontinuierlichem Lernen und beruflichem Wachstum. Während meines akademischen und autodidaktischen Weges hatte ich die Möglichkeit, verschiedene Bereiche der IT zu erforschen, indem ich an vielfältigen Projekten arbeitete. Ich bin begeistert davon, meine Erfahrungen und Fähigkeiten weiter auszubauen, um ein hochqualifizierter und erfolgreicher Entwickler zu werden.') ON CONFLICT ("languageId") DO NOTHING;
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'advanced', 'JavaScript/TypeScript', 0);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'advanced', 'HTML', 1);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'advanced', 'CSS', 2);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'intermediate', 'Vue.js', 0);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'intermediate', 'Angular', 1);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'intermediate', 'Python', 2);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'intermediate', 'FastAPI', 3);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'intermediate', 'PostgreSQL', 4);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'intermediate', 'Git', 5);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'intermediate', 'Docker', 6);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'beginner', 'Spring Boot', 0);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'basic', 'Java', 0);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'basic', 'C#', 1);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'basic', 'Android Studio', 2);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'basic', 'Figma', 3);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'basic', 'Gitlab', 4);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'basic', 'CI/CD', 5);
INSERT INTO "work_experiences" ("languageId", "period", "title", "location", "responsibilities", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), '08.2024 - Gegenwart', 'Fullstack Developer (Praktikant), BFH', 'Biel/Bienne, Schweiz', '["Full-Stack-Entwicklung basierend auf Projektanforderungen mit Vue.js und FastAPI","Implementierung von RESTful APIs und Integrationen mit PostgreSQL-Datenbanken","Bereitstellung und Verwaltung von Anwendungen mit Docker und containerisierten Umgebungen","Zusammenarbeit mit funktionsübergreifenden Teams zur Implementierung von Geschäftslogik und Sicherstellung der Funktionalität","Verwaltung von GitLab-Repositories und Optimierung von CI/CD-Pipelines für effiziente Entwicklung","Arbeit mit KI-gestützten Lösungen, einschließlich LangChain für LLM-basierte Anwendungen","Aktive Zusammenarbeit mit Stakeholdern und Produktteams in agilen Umgebungen"]'::jsonb, 0);
INSERT INTO "work_experiences" ("languageId", "period", "title", "location", "responsibilities", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), '11.2022 - 03.2024', 'Frontend Developer, Teilzeit-Freiberufler', 'Odessa, Ukraine', '["Gestaltung und Entwicklung responsiver Benutzeroberflächen mit HTML, CSS und JavaScript","Erstellung maßgeschneiderter Website-Layouts basierend auf Kundenanforderungen","Implementierung mobilfreundlicher Designs für plattformübergreifende Kompatibilität","Direkte Zusammenarbeit mit Kunden zur Anforderungserfassung und Bereitstellung von Lösungen, die ihren Bedürfnissen entsprechen"]'::jsonb, 1);
INSERT INTO "work_experiences" ("languageId", "period", "title", "location", "responsibilities", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), '02.2018 - 01.2021', 'Verkaufsberater, Elektronikgeschäft', 'Odessa, Ukraine', '["Bereitstellung technischer Informationen und Beratung zu elektronischen Produkten für Kunden","Konsequentes Übertreffen von Verkaufszielen","Bereitstellung von After-Sales-Support zur Sicherstellung der Kundenzufriedenheit","Unterstützung bei der Bestandsverwaltung und Aufrechterhaltung des Ladenerscheinungsbilds"]'::jsonb, 2);
INSERT INTO "educations" ("languageId", "period", "degree", "institution", "location", "details", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), '09.2017 - 06.2021', 'Bachelor in Computeringenieurwesen', 'Nationale I.I. Mechnikov Universität Odessa', 'Odessa, Ukraine', '["Grundlagen der Programmierung","Grundlagen des Computeringenieurwesens","Datenstrukturen und Algorithmen","Computernetzwerke","Betriebssysteme","Web- und Mobile-Entwicklung"]'::jsonb, 0);
INSERT INTO "educations" ("languageId", "period", "degree", "institution", "location", "details", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), '04.2024 - 07.2024', 'Powercoders Bootcamp - ICT-Arbeitsintegrationsprogramm', NULL, 'Bern, Schweiz', '["Grundlagen von HTML, CSS, JavaScript","Wöchentliches Training in Business- und Sozialkompetenzen (Teamarbeit, Kommunikation usw.)"]'::jsonb, 1);
INSERT INTO "certifications" ("languageId", "degree", "period", "location", "details", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'Kompletter Web Development Bootcamp 2024 (Online), Udemy', 'Januar 2024 - April 2024', 'Zürich, Schweiz', '["Umfassende Schulung in modernen Webtechnologien, einschließlich HTML5, CSS3, JavaScript ES6+","Praktische Erfahrung mit React, Node.js, Express und MongoDB","Versionskontrolle mit Git und GitHub","Prinzipien des responsiven Designs und Best Practices"]'::jsonb, 0);
INSERT INTO "cv_languages" ("languageId", "name", "level", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'Russisch', 'Muttersprache', 0);
INSERT INTO "cv_languages" ("languageId", "name", "level", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'Ukrainisch', 'Muttersprache', 1);
INSERT INTO "cv_languages" ("languageId", "name", "level", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'Türkisch', 'Muttersprache', 2);
INSERT INTO "cv_languages" ("languageId", "name", "level", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'Englisch', 'B2', 3);
INSERT INTO "cv_languages" ("languageId", "name", "level", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'Deutsch', 'A1', 4);
INSERT INTO "cv_references" ("languageId", "name", "position", "contact", "website", "phone", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'Kenneth Ritley', 'Prof. Dr. Kenneth Ritley, Dozent, BFH', 'kenneth.ritley@bfh.ch', 'https://ritley.com/', '+41 79 509 57 22', 0);
INSERT INTO "hobbies" ("languageId", "name", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'Lesen', 'Ich genieße es, psychologische Literatur und Bücher zu erforschen, die mein Verständnis für menschliches Verhalten, persönliche Entwicklung und die Welt um uns herum vertiefen.', 0);
INSERT INTO "hobbies" ("languageId", "name", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'Musik', 'Ich finde Inspiration in klassischer Musik, besonders in Violinkompositionen, die mir helfen, Fokus und Kreativität bei der Arbeit an komplexen Programmieraufgaben zu bewahren.', 1);
INSERT INTO "contact_info" ("languageId", "nationality", "birthdate", "email", "phone", "address", "linkedin", "portfolio", "github") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'de'), 'Ukrainisch, S-Bewilligung', '31.03.2000', 'sultanovshakir12@gmail.com', '+41 76 454 7413', 'Tösstalstrasse 74, 8636 Wald ZH', 'https://www.linkedin.com/in/shkrsltn/', 'https://shkrsltn.github.io/visions.shkrsltn/', 'https://github.com/ShkrSltn') ON CONFLICT ("languageId") DO NOTHING;

-- CV data for ru
INSERT INTO "cv_profiles" ("languageId", "content") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'Я трудолюбивый и амбициозный человек с позитивным мышлением и бесконечным стремлением к постоянному обучению и профессиональному росту. На протяжении моего академического и самообразовательного пути я имел возможность изучить различные области ИТ, работая над разнообразными проектами. Я увлечен дальнейшим расширением своего опыта и навыков, чтобы стать высококвалифицированным и успешным разработчиком.') ON CONFLICT ("languageId") DO NOTHING;
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'advanced', 'JavaScript/TypeScript', 0);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'advanced', 'HTML', 1);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'advanced', 'CSS', 2);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'intermediate', 'Vue.js', 0);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'intermediate', 'Angular', 1);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'intermediate', 'Python', 2);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'intermediate', 'FastAPI', 3);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'intermediate', 'PostgreSQL', 4);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'intermediate', 'Git', 5);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'intermediate', 'Docker', 6);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'beginner', 'Spring Boot', 0);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'basic', 'Java', 0);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'basic', 'C#', 1);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'basic', 'Android Studio', 2);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'basic', 'Figma', 3);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'basic', 'Gitlab', 4);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'basic', 'CI/CD', 5);
INSERT INTO "work_experiences" ("languageId", "period", "title", "location", "responsibilities", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), '08.2024 - По настоящее время', 'Fullstack Developer (Практикант), BFH', 'Биль/Бьенн, Швейцария', '["Полный стек разработки на основе потребностей проекта с использованием Vue.js и FastAPI","Реализация RESTful API и интеграций с базами данных PostgreSQL","Развертывание и управление приложениями с использованием Docker и контейнеризированных сред","Сотрудничество с кросс-функциональными командами для реализации бизнес-логики и обеспечения функциональности","Управление репозиториями GitLab и оптимизация CI/CD конвейеров для эффективной разработки","Работа с решениями на базе ИИ, включая LangChain для приложений на основе LLM","Активное сотрудничество с заинтересованными сторонами и продуктовыми командами в гибких средах"]'::jsonb, 0);
INSERT INTO "work_experiences" ("languageId", "period", "title", "location", "responsibilities", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), '11.2022 - 03.2024', 'Frontend Developer, Частичная занятость, Фриланс', 'Одесса, Украина', '["Проектирование и разработка отзывчивых пользовательских интерфейсов с использованием HTML, CSS и JavaScript","Создание индивидуальных макетов веб-сайтов на основе требований клиентов","Реализация мобильно-ориентированных дизайнов для обеспечения кросс-платформенной совместимости","Прямое сотрудничество с клиентами для сбора требований и предоставления решений, отвечающих их потребностям"]'::jsonb, 1);
INSERT INTO "work_experiences" ("languageId", "period", "title", "location", "responsibilities", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), '02.2018 - 01.2021', 'Сотрудник склада, ООО "Рынок промышленных товаров"', 'Одесса, Украина', '["Управление логистикой инвентаря и складскими операциями","Организация складского инвентаря для максимальной эффективности и доступности","Обработка и выполнение заказов клиентов с вниманием к деталям и точностью","Ведение точного учета уровней запасов и местоположения продукции"]'::jsonb, 2);
INSERT INTO "educations" ("languageId", "period", "degree", "institution", "location", "details", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), '09.2018 - 07.2022', 'Бакалавр компьютерной инженерии', 'Одесский национальный университет имени И.И. Мечникова', 'Одесса, Украина', '["Основы программирования","Основы компьютерной инженерии","Структуры данных и алгоритмы","Компьютерные сети","Операционные системы","Веб и мобильная разработка"]'::jsonb, 0);
INSERT INTO "educations" ("languageId", "period", "degree", "institution", "location", "details", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), '04.2024 - 07.2024', 'Powercoders Bootcamp - Программа интеграции в ИКТ', NULL, 'Берн, Швейцария', '["Основы HTML, CSS, JavaScript","Еженедельные тренинги по бизнес и социальным навыкам (командная работа, коммуникация и т.д.)"]'::jsonb, 1);
INSERT INTO "certifications" ("languageId", "degree", "period", "location", "details", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'Полный курс веб-разработки 2024 (Онлайн), Udemy', 'Январь 2024 - Апрель 2024', 'Цюрих, Швейцария', '["Комплексное обучение современным технологиям веб-разработки, включая HTML5, CSS3, JavaScript ES6+","Практический опыт работы с React, Node.js, Express и MongoDB","Контроль версий с Git и GitHub","Принципы отзывчивого дизайна и лучшие практики"]'::jsonb, 0);
INSERT INTO "cv_languages" ("languageId", "name", "level", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'Русский', 'Родной', 0);
INSERT INTO "cv_languages" ("languageId", "name", "level", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'Украинский', 'Родной', 1);
INSERT INTO "cv_languages" ("languageId", "name", "level", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'Турецкий', 'Родной', 2);
INSERT INTO "cv_languages" ("languageId", "name", "level", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'Английский', 'B2', 3);
INSERT INTO "cv_languages" ("languageId", "name", "level", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'Немецкий', 'A1', 4);
INSERT INTO "cv_references" ("languageId", "name", "position", "contact", "website", "phone", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'Кеннет Ритли', 'Проф. Др. Кеннет Ритли, Доцент, BFH', 'kenneth.ritley@bfh.ch', 'https://ritley.com/', '+41 79 509 57 22', 0);
INSERT INTO "hobbies" ("languageId", "name", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'Чтение', 'Я люблю изучать психологическую литературу и книги, которые углубляют мое понимание человеческого поведения, личностного развития и окружающего мира.', 0);
INSERT INTO "hobbies" ("languageId", "name", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'Музыка', 'Я нахожу вдохновение в классической музыке, особенно в скрипичных композициях, что помогает мне сохранять концентрацию и креативность при работе над сложными задачами программирования.', 1);
INSERT INTO "contact_info" ("languageId", "nationality", "birthdate", "email", "phone", "address", "linkedin", "portfolio", "github") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ru'), 'Украинец, Разрешение S', '31.03.2000', 'sultanovshakir12@gmail.com', '+41 76 454 7413', 'Tösstalstrasse 74, 8636 Wald ZH', 'https://www.linkedin.com/in/shkrsltn/', 'https://shkrsltn.github.io/visions.shkrsltn/', 'https://github.com/ShkrSltn') ON CONFLICT ("languageId") DO NOTHING;

-- CV data for tr
INSERT INTO "cv_profiles" ("languageId", "content") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'Ben, pozitif bir düşünce yapısına sahip, sürekli öğrenme ve profesyonel olarak gelişme arzusu olan çalışkan ve hırslı bir kişiyim. Akademik ve kendi kendime eğitim yolculuğum boyunca, çeşitli projelerde çalışarak BT''nin farklı alanlarını keşfetme fırsatım oldu. Yüksek becerili ve başarılı bir geliştirici olmak için deneyimimi ve becerilerimi daha da genişletme konusunda tutkuluyum.') ON CONFLICT ("languageId") DO NOTHING;
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'advanced', 'JavaScript/TypeScript', 0);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'advanced', 'HTML', 1);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'advanced', 'CSS', 2);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'intermediate', 'Vue.js', 0);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'intermediate', 'Angular', 1);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'intermediate', 'Python', 2);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'intermediate', 'FastAPI', 3);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'intermediate', 'PostgreSQL', 4);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'intermediate', 'Git', 5);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'intermediate', 'Docker', 6);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'beginner', 'Spring Boot', 0);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'basic', 'Java', 0);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'basic', 'C#', 1);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'basic', 'Android Studio', 2);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'basic', 'Figma', 3);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'basic', 'Gitlab', 4);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'basic', 'CI/CD', 5);
INSERT INTO "work_experiences" ("languageId", "period", "title", "location", "responsibilities", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), '08.2024 - Şu anda', 'Fullstack Developer (Praktikant), BFH', 'Biel/Bienne, İsviçre', '["Vue.js ve FastAPI kullanarak proje ihtiyaçlarına göre full-stack geliştirme","RESTful API''ler ve PostgreSQL ile veritabanı entegrasyonları uygulama","Docker ve konteynerleştirilmiş ortamlar kullanarak uygulamaları dağıtma ve yönetme","İş mantığını uygulamak ve işlevselliği sağlamak için çapraz fonksiyonel ekiplerle işbirliği yapma","GitLab depolarını yönetme ve verimli geliştirme için CI/CD boru hatlarını optimize etme","LangChain dahil olmak üzere LLM tabanlı uygulamalar için AI destekli çözümlerle çalışma","Çevik ortamlarda paydaşlar ve ürün ekipleriyle aktif işbirliği"]'::jsonb, 0);
INSERT INTO "work_experiences" ("languageId", "period", "title", "location", "responsibilities", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), '11.2022 - 03.2024', 'Frontend Developer, Yarı zamanlı Serbest Çalışan', 'Odesa, Ukrayna', '["HTML, CSS ve JavaScript kullanarak duyarlı kullanıcı arayüzleri tasarlama ve geliştirme","Müşteri gereksinimlerine göre özel web sitesi düzenleri oluşturma","Çapraz platform uyumluluğunu sağlamak için mobil dostu tasarımlar uygulama","Gereksinimleri toplamak ve ihtiyaçlarını karşılayan çözümler sunmak için müşterilerle doğrudan işbirliği yapma"]'::jsonb, 1);
INSERT INTO "work_experiences" ("languageId", "period", "title", "location", "responsibilities", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), '02.2018 - 01.2021', 'Satış Danışmanı, Elektronik Mağazası', 'Odesa, Ukrayna', '["Müşterilere elektronik ürünler hakkında teknik bilgi ve tavsiye sağlama","Satış hedeflerini tutarlı bir şekilde aşma","Müşteri memnuniyetini sağlamak için satış sonrası destek sağlama","Envanter yönetimi ve mağaza görüntüsünün korunmasına yardımcı olma"]'::jsonb, 2);
INSERT INTO "educations" ("languageId", "period", "degree", "institution", "location", "details", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), '09.2017 - 06.2021', 'Bilgisayar Mühendisliği Lisans Derecesi', 'Odesa Mechnikov Ulusal Üniversitesi', 'Odesa, Ukrayna', '["Programlama temelleri","Bilgisayar Mühendisliği temelleri","Veri yapıları ve algoritmalar","Bilgisayar ağları","İşletim sistemleri","Web ve mobil geliştirme"]'::jsonb, 0);
INSERT INTO "educations" ("languageId", "period", "degree", "institution", "location", "details", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), '04.2024 - 07.2024', 'Powercoders Bootcamp - ICT İş Entegrasyon Programı', NULL, 'Bern, İsviçre', '["HTML, CSS, JavaScript temelleri","Haftalık iş ve sosyal beceriler eğitimi (takım çalışması, iletişim vb.)"]'::jsonb, 1);
INSERT INTO "certifications" ("languageId", "degree", "period", "location", "details", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'Tam 2024 Web Geliştirme Bootcamp''i (Çevrimiçi), Udemy', 'Ocak 2024 - Nisan 2024', 'Zürih, İsviçre', '["HTML5, CSS3, JavaScript ES6+ dahil modern web geliştirme teknolojilerinde kapsamlı eğitim","React, Node.js, Express ve MongoDB ile pratik deneyim","Git ve GitHub ile sürüm kontrolü","Duyarlı tasarım ilkeleri ve en iyi uygulamalar"]'::jsonb, 0);
INSERT INTO "cv_languages" ("languageId", "name", "level", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'Rusça', 'Ana Dil', 0);
INSERT INTO "cv_languages" ("languageId", "name", "level", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'Ukraynaca', 'Ana Dil', 1);
INSERT INTO "cv_languages" ("languageId", "name", "level", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'Türkçe', 'Ana Dil', 2);
INSERT INTO "cv_languages" ("languageId", "name", "level", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'İngilizce', 'B2', 3);
INSERT INTO "cv_languages" ("languageId", "name", "level", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'Almanca', 'A1', 4);
INSERT INTO "cv_references" ("languageId", "name", "position", "contact", "website", "phone", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'Kenneth Ritley', 'Prof. Dr. Kenneth Ritley, Dozent, BFH', 'kenneth.ritley@bfh.ch', 'https://ritley.com/', '+41 79 509 57 22', 0);
INSERT INTO "hobbies" ("languageId", "name", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'Okuma', 'İnsan davranışı, kişisel gelişim ve çevremizdeki dünya hakkındaki anlayışımı derinleştiren psikolojik literatürü ve kitapları keşfetmekten keyif alıyorum.', 0);
INSERT INTO "hobbies" ("languageId", "name", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'Müzik', 'Özellikle keman kompozisyonları olmak üzere klasik müzikte ilham buluyorum, bu da karmaşık programlama görevleri üzerinde çalışırken odaklanmamı ve yaratıcılığımı korumama yardımcı oluyor.', 1);
INSERT INTO "contact_info" ("languageId", "nationality", "birthdate", "email", "phone", "address", "linkedin", "portfolio", "github") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'tr'), 'Türk, S Permit', '31.03.2000', 'sultanovshakir12@gmail.com', '+41 76 454 7413', 'Tösstalstrasse 74, 8636 Wald ZH', 'https://www.linkedin.com/in/shkrsltn/', 'https://shkrsltn.github.io/visions.shkrsltn/', 'https://github.com/ShkrSltn') ON CONFLICT ("languageId") DO NOTHING;

-- CV data for ua
INSERT INTO "cv_profiles" ("languageId", "content") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'Я працьовита та амбіційна людина з позитивним мисленням і нескінченним прагненням до постійного навчання та професійного зростання. Протягом мого академічного та самоосвітнього шляху я мав можливість дослідити різні галузі ІТ, працюючи над різноманітними проектами. Я захоплений подальшим розширенням свого досвіду та навичок, щоб стати висококваліфікованим і успішним розробником.') ON CONFLICT ("languageId") DO NOTHING;
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'advanced', 'JavaScript/TypeScript', 0);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'advanced', 'HTML', 1);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'advanced', 'CSS', 2);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'intermediate', 'Vue.js', 0);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'intermediate', 'Angular', 1);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'intermediate', 'Python', 2);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'intermediate', 'FastAPI', 3);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'intermediate', 'PostgreSQL', 4);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'intermediate', 'Git', 5);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'intermediate', 'Docker', 6);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'beginner', 'Spring Boot', 0);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'basic', 'Java', 0);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'basic', 'C#', 1);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'basic', 'Android Studio', 2);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'basic', 'Figma', 3);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'basic', 'Gitlab', 4);
INSERT INTO "cv_skills" ("languageId", "level", "name", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'basic', 'CI/CD', 5);
INSERT INTO "work_experiences" ("languageId", "period", "title", "location", "responsibilities", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), '08.2024 - Теперішній час', 'Fullstack Developer (Практикант), BFH', 'Біль/Б''єнн, Швейцарія', '["Full-stack розробка на основі потреб проекту з використанням Vue.js та FastAPI","Реалізація RESTful API та інтеграцій з базами даних PostgreSQL","Розгортання та управління додатками з використанням Docker та контейнеризованих середовищ","Співпраця з крос-функціональними командами для реалізації бізнес-логіки та забезпечення функціональності","Управління репозиторіями GitLab та оптимізація CI/CD конвеєрів для ефективної розробки","Робота з рішеннями на базі штучного інтелекту, включаючи LangChain для додатків на основі LLM","Активна співпраця із зацікавленими сторонами та продуктовими командами в гнучких середовищах"]'::jsonb, 0);
INSERT INTO "work_experiences" ("languageId", "period", "title", "location", "responsibilities", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), '11.2022 - 03.2024', 'Frontend Developer, Фріланс на неповний робочий день', 'Одеса, Україна', '["Проектування та розробка адаптивних користувацьких інтерфейсів з використанням HTML, CSS та JavaScript","Створення індивідуальних макетів веб-сайтів на основі вимог клієнтів","Впровадження мобільно-дружніх дизайнів для забезпечення кросплатформної сумісності","Безпосередня співпраця з клієнтами для збору вимог та надання рішень, що відповідають їхнім потребам"]'::jsonb, 1);
INSERT INTO "work_experiences" ("languageId", "period", "title", "location", "responsibilities", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), '02.2018 - 01.2021', 'Консультант з продажу, Магазин електроніки', 'Одеса, Україна', '["Надання клієнтам технічної інформації та порад щодо електронних товарів","Постійне перевищення цілей продажу","Надання післяпродажної підтримки для забезпечення задоволеності клієнтів","Допомога в управлінні інвентарем та підтримці зовнішнього вигляду магазину"]'::jsonb, 2);
INSERT INTO "educations" ("languageId", "period", "degree", "institution", "location", "details", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), '09.2017 - 06.2021', 'Бакалавр комп''ютерної інженерії', 'Одеський національний університет імені І.І. Мечникова', 'Одеса, Україна', '["Основи програмування","Основи комп''ютерної інженерії","Структури даних та алгоритми","Комп''ютерні мережі","Операційні системи","Веб та мобільна розробка"]'::jsonb, 0);
INSERT INTO "educations" ("languageId", "period", "degree", "institution", "location", "details", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), '04.2024 - 07.2024', 'Powercoders Bootcamp - Програма інтеграції в ІКТ', NULL, 'Берн, Швейцарія', '["Основи HTML, CSS, JavaScript","Щотижневе навчання бізнес та соціальним навичкам (командна робота, комунікація тощо)"]'::jsonb, 1);
INSERT INTO "certifications" ("languageId", "degree", "period", "location", "details", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'Повний курс веб-розробки 2024 (Онлайн), Udemy', 'Січень 2024 - Квітень 2024', 'Цюрих, Швейцарія', '["Комплексне навчання сучасним технологіям веб-розробки, включаючи HTML5, CSS3, JavaScript ES6+","Практичний досвід роботи з React, Node.js, Express та MongoDB","Контроль версій з Git та GitHub","Принципи адаптивного дизайну та найкращі практики"]'::jsonb, 0);
INSERT INTO "cv_languages" ("languageId", "name", "level", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'Russian', 'Native', 0);
INSERT INTO "cv_languages" ("languageId", "name", "level", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'Ukrainian', 'Native', 1);
INSERT INTO "cv_languages" ("languageId", "name", "level", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'Turkish', 'Mother Tongue', 2);
INSERT INTO "cv_languages" ("languageId", "name", "level", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'English', 'B2', 3);
INSERT INTO "cv_languages" ("languageId", "name", "level", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'German', 'A1', 4);
INSERT INTO "cv_references" ("languageId", "name", "position", "contact", "website", "phone", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'Kenneth Ritley', 'Prof. Dr. Kenneth Ritley, Dozent, BFH', 'kenneth.ritley@bfh.ch', 'https://ritley.com/', '+41 79 509 57 22', 0);
INSERT INTO "hobbies" ("languageId", "name", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'Читання', 'Мені подобається досліджувати психологічну літературу та книги, які поглиблюють моє розуміння людської поведінки, особистого розвитку та світу навколо нас.', 0);
INSERT INTO "hobbies" ("languageId", "name", "description", "orderIndex") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'Музика', 'Я знаходжу натхнення в класичній музиці, особливо в скриптових композиціях, що допомагає мені зберігати зосередженість та креативність під час роботи над складними програмними завданнями.', 1);
INSERT INTO "contact_info" ("languageId", "nationality", "birthdate", "email", "phone", "address", "linkedin", "portfolio", "github") VALUES ((SELECT "id" FROM "languages" WHERE "code" = 'ua'), 'Українець, S Permit', '31.03.2000', 'sultanovshakir12@gmail.com', '+41 76 454 7413', 'Tösstalstrasse 74, 8636 Wald ZH', 'https://www.linkedin.com/in/shkrsltn/', 'https://shkrsltn.github.io/visions.shkrsltn/', 'https://github.com/ShkrSltn') ON CONFLICT ("languageId") DO NOTHING;

-- ================================================
-- i18n Translations
-- ================================================

-- Translations for en (137 keys)
INSERT INTO "translations" ("languageCode", "namespace", "key", "value") VALUES
  ('en', 'HEADER', 'HOME', 'Home'),
  ('en', 'HEADER', 'ABOUT', 'About Me'),
  ('en', 'HEADER', 'PROJECTS', 'Projects'),
  ('en', 'HEADER', 'CONTACT', 'Contact'),
  ('en', 'HEADER', 'CV', 'CV'),
  ('en', 'HEADER', 'AI_ASSISTANT', 'AI Assistant'),
  ('en', 'HEADER', 'CLOCK', 'Clock'),
  ('en', 'HEADER', 'NAVIGATION', 'Navigation'),
  ('en', 'HERO_TITLES', 'HOME_1', 'Welcome'),
  ('en', 'HERO_TITLES', 'HOME_2', 'to the'),
  ('en', 'HERO_TITLES', 'HOME_3', 'SHKRSLTNV'),
  ('en', 'HERO_TITLES', 'HOME_SUBTITLE', 'Fullstack Developer'),
  ('en', 'HERO_TITLES', 'ABOUT_ME', 'ABOUT ME'),
  ('en', 'HERO_TITLES', 'ABOUT_ME_SUBTITLE', 'Fullstack Developer'),
  ('en', 'HERO_TITLES', 'PROJECTS', 'PROJECTS'),
  ('en', 'HERO_TITLES', 'PROJECTS_SUBTITLE', 'Let''s take a look at my projects'),
  ('en', 'HERO_TITLES', 'CONTACT', 'CONTACT'),
  ('en', 'HERO_TITLES', 'CONTACT_SUBTITLE', 'Get in touch'),
  ('en', 'HERO_TITLES', 'CLOCK', 'CLOCK & TIMER'),
  ('en', 'HERO_TITLES', 'CLOCK_SUBTITLE', 'Track time easily'),
  ('en', 'HOME', 'ABOUT_ME', 'ABOUT ME'),
  ('en', 'HOME', 'HI', 'Hey!'),
  ('en', 'HOME', 'ME_DESCRIPTION', 'I''m Shakir, I''m 24 years old, I''m from Ukraine but I''m a Meskhetian Turk now living in Switzerland. I could write a cool text here to seem ''cool'' to you, but I am a person who loves simplicity, and I will just say that I love IT. I love to get on with life and develop, I love to learn, I love to create cool things. I do as much as I can, and I always will.'),
  ('en', 'HOME', 'BUILD', 'BUILD'),
  ('en', 'HOME', 'BUILD_DESCRIPTION', 'Crafting clean, efficient solutions that solve real problems. I believe simplicity is the ultimate sophistication.'),
  ('en', 'HOME', 'LEARN', 'LEARN'),
  ('en', 'HOME', 'LEARN_DESCRIPTION', 'Every project is a learning opportunity. I''m constantly exploring new technologies and refining my skills.'),
  ('en', 'HOME', 'GROW', 'GROW'),
  ('en', 'HOME', 'GROW_DESCRIPTION', 'Embracing challenges and feedback to become better each day. The journey is as important as the destination.'),
  ('en', 'HOME', 'FEATURED_PROJECTS', 'Featured Projects'),
  ('en', 'HOME', 'IN_TOUCH', 'Get In Touch'),
  ('en', 'HOME', 'LET''S_WORK_TOGETHER', 'Let''s work together'),
  ('en', 'HOME', 'IN_TOUCH_DESCRIPTION', 'I''m always open to discussing new projects, creative ideas or opportunities to be part of your vision.'),
  ('en', 'HOME', 'EMAIL_ME', 'Email Me'),
  ('en', 'ABOUT', 'JOURNEY', 'My Journey'),
  ('en', 'ABOUT', 'HELLO', 'Hello, I''m Shakir'),
  ('en', 'ABOUT', 'IMAGE_CAPTION', 'That''s me :)'),
  ('en', 'ABOUT', 'BIO_PART1', 'I''m not going to try to sound cool or better than I am. I''m {{age}} years old, born and raised in a small village in Ukraine, I''m a Meskhetian Turk by descent. I''ve always been interested in computers – especially how technology all fits together – and my passion has been to use that power to create wonderful things.'),
  ('en', 'ABOUT', 'BIO_PART2', 'I have a pretty good basic knowledge of almost everything in IT, which is what I was taught at university. After arriving in Switzerland I had a chance to get to power.coders, where I got a lot of information about Switzerland, about work culture, about opportunities, learnt new development skills, and one of the most important things I met a lot of very cool people.'),
  ('en', 'ABOUT', 'BIO_PART3', 'I''ve always loved to learn, loved to develop, yes, there were times when I ''fell out'', didn''t understand how to do it, who to turn to, etc. But one of my favourite skills is that I don''t like to give up.'),
  ('en', 'ABOUT', 'BIO_PART4', 'And now I work as an intern at BFH Fachhohschule as a Full Stack developer, where I got a chance to work on quite interesting projects, to get experience, develop and get new skills both social and hard. Since the first day of university I had a desire to work on projects that can be useful to people, not only bring money to someone, but maybe also help someone, this thought always gave me some warmth inside, I always wanted to feel it. The thought that what you have created where on earth people use it and it helps them - what could be better?'),
  ('en', 'ABOUT', 'BIO_PART5', 'In a world where both completely dark people and completely bright people have a chance to live, I have always wanted and will always want to be on the side of the light. '),
  ('en', 'ABOUT', 'EDUCATION', 'Education'),
  ('en', 'ABOUT', 'UNIVERSITY', 'Bachelor''s in Computer Engineering - Odesa I.I.Mechnikov National University'),
  ('en', 'ABOUT', 'UNIVERSITY_DESCRIPTION', 'One of the best universities in Ukraine. Studied computer architecture, algorithms, data structures, and software engineering principles. Developed strong problem-solving skills and a deep understanding of computing systems. We were taught almost every sphere of IT, from hardware to software.'),
  ('en', 'ABOUT', 'POWERCODERS_DESCRIPTION', 'An intensive coding academy in Switzerland that helps refugees and migrants integrate into the IT job market. The program includes technical training in web development, soft skills workshops, and a job placement component with internship opportunities at partner companies.'),
  ('en', 'ABOUT', 'CAREER_JOURNEY', 'Career Journey'),
  ('en', 'ABOUT', 'EVENT_1', 'Education'),
  ('en', 'ABOUT', 'EVENT_1_DESCRIPTION', 'Computer Engineering'),
  ('en', 'ABOUT', 'EVENT_2', 'Moving to Switzerland'),
  ('en', 'ABOUT', 'EVENT_2_DESCRIPTION', 'Adaptation'),
  ('en', 'ABOUT', 'EVENT_3', 'Powercoders'),
  ('en', 'ABOUT', 'EVENT_3_DESCRIPTION', 'Swiss bridge to IT'),
  ('en', 'ABOUT', 'EVENT_4', 'Internship'),
  ('en', 'ABOUT', 'EVENT_4_DATE', '2024-2025'),
  ('en', 'ABOUT', 'EVENT_5', 'Research Assistant | AI'),
  ('en', 'ABOUT', 'EVENT_5_DESCRIPTION', 'BFH Fachhochschule Biel/Bienne'),
  ('en', 'ABOUT', 'EVENT_6', 'Future goals'),
  ('en', 'ABOUT', 'EVENT_6_DESCRIPTION', 'Be better than yesterday'),
  ('en', 'ABOUT.SKILLS', 'TITLE', 'Skills'),
  ('en', 'ABOUT.SKILLS', 'OTHER_SKILLS', 'Other Skills'),
  ('en', 'ABOUT', 'INTERESTS', 'Interests & Hobbies'),
  ('en', 'ABOUT', 'MOVIES_AND_SERIES', 'Movies and Series'),
  ('en', 'ABOUT', 'MOVIES_AND_SERIES_DESCRIPTION', 'I love to watch good films and TV series. It might seem trivial, but watching them also requires a certain skill — you need to be able to appreciate them, learn something new through them, and, most importantly, truly enjoy the experience.'),
  ('en', 'ABOUT', 'PSYCHOLOGY', 'Psychology'),
  ('en', 'ABOUT', 'PSYCHOLOGY_DESCRIPTION', 'I have kind of interest in psychology, especially today it''s hard to understand people, so I try to learn more about it. More you understand, easier to behave in different situations.'),
  ('en', 'ABOUT', 'TRAVELING', 'Traveling'),
  ('en', 'ABOUT', 'TRAVELING_DESCRIPTION', 'New interest after I came Switzerland. It is super interesting to see different places, different cultures, different lifes.'),
  ('en', 'PROJECTS', 'FEATURED_PROJECTS', 'Featured Projects'),
  ('en', 'PROJECTS', 'MORE_PROJECTS', 'More Projects'),
  ('en', 'CONTACT', 'CONTACT_INFORMATION', 'Contact Information'),
  ('en', 'CONTACT', 'EMAIL', 'Email'),
  ('en', 'CONTACT', 'PHONE', 'Phone'),
  ('en', 'CONTACT', 'LOCATION', 'Location'),
  ('en', 'CONTACT', 'LOCATION_DESCRIPTION', 'Switzerland, Zurich'),
  ('en', 'CONTACT', 'SEND_MESSAGE_TITLE', 'Send Message'),
  ('en', 'CONTACT.MESSAGE', 'SEND_MESSAGE', 'Send Message'),
  ('en', 'CONTACT.MESSAGE', 'NAME', 'Name'),
  ('en', 'CONTACT.MESSAGE', 'EMAIL', 'Email'),
  ('en', 'CONTACT.MESSAGE', 'MESSAGE', 'Message'),
  ('en', 'CONTACT.MESSAGE', 'SEND', 'Send'),
  ('en', 'CONTACT.MESSAGE', 'SUCCESS', 'Message Sent'),
  ('en', 'CONTACT.MESSAGE', 'NAME_REQUIRED', 'Name is required'),
  ('en', 'CONTACT.MESSAGE', 'NAME_MINLENGTH', 'Name must be at least 2 characters'),
  ('en', 'CONTACT.MESSAGE', 'EMAIL_REQUIRED', 'Email is required'),
  ('en', 'CONTACT.MESSAGE', 'EMAIL_INVALID', 'Please enter a valid email'),
  ('en', 'CONTACT.MESSAGE', 'SUBJECT', 'Subject'),
  ('en', 'CONTACT.MESSAGE', 'SUBJECT_REQUIRED', 'Subject is required'),
  ('en', 'CONTACT.MESSAGE', 'MESSAGE_REQUIRED', 'Message is required'),
  ('en', 'CONTACT.MESSAGE', 'MESSAGE_MINLENGTH', 'Message must be at least 10 characters'),
  ('en', 'CONTACT.MESSAGE', 'SUCCESS_DESCRIPTION', 'Your message has been sent successfully! I''ll get back to you soon.'),
  ('en', 'CONTACT.MESSAGE', 'ERROR', 'Error'),
  ('en', 'CONTACT.MESSAGE', 'ERROR_DESCRIPTION', 'An error occurred while sending your message. Please check the form and try again.'),
  ('en', 'AI_ASSISTANT', 'SECTION_TITLE', 'Interactive AI Assistant'),
  ('en', 'AI_ASSISTANT', 'CHAT_TITLE', 'Shakir''s AI clone'),
  ('en', 'AI_ASSISTANT', 'CHAT_SUBTITLE', 'Ask me anything about my skills, experience, or projects'),
  ('en', 'AI_ASSISTANT', 'NOTE_TITLE', 'Note:'),
  ('en', 'AI_ASSISTANT', 'NOTE', 'This AI assistant is powered by OPEN AI and has been trained on specific information about me. It will try to give relevant information, but if you see something weird or not accurate, just ask me directly. You can find my'),
  ('en', 'AI_ASSISTANT', 'LINKEDIN', 'LinkedIn profile'),
  ('en', 'AI_ASSISTANT', 'OR', 'or'),
  ('en', 'AI_ASSISTANT', 'CONTACT_ME', 'contact me directly'),
  ('en', 'AI_ASSISTANT.AI_CHAT', 'CHAT_TITLE', 'Shakir''s AI clone'),
  ('en', 'AI_ASSISTANT.AI_CHAT', 'CHAT_SUBTITLE', 'Ask me anything about my skills, experience, or projects'),
  ('en', 'AI_ASSISTANT.AI_CHAT', 'FIRST_MESSAGE', 'Hi there! I''m Shakir''s AI clone. Feel free to ask me anything about my skills, experience, or how to get in touch with me.'),
  ('en', 'AI_ASSISTANT.AI_CHAT', 'SUGGESTED_QUESTIONS_TITLE', 'Try asking:'),
  ('en', 'AI_ASSISTANT.AI_CHAT', 'SUGGESTED_QUESTIONS_1', 'What are your skills?'),
  ('en', 'AI_ASSISTANT.AI_CHAT', 'SUGGESTED_QUESTIONS_2', 'How can I contact you?'),
  ('en', 'AI_ASSISTANT.AI_CHAT', 'SUGGESTED_QUESTIONS_3', 'Where are you located?'),
  ('en', 'AI_ASSISTANT.AI_CHAT', 'SUGGESTED_QUESTIONS_4', 'What is your background?'),
  ('en', 'AI_ASSISTANT.AI_CHAT', 'SUGGESTED_QUESTIONS_5', 'What technologies do you work with?'),
  ('en', 'AI_ASSISTANT.AI_CHAT', 'SUGGESTED_QUESTIONS_6', 'Why I have to take you to our company?'),
  ('en', 'AI_ASSISTANT.AI_CHAT', 'CHAT_INPUT_PLACEHOLDER', 'Type your question...'),
  ('en', 'VIRTUAL_CV', 'LOADING', 'Loading CV data...'),
  ('en', 'VIRTUAL_CV', 'FULLNAME', 'Shakir SULTANOV'),
  ('en', 'VIRTUAL_CV', 'TITLE', 'Fullstack Developer'),
  ('en', 'VIRTUAL_CV', 'PROFILE', 'PROFILE'),
  ('en', 'VIRTUAL_CV', 'CONTACT', 'CONTACT'),
  ('en', 'VIRTUAL_CV', 'EDUCATION', 'EDUCATION'),
  ('en', 'VIRTUAL_CV', 'LANGUAGES', 'LANGUAGES'),
  ('en', 'VIRTUAL_CV', 'REFERENCES', 'REFERENCES'),
  ('en', 'VIRTUAL_CV', 'HOBBIES', 'HOBBIES'),
  ('en', 'VIRTUAL_CV', 'IT_SKILLS', 'IT SKILLS'),
  ('en', 'VIRTUAL_CV', 'ADVANCED', 'ADVANCED'),
  ('en', 'VIRTUAL_CV', 'INTERMEDIATE', 'INTERMEDIATE'),
  ('en', 'VIRTUAL_CV', 'BEGINNER', 'BEGINNER'),
  ('en', 'VIRTUAL_CV', 'BASIC', 'BASIC'),
  ('en', 'VIRTUAL_CV', 'WORK_EXPERIENCE', 'WORK EXPERIENCE'),
  ('en', 'VIRTUAL_CV', 'CERTIFICATIONS', 'CERTIFICATIONS'),
  ('en', 'VIRTUAL_CV', 'DOWNLOAD_CV', 'Download CV'),
  ('en', 'CLOCK', 'START', 'Start'),
  ('en', 'CLOCK', 'STOP', 'Stop'),
  ('en', 'CLOCK', 'RESET', 'Reset'),
  ('en', 'BUTTONS', 'VIEW_CODE', 'View Code'),
  ('en', 'BUTTONS', 'LIVE_DEMO', 'Live Demo'),
  ('en', 'BUTTONS', 'SEND_MESSAGE', 'Email Me'),
  ('en', 'BUTTONS', 'DEMO', 'Demo'),
  ('en', 'BUTTONS', 'CODE', 'Code')
ON CONFLICT ("languageCode", "namespace", "key") DO NOTHING;

-- Translations for de (135 keys)
INSERT INTO "translations" ("languageCode", "namespace", "key", "value") VALUES
  ('de', 'HEADER', 'HOME', 'Startseite'),
  ('de', 'HEADER', 'ABOUT', 'Über mich'),
  ('de', 'HEADER', 'PROJECTS', 'Projekte'),
  ('de', 'HEADER', 'CONTACT', 'Kontakt'),
  ('de', 'HEADER', 'CV', 'Lebenslauf'),
  ('de', 'HEADER', 'AI_ASSISTANT', 'KI-Assistent'),
  ('de', 'HEADER', 'CLOCK', 'Uhr'),
  ('de', 'HEADER', 'NAVIGATION', 'Navigation'),
  ('de', 'HERO_TITLES', 'HOME_1', 'Willkommen'),
  ('de', 'HERO_TITLES', 'HOME_2', 'auf der'),
  ('de', 'HERO_TITLES', 'HOME_3', 'SHKRSLTNV'),
  ('de', 'HERO_TITLES', 'HOME_SUBTITLE', 'Fullstack-Entwickler'),
  ('de', 'HERO_TITLES', 'ABOUT_ME', 'ÜBER MICH'),
  ('de', 'HERO_TITLES', 'ABOUT_ME_SUBTITLE', 'Fullstack-Entwickler'),
  ('de', 'HERO_TITLES', 'PROJECTS', 'PROJEKTE'),
  ('de', 'HERO_TITLES', 'PROJECTS_SUBTITLE', 'Schauen wir uns meine Projekte an'),
  ('de', 'HERO_TITLES', 'CONTACT', 'KONTAKT'),
  ('de', 'HERO_TITLES', 'CONTACT_SUBTITLE', 'Kontaktieren Sie mich'),
  ('de', 'HERO_TITLES', 'CLOCK', 'UHR & TIMER'),
  ('de', 'HERO_TITLES', 'CLOCK_SUBTITLE', 'Behalte die Zeit im Blick'),
  ('de', 'HOME', 'ABOUT_ME', 'ÜBER MICH'),
  ('de', 'HOME', 'HI', 'Hallo!'),
  ('de', 'HOME', 'ME_DESCRIPTION', 'Ich bin Shakir, 24 Jahre alt, komme aus der Ukraine, bin aber Meschetischer Türke und lebe jetzt in der Schweiz. Ich könnte hier einen coolen Text schreiben, um für dich ''cool'' zu wirken, aber ich bin ein Mensch, der Einfachheit liebt, und ich sage einfach, dass ich IT liebe. Ich liebe es, im Leben voranzukommen und mich zu entwickeln, ich liebe es zu lernen, ich liebe es, coole Dinge zu erschaffen. Ich tue so viel ich kann und werde es immer tun.'),
  ('de', 'HOME', 'BUILD', 'ENTWICKELN'),
  ('de', 'HOME', 'BUILD_DESCRIPTION', 'Ich erstelle saubere, effiziente Lösungen, die echte Probleme lösen. Ich glaube, dass Einfachheit die ultimative Raffinesse ist.'),
  ('de', 'HOME', 'LEARN', 'LERNEN'),
  ('de', 'HOME', 'LEARN_DESCRIPTION', 'Jedes Projekt ist eine Lernmöglichkeit. Ich erforsche ständig neue Technologien und verbessere meine Fähigkeiten.'),
  ('de', 'HOME', 'GROW', 'WACHSEN'),
  ('de', 'HOME', 'GROW_DESCRIPTION', 'Herausforderungen und Feedback annehmen, um jeden Tag besser zu werden. Der Weg ist genauso wichtig wie das Ziel.'),
  ('de', 'HOME', 'FEATURED_PROJECTS', 'Ausgewählte Projekte'),
  ('de', 'HOME', 'IN_TOUCH', 'Kontakt aufnehmen'),
  ('de', 'HOME', 'LET''S_WORK_TOGETHER', 'Lassen Sie uns zusammenarbeiten'),
  ('de', 'HOME', 'IN_TOUCH_DESCRIPTION', 'Ich bin immer offen für Diskussionen über neue Projekte, kreative Ideen oder Möglichkeiten, Teil Ihrer Vision zu sein.'),
  ('de', 'HOME', 'EMAIL_ME', 'E-Mail senden'),
  ('de', 'ABOUT', 'JOURNEY', 'Mein Werdegang'),
  ('de', 'ABOUT', 'HELLO', 'Hallo, ich bin Shakir'),
  ('de', 'ABOUT', 'IMAGE_CAPTION', 'Das bin ich :)'),
  ('de', 'ABOUT', 'BIO_PART1', 'Ich werde nicht versuchen, cool zu klingen oder besser zu sein, als ich bin. Ich bin {{age}} Jahre alt, geboren und aufgewachsen in einem kleinen Dorf in der Ukraine, ich bin von der Abstammung ein Meskhetischer Türke. Ich war schon immer interessiert an Computern – besonders daran, wie Technologie zusammenpasst – und meine Leidenschaft war es, diese Kraft zu nutzen, um wunderbare Dinge zu schaffen.'),
  ('de', 'ABOUT', 'BIO_PART2', 'Ich habe ein ziemlich gutes Grundwissen über fast alles in der IT, was mir an der Universität beigebracht wurde. Nach meiner Ankunft in der Schweiz hatte ich die Chance, zu Powercoders zu kommen, wo ich viele Informationen über die Schweiz, über die Arbeitskultur, über Möglichkeiten erhielt, neue Entwicklungsfähigkeiten erlernte und, was am wichtigsten ist, viele sehr coole Leute kennenlernte.'),
  ('de', 'ABOUT', 'BIO_PART3', 'Ich habe immer gerne gelernt, gerne entwickelt, ja, es gab Zeiten, in denen ich ''ausgestiegen'' bin, nicht verstanden habe, wie es geht, an wen ich mich wenden soll usw. Aber eine meiner Lieblingsfähigkeiten ist, dass ich nicht gerne aufgebe.'),
  ('de', 'ABOUT', 'BIO_PART4', 'Und jetzt arbeite ich als Praktikant an der BFH Fachhochschule als Full-Stack-Entwickler, wo ich die Chance bekam, an ziemlich interessanten Projekten zu arbeiten, Erfahrungen zu sammeln, mich zu entwickeln und neue Fähigkeiten zu erwerben, sowohl soziale als auch fachliche. Seit dem ersten Tag an der Universität hatte ich den Wunsch, an Projekten zu arbeiten, die für Menschen nützlich sein können, nicht nur jemandem Geld bringen, sondern vielleicht auch jemandem helfen, dieser Gedanke gab mir immer eine gewisse Wärme im Inneren, ich wollte das immer spüren. Der Gedanke, dass das, was du erschaffen hast, irgendwo auf der Erde von Menschen genutzt wird und ihnen hilft - was könnte besser sein?'),
  ('de', 'ABOUT', 'BIO_PART5', 'In einer Welt, in der sowohl völlig dunkle als auch völlig helle Menschen eine Chance haben zu leben, wollte ich immer und werde immer auf der Seite des Lichts stehen.'),
  ('de', 'ABOUT', 'EDUCATION', 'Ausbildung'),
  ('de', 'ABOUT', 'UNIVERSITY', 'Bachelor in Informatik - Nationale I.I.Mechnikov-Universität Odessa'),
  ('de', 'ABOUT', 'UNIVERSITY_DESCRIPTION', 'Eine der besten Universitäten in der Ukraine. Studierte Computerarchitektur, Algorithmen, Datenstrukturen und Grundlagen der Softwareentwicklung. Entwickelte starke Problemlösungsfähigkeiten und ein tiefes Verständnis von Computersystemen. Uns wurden fast alle Bereiche der IT beigebracht, von Hardware bis Software.'),
  ('de', 'ABOUT', 'POWERCODERS_DESCRIPTION', 'Eine intensive Coding-Akademie in der Schweiz, die Flüchtlingen und Migranten hilft, sich in den IT-Arbeitsmarkt zu integrieren. Das Programm umfasst technisches Training in der Webentwicklung, Workshops für Soft Skills und eine Arbeitsvermittlungskomponente mit Praktikumsmöglichkeiten bei Partnerunternehmen.'),
  ('de', 'ABOUT', 'CAREER_JOURNEY', 'Beruflicher Werdegang'),
  ('de', 'ABOUT', 'EVENT_1', 'Ausbildung'),
  ('de', 'ABOUT', 'EVENT_1_DESCRIPTION', 'Informatik'),
  ('de', 'ABOUT', 'EVENT_2', 'Umzug in die Schweiz'),
  ('de', 'ABOUT', 'EVENT_2_DESCRIPTION', 'Anpassung'),
  ('de', 'ABOUT', 'EVENT_3', 'Powercoders'),
  ('de', 'ABOUT', 'EVENT_3_DESCRIPTION', 'Schweizer Brücke zur IT'),
  ('de', 'ABOUT', 'EVENT_4', 'Praktikum'),
  ('de', 'ABOUT', 'EVENT_4_DATE', 'Gegenwart'),
  ('de', 'ABOUT', 'EVENT_5', 'Zukünftige Ziele'),
  ('de', 'ABOUT', 'EVENT_5_DESCRIPTION', 'Besser sein als gestern'),
  ('de', 'ABOUT.SKILLS', 'TITLE', 'Fähigkeiten'),
  ('de', 'ABOUT.SKILLS', 'OTHER_SKILLS', 'Andere'),
  ('de', 'ABOUT', 'INTERESTS', 'Interessen & Hobbys'),
  ('de', 'ABOUT', 'MOVIES_AND_SERIES', 'Filme und Serien'),
  ('de', 'ABOUT', 'MOVIES_AND_SERIES_DESCRIPTION', 'Ich schaue gerne gute Filme und TV-Serien. Es mag trivial erscheinen, aber auch das Anschauen erfordert eine gewisse Fähigkeit — man muss sie zu schätzen wissen, durch sie etwas Neues lernen und vor allem das Erlebnis wirklich genießen können.'),
  ('de', 'ABOUT', 'PSYCHOLOGY', 'Psychologie'),
  ('de', 'ABOUT', 'PSYCHOLOGY_DESCRIPTION', 'Ich habe eine Art Interesse an Psychologie, besonders heute ist es schwer, Menschen zu verstehen, also versuche ich, mehr darüber zu lernen. Je mehr man versteht, desto leichter ist es, sich in verschiedenen Situationen zu verhalten.'),
  ('de', 'ABOUT', 'TRAVELING', 'Reisen'),
  ('de', 'ABOUT', 'TRAVELING_DESCRIPTION', 'Neues Interesse, nachdem ich in die Schweiz gekommen bin. Es ist super interessant, verschiedene Orte, verschiedene Kulturen, verschiedene Leben zu sehen.'),
  ('de', 'PROJECTS', 'FEATURED_PROJECTS', 'Ausgewählte Projekte'),
  ('de', 'PROJECTS', 'MORE_PROJECTS', 'Weitere Projekte'),
  ('de', 'CONTACT', 'CONTACT_INFORMATION', 'Kontaktinformationen'),
  ('de', 'CONTACT', 'EMAIL', 'E-Mail'),
  ('de', 'CONTACT', 'PHONE', 'Telefon'),
  ('de', 'CONTACT', 'LOCATION', 'Standort'),
  ('de', 'CONTACT', 'LOCATION_DESCRIPTION', 'Schweiz, Zürich'),
  ('de', 'CONTACT', 'SEND_MESSAGE_TITLE', 'Nachricht senden'),
  ('de', 'CONTACT.MESSAGE', 'SEND_MESSAGE', 'Nachricht senden'),
  ('de', 'CONTACT.MESSAGE', 'NAME', 'Name'),
  ('de', 'CONTACT.MESSAGE', 'EMAIL', 'E-Mail'),
  ('de', 'CONTACT.MESSAGE', 'MESSAGE', 'Nachricht'),
  ('de', 'CONTACT.MESSAGE', 'SEND', 'Senden'),
  ('de', 'CONTACT.MESSAGE', 'SUCCESS', 'Nachricht gesendet'),
  ('de', 'CONTACT.MESSAGE', 'NAME_REQUIRED', 'Name ist erforderlich'),
  ('de', 'CONTACT.MESSAGE', 'NAME_MINLENGTH', 'Name muss mindestens 2 Zeichen lang sein'),
  ('de', 'CONTACT.MESSAGE', 'EMAIL_REQUIRED', 'E-Mail ist erforderlich'),
  ('de', 'CONTACT.MESSAGE', 'EMAIL_INVALID', 'Bitte geben Sie eine gültige E-Mail-Adresse ein'),
  ('de', 'CONTACT.MESSAGE', 'SUBJECT', 'Betreff'),
  ('de', 'CONTACT.MESSAGE', 'SUBJECT_REQUIRED', 'Betreff ist erforderlich'),
  ('de', 'CONTACT.MESSAGE', 'MESSAGE_REQUIRED', 'Nachricht ist erforderlich'),
  ('de', 'CONTACT.MESSAGE', 'MESSAGE_MINLENGTH', 'Nachricht muss mindestens 10 Zeichen lang sein'),
  ('de', 'CONTACT.MESSAGE', 'SUCCESS_DESCRIPTION', 'Ihre Nachricht wurde erfolgreich gesendet! Ich werde mich bald bei Ihnen melden.'),
  ('de', 'CONTACT.MESSAGE', 'ERROR', 'Fehler'),
  ('de', 'CONTACT.MESSAGE', 'ERROR_DESCRIPTION', 'Beim Senden Ihrer Nachricht ist ein Fehler aufgetreten. Bitte überprüfen Sie das Formular und versuchen Sie es erneut.'),
  ('de', 'AI_ASSISTANT', 'SECTION_TITLE', 'Interaktiver KI-Assistent'),
  ('de', 'AI_ASSISTANT', 'CHAT_TITLE', 'Shakirs KI-Klon'),
  ('de', 'AI_ASSISTANT', 'CHAT_SUBTITLE', 'Fragen Sie mich alles über meine Fähigkeiten, Erfahrungen oder Projekte'),
  ('de', 'AI_ASSISTANT', 'NOTE_TITLE', 'Hinweis:'),
  ('de', 'AI_ASSISTANT', 'NOTE', 'Dieser KI-Assistent wird von OPEN AI betrieben und wurde mit spezifischen Informationen über mich trainiert. Er wird versuchen, relevante Informationen zu geben, aber wenn Sie etwas Seltsames oder Ungenaues sehen, fragen Sie mich direkt. Sie finden mein'),
  ('de', 'AI_ASSISTANT', 'LINKEDIN', 'LinkedIn-Profil'),
  ('de', 'AI_ASSISTANT', 'OR', 'oder'),
  ('de', 'AI_ASSISTANT', 'CONTACT_ME', 'kontaktieren Sie mich direkt'),
  ('de', 'AI_ASSISTANT.AI_CHAT', 'CHAT_TITLE', 'Shakirs KI-Klon'),
  ('de', 'AI_ASSISTANT.AI_CHAT', 'CHAT_SUBTITLE', 'Fragen Sie mich alles über meine Fähigkeiten, Erfahrungen oder Projekte'),
  ('de', 'AI_ASSISTANT.AI_CHAT', 'FIRST_MESSAGE', 'Hallo! Ich bin Shakirs KI-Klon. Fragen Sie mich alles über meine Fähigkeiten, Erfahrungen oder wie Sie mich kontaktieren können.'),
  ('de', 'AI_ASSISTANT.AI_CHAT', 'SUGGESTED_QUESTIONS_TITLE', 'Versuchen Sie zu fragen:'),
  ('de', 'AI_ASSISTANT.AI_CHAT', 'SUGGESTED_QUESTIONS_1', 'Was sind Ihre Fähigkeiten?'),
  ('de', 'AI_ASSISTANT.AI_CHAT', 'SUGGESTED_QUESTIONS_2', 'Wie kann ich Sie kontaktieren?'),
  ('de', 'AI_ASSISTANT.AI_CHAT', 'SUGGESTED_QUESTIONS_3', 'Wo sind Sie?'),
  ('de', 'AI_ASSISTANT.AI_CHAT', 'SUGGESTED_QUESTIONS_4', 'Was ist Ihr Hintergrund?'),
  ('de', 'AI_ASSISTANT.AI_CHAT', 'SUGGESTED_QUESTIONS_5', 'Welche Technologien arbeiten Sie mit?'),
  ('de', 'AI_ASSISTANT.AI_CHAT', 'SUGGESTED_QUESTIONS_6', 'Warum muss ich Sie zu unserer Firma bringen?'),
  ('de', 'AI_ASSISTANT.AI_CHAT', 'CHAT_INPUT_PLACEHOLDER', 'Ihre Frage...'),
  ('de', 'VIRTUAL_CV', 'LOADING', 'Lade CV-Daten...'),
  ('de', 'VIRTUAL_CV', 'FULLNAME', 'Shakir SULTANOV'),
  ('de', 'VIRTUAL_CV', 'TITLE', 'Fullstack Entwickler'),
  ('de', 'VIRTUAL_CV', 'PROFILE', 'PROFILE'),
  ('de', 'VIRTUAL_CV', 'CONTACT', 'KONTAKT'),
  ('de', 'VIRTUAL_CV', 'EDUCATION', 'AUSBILDUNG'),
  ('de', 'VIRTUAL_CV', 'LANGUAGES', 'SPRACHEN'),
  ('de', 'VIRTUAL_CV', 'REFERENCES', 'REFERENZEN'),
  ('de', 'VIRTUAL_CV', 'HOBBIES', 'HOBBIES'),
  ('de', 'VIRTUAL_CV', 'IT_SKILLS', 'IT-FÄHIGKEITEN'),
  ('de', 'VIRTUAL_CV', 'ADVANCED', 'ERFORDERLICH'),
  ('de', 'VIRTUAL_CV', 'INTERMEDIATE', 'MITTEL'),
  ('de', 'VIRTUAL_CV', 'BEGINNER', 'EINFACH'),
  ('de', 'VIRTUAL_CV', 'BASIC', 'BASIS'),
  ('de', 'VIRTUAL_CV', 'WORK_EXPERIENCE', 'BERUFLICHER WERDEGANG'),
  ('de', 'VIRTUAL_CV', 'CERTIFICATIONS', 'ZERTIFIKATE'),
  ('de', 'VIRTUAL_CV', 'DOWNLOAD_CV', 'CV herunterladen'),
  ('de', 'CLOCK', 'START', 'Start'),
  ('de', 'CLOCK', 'STOP', 'Stopp'),
  ('de', 'CLOCK', 'RESET', 'Zurücksetzen'),
  ('de', 'BUTTONS', 'VIEW_CODE', 'Code ansehen'),
  ('de', 'BUTTONS', 'LIVE_DEMO', 'Live-Demo'),
  ('de', 'BUTTONS', 'SEND_MESSAGE', 'E-Mail senden'),
  ('de', 'BUTTONS', 'DEMO', 'Demo'),
  ('de', 'BUTTONS', 'CODE', 'Code')
ON CONFLICT ("languageCode", "namespace", "key") DO NOTHING;

-- Translations for ru (135 keys)
INSERT INTO "translations" ("languageCode", "namespace", "key", "value") VALUES
  ('ru', 'HEADER', 'HOME', 'Главная'),
  ('ru', 'HEADER', 'ABOUT', 'Обо мне'),
  ('ru', 'HEADER', 'PROJECTS', 'Проекты'),
  ('ru', 'HEADER', 'CONTACT', 'Контакты'),
  ('ru', 'HEADER', 'CV', 'Резюме'),
  ('ru', 'HEADER', 'AI_ASSISTANT', 'ИИ Ассистент'),
  ('ru', 'HEADER', 'CLOCK', 'Часы'),
  ('ru', 'HEADER', 'NAVIGATION', 'Навигация'),
  ('ru', 'HERO_TITLES', 'HOME_1', 'Привет'),
  ('ru', 'HERO_TITLES', 'HOME_2', 'это'),
  ('ru', 'HERO_TITLES', 'HOME_3', 'SHKRSLTNV'),
  ('ru', 'HERO_TITLES', 'HOME_SUBTITLE', 'Fullstack Разработчик'),
  ('ru', 'HERO_TITLES', 'ABOUT_ME', 'ОБО МНЕ'),
  ('ru', 'HERO_TITLES', 'ABOUT_ME_SUBTITLE', 'Fullstack Разработчик'),
  ('ru', 'HERO_TITLES', 'PROJECTS', 'ПРОЕКТЫ'),
  ('ru', 'HERO_TITLES', 'PROJECTS_SUBTITLE', 'Давайте взглянем на мои проекты'),
  ('ru', 'HERO_TITLES', 'CONTACT', 'КОНТАКТЫ'),
  ('ru', 'HERO_TITLES', 'CONTACT_SUBTITLE', 'Свяжитесь со мной'),
  ('ru', 'HERO_TITLES', 'CLOCK', 'ЧАСЫ И ТАЙМЕР'),
  ('ru', 'HERO_TITLES', 'CLOCK_SUBTITLE', 'Следите за временем'),
  ('ru', 'HOME', 'ABOUT_ME', 'ОБО МНЕ'),
  ('ru', 'HOME', 'HI', 'Привет!'),
  ('ru', 'HOME', 'ME_DESCRIPTION', 'Я Шакир, мне 24 года, я из Украины, но я турок-месхетинец, сейчас живу в Швейцарии. Я мог бы написать здесь крутой текст, чтобы казаться вам ''крутым'', но я человек, который любит простоту, и я просто скажу, что я люблю IT. Я люблю идти по жизни и развиваться, люблю учиться, люблю создавать классные вещи. Я делаю всё, что в моих силах, и всегда буду делать.'),
  ('ru', 'HOME', 'BUILD', 'СОЗДАВАТЬ'),
  ('ru', 'HOME', 'BUILD_DESCRIPTION', 'Создаю чистые, эффективные решения, которые решают реальные проблемы. Я верю, что простота — это высшая степень изысканности.'),
  ('ru', 'HOME', 'LEARN', 'УЧИТЬСЯ'),
  ('ru', 'HOME', 'LEARN_DESCRIPTION', 'Каждый проект — это возможность для обучения. Я постоянно изучаю новые технологии и совершенствую свои навыки.'),
  ('ru', 'HOME', 'GROW', 'РАСТИ'),
  ('ru', 'HOME', 'GROW_DESCRIPTION', 'Принимаю вызовы и обратную связь, чтобы становиться лучше с каждым днем. Путь так же важен, как и пункт назначения.'),
  ('ru', 'HOME', 'FEATURED_PROJECTS', 'Избранные проекты'),
  ('ru', 'HOME', 'IN_TOUCH', 'Связаться'),
  ('ru', 'HOME', 'LET''S_WORK_TOGETHER', 'Давайте работать вместе'),
  ('ru', 'HOME', 'IN_TOUCH_DESCRIPTION', 'Я всегда открыт для обсуждения новых проектов, творческих идей или возможностей стать частью вашего видения.'),
  ('ru', 'HOME', 'EMAIL_ME', 'Написать мне'),
  ('ru', 'ABOUT', 'JOURNEY', 'Мой путь'),
  ('ru', 'ABOUT', 'HELLO', 'Привет, я Шакир'),
  ('ru', 'ABOUT', 'IMAGE_CAPTION', 'Это я :)'),
  ('ru', 'ABOUT', 'BIO_PART1', 'Я не собираюсь пытаться звучать круто или лучше, чем я есть. Мне {{age}} года, я родился и вырос в маленькой деревне в Украине, по происхождению я турок-месхетинец. Я всегда интересовался компьютерами – особенно тем, как технологии сочетаются друг с другом – и моей страстью было использовать эту силу для создания прекрасных вещей.'),
  ('ru', 'ABOUT', 'BIO_PART2', 'У меня довольно хорошие базовые знания почти во всех областях IT, чему меня научили в университете. После приезда в Швейцарию у меня был шанс попасть в power.coders, где я получил много информации о Швейцарии, о рабочей культуре, о возможностях, изучил новые навыки разработки, и одно из самых важных – я встретил много очень классных людей.'),
  ('ru', 'ABOUT', 'BIO_PART3', 'Я всегда любил учиться, любил развиваться, да, были времена, когда я ''выпадал'', не понимал, как это делать, к кому обратиться и т.д. Но один из моих любимых навыков – это то, что я не люблю сдаваться.'),
  ('ru', 'ABOUT', 'BIO_PART4', 'И сейчас я работаю стажером в BFH Fachhohschule как Full Stack разработчик, где получил шанс работать над довольно интересными проектами, получать опыт, развиваться и приобретать новые навыки, как социальные, так и технические. С первого дня в университете у меня было желание работать над проектами, которые могут быть полезны людям, не только приносить кому-то деньги, но, может быть, и помогать кому-то, эта мысль всегда давала мне какое-то тепло внутри, я всегда хотел это почувствовать. Мысль о том, что то, что ты создал, где-то на земле люди используют и это им помогает – что может быть лучше?'),
  ('ru', 'ABOUT', 'BIO_PART5', 'В мире, где и совершенно темные люди, и совершенно светлые люди имеют шанс жить, я всегда хотел и всегда буду хотеть быть на стороне света.'),
  ('ru', 'ABOUT', 'EDUCATION', 'Образование'),
  ('ru', 'ABOUT', 'UNIVERSITY', 'Бакалавр компьютерной инженерии - Одесский национальный университет имени И.И. Мечникова'),
  ('ru', 'ABOUT', 'UNIVERSITY_DESCRIPTION', 'Один из лучших университетов Украины. Изучал архитектуру компьютеров, алгоритмы, структуры данных и принципы программной инженерии. Развил сильные навыки решения проблем и глубокое понимание вычислительных систем. Нас обучали почти всем сферам IT, от аппаратного до программного обеспечения.'),
  ('ru', 'ABOUT', 'POWERCODERS_DESCRIPTION', 'Интенсивная академия программирования в Швейцарии, которая помогает беженцам и мигрантам интегрироваться на рынок труда IT. Программа включает техническое обучение веб-разработке, семинары по мягким навыкам и компонент трудоустройства с возможностями стажировки в компаниях-партнерах.'),
  ('ru', 'ABOUT', 'CAREER_JOURNEY', 'Карьерный путь'),
  ('ru', 'ABOUT', 'EVENT_1', 'Образование'),
  ('ru', 'ABOUT', 'EVENT_1_DESCRIPTION', 'Компьютерная инженерия'),
  ('ru', 'ABOUT', 'EVENT_2', 'Переезд в Швейцарию'),
  ('ru', 'ABOUT', 'EVENT_2_DESCRIPTION', 'Адаптация'),
  ('ru', 'ABOUT', 'EVENT_3', 'Powercoders'),
  ('ru', 'ABOUT', 'EVENT_3_DESCRIPTION', 'Швейцарский мост в IT'),
  ('ru', 'ABOUT', 'EVENT_4', 'Стажировка'),
  ('ru', 'ABOUT', 'EVENT_4_DATE', 'Настоящее время'),
  ('ru', 'ABOUT', 'EVENT_5', 'Будущие цели'),
  ('ru', 'ABOUT', 'EVENT_5_DESCRIPTION', 'Быть лучше, чем вчера'),
  ('ru', 'ABOUT.SKILLS', 'TITLE', 'Навыки'),
  ('ru', 'ABOUT.SKILLS', 'OTHER_SKILLS', 'Другие навыки'),
  ('ru', 'ABOUT', 'INTERESTS', 'Интересы и хобби'),
  ('ru', 'ABOUT', 'MOVIES_AND_SERIES', 'Фильмы и сериалы'),
  ('ru', 'ABOUT', 'MOVIES_AND_SERIES_DESCRIPTION', 'Я люблю смотреть хорошие фильмы и сериалы. Это может показаться банальным, но их просмотр также требует определенного навыка — нужно уметь их ценить, узнавать через них что-то новое и, самое главное, по-настоящему наслаждаться процессом.'),
  ('ru', 'ABOUT', 'PSYCHOLOGY', 'Психология'),
  ('ru', 'ABOUT', 'PSYCHOLOGY_DESCRIPTION', 'У меня есть интерес к психологии, особенно сегодня трудно понимать людей, поэтому я стараюсь узнать об этом больше. Чем больше понимаешь, тем легче вести себя в разных ситуациях.'),
  ('ru', 'ABOUT', 'TRAVELING', 'Путешествия'),
  ('ru', 'ABOUT', 'TRAVELING_DESCRIPTION', 'Новый интерес после того, как я приехал в Швейцарию. Очень интересно видеть разные места, разные культуры, разные жизни.'),
  ('ru', 'PROJECTS', 'FEATURED_PROJECTS', 'Избранные проекты'),
  ('ru', 'PROJECTS', 'MORE_PROJECTS', 'Больше проектов'),
  ('ru', 'CONTACT', 'CONTACT_INFORMATION', 'Контактная информация'),
  ('ru', 'CONTACT', 'EMAIL', 'Почта'),
  ('ru', 'CONTACT', 'PHONE', 'Телефон'),
  ('ru', 'CONTACT', 'LOCATION', 'Местоположение'),
  ('ru', 'CONTACT', 'LOCATION_DESCRIPTION', 'Швейцария, Цюрих'),
  ('ru', 'CONTACT', 'SEND_MESSAGE_TITLE', 'Связаться'),
  ('ru', 'CONTACT.MESSAGE', 'SEND_MESSAGE', 'Отправить сообщение'),
  ('ru', 'CONTACT.MESSAGE', 'NAME', 'Имя'),
  ('ru', 'CONTACT.MESSAGE', 'EMAIL', 'Почта'),
  ('ru', 'CONTACT.MESSAGE', 'MESSAGE', 'Сообщение'),
  ('ru', 'CONTACT.MESSAGE', 'SEND', 'Отправить'),
  ('ru', 'CONTACT.MESSAGE', 'SUCCESS', 'Сообщение отправлено'),
  ('ru', 'CONTACT.MESSAGE', 'NAME_REQUIRED', 'Имя обязательно'),
  ('ru', 'CONTACT.MESSAGE', 'NAME_MINLENGTH', 'Имя должно быть не менее 2 символов'),
  ('ru', 'CONTACT.MESSAGE', 'EMAIL_REQUIRED', 'Почта обязательна'),
  ('ru', 'CONTACT.MESSAGE', 'EMAIL_INVALID', 'Пожалуйста, введите действительный адрес электронной почты'),
  ('ru', 'CONTACT.MESSAGE', 'SUBJECT', 'Тема'),
  ('ru', 'CONTACT.MESSAGE', 'SUBJECT_REQUIRED', 'Тема обязательна'),
  ('ru', 'CONTACT.MESSAGE', 'MESSAGE_REQUIRED', 'Сообщение обязательно'),
  ('ru', 'CONTACT.MESSAGE', 'MESSAGE_MINLENGTH', 'Ваше сообщение должно быть не менее 10 символов'),
  ('ru', 'CONTACT.MESSAGE', 'SUCCESS_DESCRIPTION', 'Ваше сообщение отправлено успешно! Я скоро отвечу вам.'),
  ('ru', 'CONTACT.MESSAGE', 'ERROR', 'Ошибка'),
  ('ru', 'CONTACT.MESSAGE', 'ERROR_DESCRIPTION', 'Произошла ошибка при отправке сообщения. Пожалуйста, проверьте форму и попробуйте снова.'),
  ('ru', 'AI_ASSISTANT', 'SECTION_TITLE', 'Интерактивный ИИ Ассистент'),
  ('ru', 'AI_ASSISTANT', 'CHAT_TITLE', 'AI клон Шакира'),
  ('ru', 'AI_ASSISTANT', 'CHAT_SUBTITLE', 'Спрашивай меня о моих навыках, опыте или проектах'),
  ('ru', 'AI_ASSISTANT', 'NOTE_TITLE', 'Примечание:'),
  ('ru', 'AI_ASSISTANT', 'NOTE', 'Этот ИИ ассистент работает на OPEN AI и был обучен на определенной информации о мне. Он попытается дать вам релевантную информацию, но если вы видите что-то странное или неточное, просто спросите меня напрямую. Вы можете найти мой'),
  ('ru', 'AI_ASSISTANT', 'LINKEDIN', 'LinkedIn профиль'),
  ('ru', 'AI_ASSISTANT', 'OR', 'или'),
  ('ru', 'AI_ASSISTANT', 'CONTACT_ME', 'свяжитесь со мной напрямую'),
  ('ru', 'AI_ASSISTANT.AI_CHAT', 'CHAT_TITLE', 'AI клон Шакира'),
  ('ru', 'AI_ASSISTANT.AI_CHAT', 'CHAT_SUBTITLE', 'Спрашивай меня о моих навыках, опыте или проектах'),
  ('ru', 'AI_ASSISTANT.AI_CHAT', 'FIRST_MESSAGE', 'Привет! Я AI клон Шакира. Спрашивай меня о моих навыках, опыте или как связаться со мной.'),
  ('ru', 'AI_ASSISTANT.AI_CHAT', 'SUGGESTED_QUESTIONS_TITLE', 'Попробуйте спросить:'),
  ('ru', 'AI_ASSISTANT.AI_CHAT', 'SUGGESTED_QUESTIONS_1', 'Какие у тебя навыки?'),
  ('ru', 'AI_ASSISTANT.AI_CHAT', 'SUGGESTED_QUESTIONS_2', 'Как мне с тобой связаться?'),
  ('ru', 'AI_ASSISTANT.AI_CHAT', 'SUGGESTED_QUESTIONS_3', 'Где ты находишься?'),
  ('ru', 'AI_ASSISTANT.AI_CHAT', 'SUGGESTED_QUESTIONS_4', 'Какой у тебя фонов?'),
  ('ru', 'AI_ASSISTANT.AI_CHAT', 'SUGGESTED_QUESTIONS_5', 'Какие технологии ты используешь?'),
  ('ru', 'AI_ASSISTANT.AI_CHAT', 'SUGGESTED_QUESTIONS_6', 'Кто такой Кен?'),
  ('ru', 'AI_ASSISTANT.AI_CHAT', 'CHAT_INPUT_PLACEHOLDER', 'Спроси меня что-нибудь...'),
  ('ru', 'VIRTUAL_CV', 'LOADING', 'Загрузка данных резюме...'),
  ('ru', 'VIRTUAL_CV', 'FULLNAME', 'Шакир СУЛТАНОВ'),
  ('ru', 'VIRTUAL_CV', 'TITLE', 'Fullstack Разработчик'),
  ('ru', 'VIRTUAL_CV', 'PROFILE', 'ПРОФИЛЬ'),
  ('ru', 'VIRTUAL_CV', 'CONTACT', 'КОНТАКТ'),
  ('ru', 'VIRTUAL_CV', 'EDUCATION', 'ОБРАЗОВАНИЕ'),
  ('ru', 'VIRTUAL_CV', 'LANGUAGES', 'ЯЗЫКИ'),
  ('ru', 'VIRTUAL_CV', 'REFERENCES', 'СВЯЗИ'),
  ('ru', 'VIRTUAL_CV', 'HOBBIES', 'ХОББИ'),
  ('ru', 'VIRTUAL_CV', 'IT_SKILLS', 'IT НАВЫКИ'),
  ('ru', 'VIRTUAL_CV', 'ADVANCED', 'ПРОФЕССИОНАЛЬНЫЕ'),
  ('ru', 'VIRTUAL_CV', 'INTERMEDIATE', 'СРЕДНИЕ'),
  ('ru', 'VIRTUAL_CV', 'BEGINNER', 'НАЧИНАЮЩИЕ'),
  ('ru', 'VIRTUAL_CV', 'BASIC', 'ОСНОВНЫЕ'),
  ('ru', 'VIRTUAL_CV', 'WORK_EXPERIENCE', 'ПРОФЕССИОНАЛЬНЫЙ ОПЫТ'),
  ('ru', 'VIRTUAL_CV', 'CERTIFICATIONS', 'СЕРТИФИКАТЫ'),
  ('ru', 'VIRTUAL_CV', 'DOWNLOAD_CV', 'Скачать резюме'),
  ('ru', 'CLOCK', 'START', 'Старт'),
  ('ru', 'CLOCK', 'STOP', 'Стоп'),
  ('ru', 'CLOCK', 'RESET', 'Сброс'),
  ('ru', 'BUTTONS', 'VIEW_CODE', 'Посмотреть код'),
  ('ru', 'BUTTONS', 'LIVE_DEMO', 'Посмотреть демо'),
  ('ru', 'BUTTONS', 'SEND_MESSAGE', 'Отправить сообщение'),
  ('ru', 'BUTTONS', 'DEMO', 'Демо'),
  ('ru', 'BUTTONS', 'CODE', 'Код')
ON CONFLICT ("languageCode", "namespace", "key") DO NOTHING;

-- Translations for tr (135 keys)
INSERT INTO "translations" ("languageCode", "namespace", "key", "value") VALUES
  ('tr', 'HEADER', 'HOME', 'Ana Sayfa'),
  ('tr', 'HEADER', 'ABOUT', 'Hakkımda'),
  ('tr', 'HEADER', 'PROJECTS', 'Projeler'),
  ('tr', 'HEADER', 'CONTACT', 'İletişim'),
  ('tr', 'HEADER', 'CV', 'Özgeçmiş'),
  ('tr', 'HEADER', 'AI_ASSISTANT', 'SHAKO AI'),
  ('tr', 'HEADER', 'CLOCK', 'Saat'),
  ('tr', 'HEADER', 'NAVIGATION', 'Navigasyon'),
  ('tr', 'HERO_TITLES', 'HOME_1', 'Hoş geldiniz'),
  ('tr', 'HERO_TITLES', 'HOME_2', 'benim'),
  ('tr', 'HERO_TITLES', 'HOME_3', 'SHKRSLTNV'),
  ('tr', 'HERO_TITLES', 'HOME_SUBTITLE', 'Fullstack Geliştirici'),
  ('tr', 'HERO_TITLES', 'ABOUT_ME', 'HAKKIMDA'),
  ('tr', 'HERO_TITLES', 'ABOUT_ME_SUBTITLE', 'Fullstack Geliştirici'),
  ('tr', 'HERO_TITLES', 'PROJECTS', 'PROJELER'),
  ('tr', 'HERO_TITLES', 'PROJECTS_SUBTITLE', 'Projelerime bir göz atalım'),
  ('tr', 'HERO_TITLES', 'CONTACT', 'İLETİŞİM'),
  ('tr', 'HERO_TITLES', 'CONTACT_SUBTITLE', 'Benimle iletişime geçin'),
  ('tr', 'HERO_TITLES', 'CLOCK', 'SAAT & ZAMANLAYICI'),
  ('tr', 'HERO_TITLES', 'CLOCK_SUBTITLE', 'Zamanı kolayca takip edin'),
  ('tr', 'HOME', 'ABOUT_ME', 'HAKKIMDA'),
  ('tr', 'HOME', 'HI', 'Merhaba!'),
  ('tr', 'HOME', 'ME_DESCRIPTION', 'Ben Shakir, 24 yaşındayım, Ukrayna''da doğdum ama Ahıska Türküyüm ve şu anda İsviçre''de yaşıyorum. Size ''havalı'' görünmek için burada havalı bir metin yazabilirdim, ama ben sadeliği seven bir insanım ve sadece BT''yi sevdiğimi söyleyeceğim. Hayatta ilerleyip gelişmeyi seviyorum, öğrenmeyi seviyorum, harika şeyler yaratmayı seviyorum. Elimden geldiğince çok şey yapıyorum ve her zaman yapacağım.'),
  ('tr', 'HOME', 'BUILD', 'İNŞA ET'),
  ('tr', 'HOME', 'BUILD_DESCRIPTION', 'Gerçek sorunları çözen temiz, verimli çözümler üretiyorum. Sadeliğin en üst düzey incelik olduğuna inanıyorum.'),
  ('tr', 'HOME', 'LEARN', 'ÖĞREN'),
  ('tr', 'HOME', 'LEARN_DESCRIPTION', 'Her proje bir öğrenme fırsatıdır. Sürekli olarak yeni teknolojileri keşfediyor ve becerilerimi geliştiriyorum.'),
  ('tr', 'HOME', 'GROW', 'BÜYÜ'),
  ('tr', 'HOME', 'GROW_DESCRIPTION', 'Her gün daha iyi olmak için zorlukları ve geri bildirimleri kucaklıyorum. Yolculuk, varış noktası kadar önemlidir.'),
  ('tr', 'HOME', 'FEATURED_PROJECTS', 'Öne Çıkan Projeler'),
  ('tr', 'HOME', 'IN_TOUCH', 'İletişime Geçin'),
  ('tr', 'HOME', 'LET''S_WORK_TOGETHER', 'Birlikte çalışalım'),
  ('tr', 'HOME', 'IN_TOUCH_DESCRIPTION', 'Yeni projeler, yaratıcı fikirler veya vizyonunuzun bir parçası olma fırsatlarını tartışmaya her zaman açığım.'),
  ('tr', 'HOME', 'EMAIL_ME', 'Bana E-posta Gönder'),
  ('tr', 'ABOUT', 'JOURNEY', 'Yolculuğum'),
  ('tr', 'ABOUT', 'HELLO', 'Merhaba, ben Shakir'),
  ('tr', 'ABOUT', 'IMAGE_CAPTION', 'Bu benim :)'),
  ('tr', 'ABOUT', 'BIO_PART1', 'Havalı görünmeye veya olduğumdan daha iyi görünmeye çalışmayacağım. {{age}} yaşındayım, Ukrayna''nın küçük bir köyünde doğup büyüdüm, soyum Ahıska Türkü. Her zaman bilgisayarlara ilgi duydum – özellikle teknolojinin nasıl bir araya geldiğine – ve tutkum bu gücü harika şeyler yaratmak için kullanmak olmuştur.'),
  ('tr', 'ABOUT', 'BIO_PART2', 'Üniversitede bana öğretilen BT''nin hemen hemen her alanında oldukça iyi temel bilgiye sahibim. İsviçre''ye geldikten sonra Powercoders''a katılma şansım oldu, burada İsviçre hakkında, iş kültürü hakkında, fırsatlar hakkında birçok bilgi edindim, yeni geliştirme becerileri öğrendim ve en önemlisi çok harika insanlarla tanıştım.'),
  ('tr', 'ABOUT', 'BIO_PART3', 'Her zaman öğrenmeyi, gelişmeyi sevdim, evet, ''vazgeçtiğim'', nasıl yapılacağını, kime başvuracağımı anlamadığım zamanlar oldu. Ama en sevdiğim becerilerden biri vazgeçmeyi sevmememdir.'),
  ('tr', 'ABOUT', 'BIO_PART4', 'Ve şimdi BFH Fachhohschule''de Full Stack geliştirici olarak stajyer olarak çalışıyorum, burada oldukça ilginç projelerde çalışma, deneyim kazanma, gelişme ve hem sosyal hem de teknik yeni beceriler edinme şansım oldu. Üniversitenin ilk gününden beri insanlara faydalı olabilecek, sadece birine para kazandırmakla kalmayıp belki de birine yardımcı olabilecek projelerde çalışma arzum vardı, bu düşünce içimde her zaman bir sıcaklık verdi, bunu her zaman hissetmek istedim. Yarattığın şeyin dünyanın bir yerinde insanlar tarafından kullanıldığı ve onlara yardımcı olduğu düşüncesi - bundan daha iyi ne olabilir?'),
  ('tr', 'ABOUT', 'BIO_PART5', 'Hem tamamen karanlık hem de tamamen aydınlık insanların yaşama şansı olduğu bir dünyada, her zaman ışığın tarafında olmak istedim ve her zaman isteyeceğim.'),
  ('tr', 'ABOUT', 'EDUCATION', 'Eğitim'),
  ('tr', 'ABOUT', 'UNIVERSITY', 'Bilgisayar Mühendisliği Lisans - Odesa I.I.Mechnikov Ulusal Üniversitesi'),
  ('tr', 'ABOUT', 'UNIVERSITY_DESCRIPTION', 'Ukrayna''nın en iyi üniversitelerinden biri. Bilgisayar mimarisi, algoritmalar, veri yapıları ve yazılım mühendisliği prensiplerini öğrendim. Güçlü problem çözme becerileri ve bilgisayar sistemleri hakkında derin bir anlayış geliştirdim. Bize donanımdan yazılıma kadar BT''nin neredeyse her alanı öğretildi.'),
  ('tr', 'ABOUT', 'POWERCODERS_DESCRIPTION', 'Mültecilerin ve göçmenlerin BT iş pazarına entegre olmalarına yardımcı olan İsviçre''deki yoğun bir kodlama akademisi. Program, web geliştirme konusunda teknik eğitim, yumuşak beceriler atölyeleri ve ortak şirketlerde staj fırsatları içeren bir iş yerleştirme bileşeni içerir.'),
  ('tr', 'ABOUT', 'CAREER_JOURNEY', 'Kariyer Yolculuğu'),
  ('tr', 'ABOUT', 'EVENT_1', 'Eğitim'),
  ('tr', 'ABOUT', 'EVENT_1_DESCRIPTION', 'Bilgisayar Mühendisliği'),
  ('tr', 'ABOUT', 'EVENT_2', 'İsviçre''ye Taşınma'),
  ('tr', 'ABOUT', 'EVENT_2_DESCRIPTION', 'Adaptasyon'),
  ('tr', 'ABOUT', 'EVENT_3', 'Powercoders'),
  ('tr', 'ABOUT', 'EVENT_3_DESCRIPTION', 'BT''ye İsviçre köprüsü'),
  ('tr', 'ABOUT', 'EVENT_4', 'Staj'),
  ('tr', 'ABOUT', 'EVENT_4_DATE', 'Şu an'),
  ('tr', 'ABOUT', 'EVENT_5', 'Gelecek hedefleri'),
  ('tr', 'ABOUT', 'EVENT_5_DESCRIPTION', 'Dünden daha iyi ol'),
  ('tr', 'ABOUT.SKILLS', 'TITLE', 'Beceriler'),
  ('tr', 'ABOUT.SKILLS', 'OTHER_SKILLS', 'Diğer Beceriler'),
  ('tr', 'ABOUT', 'INTERESTS', 'İlgi Alanları & Hobiler'),
  ('tr', 'ABOUT', 'MOVIES_AND_SERIES', 'Filmler ve Diziler'),
  ('tr', 'ABOUT', 'MOVIES_AND_SERIES_DESCRIPTION', 'İyi filmler ve TV dizileri izlemeyi seviyorum. Sıradan görünebilir, ancak bunları izlemek de belirli bir beceri gerektirir — onları takdir etmeyi, onlar aracılığıyla yeni şeyler öğrenmeyi ve en önemlisi, deneyimin tadını gerçekten çıkarmayı bilmelisiniz.'),
  ('tr', 'ABOUT', 'PSYCHOLOGY', 'Psikoloji'),
  ('tr', 'ABOUT', 'PSYCHOLOGY_DESCRIPTION', 'Psikolojiye bir tür ilgim var, özellikle bugün insanları anlamak zor, bu yüzden bu konuda daha fazla şey öğrenmeye çalışıyorum. Ne kadar çok anlarsanız, farklı durumlarda davranmak o kadar kolay olur.'),
  ('tr', 'ABOUT', 'TRAVELING', 'Seyahat'),
  ('tr', 'ABOUT', 'TRAVELING_DESCRIPTION', 'İsviçre''ye geldikten sonra yeni ilgi alanı. Farklı yerleri, farklı kültürleri, farklı yaşamları görmek süper ilginç.'),
  ('tr', 'PROJECTS', 'FEATURED_PROJECTS', 'Öne Çıkan Projeler'),
  ('tr', 'PROJECTS', 'MORE_PROJECTS', 'Daha Fazla Proje'),
  ('tr', 'CONTACT', 'CONTACT_INFORMATION', 'İletişim Bilgileri'),
  ('tr', 'CONTACT', 'EMAIL', 'E-posta'),
  ('tr', 'CONTACT', 'PHONE', 'Telefon'),
  ('tr', 'CONTACT', 'LOCATION', 'Konum'),
  ('tr', 'CONTACT', 'LOCATION_DESCRIPTION', 'İsviçre, Zürih'),
  ('tr', 'CONTACT', 'SEND_MESSAGE_TITLE', 'Mesaj Gönder'),
  ('tr', 'CONTACT.MESSAGE', 'SEND_MESSAGE', 'Mesaj Gönder'),
  ('tr', 'CONTACT.MESSAGE', 'NAME', 'İsim'),
  ('tr', 'CONTACT.MESSAGE', 'EMAIL', 'E-posta'),
  ('tr', 'CONTACT.MESSAGE', 'MESSAGE', 'Mesaj'),
  ('tr', 'CONTACT.MESSAGE', 'SEND', 'Gönder'),
  ('tr', 'CONTACT.MESSAGE', 'SUCCESS', 'Mesaj Gönderildi'),
  ('tr', 'CONTACT.MESSAGE', 'NAME_REQUIRED', 'İsim gereklidir'),
  ('tr', 'CONTACT.MESSAGE', 'NAME_MINLENGTH', 'İsim en az 2 karakter olmalıdır'),
  ('tr', 'CONTACT.MESSAGE', 'EMAIL_REQUIRED', 'E-posta gereklidir'),
  ('tr', 'CONTACT.MESSAGE', 'EMAIL_INVALID', 'Lütfen geçerli bir e-posta adresi girin'),
  ('tr', 'CONTACT.MESSAGE', 'SUBJECT', 'Konu'),
  ('tr', 'CONTACT.MESSAGE', 'SUBJECT_REQUIRED', 'Konu gereklidir'),
  ('tr', 'CONTACT.MESSAGE', 'MESSAGE_REQUIRED', 'Mesaj gereklidir'),
  ('tr', 'CONTACT.MESSAGE', 'MESSAGE_MINLENGTH', 'Mesaj en az 10 karakter olmalıdır'),
  ('tr', 'CONTACT.MESSAGE', 'SUCCESS_DESCRIPTION', 'Mesajınız başarıyla gönderildi! En kısa sürede size geri döneceğim.'),
  ('tr', 'CONTACT.MESSAGE', 'ERROR', 'Hata'),
  ('tr', 'CONTACT.MESSAGE', 'ERROR_DESCRIPTION', 'Mesajınız gönderilirken bir hata oluştu. Lütfen formu kontrol edin ve tekrar deneyin.'),
  ('tr', 'AI_ASSISTANT', 'SECTION_TITLE', 'Etkileşimli Yapay Zeka Asistanı'),
  ('tr', 'AI_ASSISTANT', 'CHAT_TITLE', 'Shakir''in YZ klonu'),
  ('tr', 'AI_ASSISTANT', 'CHAT_SUBTITLE', 'Becerilerim, deneyimlerim veya projelerim hakkında bana istediğinizi sorun'),
  ('tr', 'AI_ASSISTANT', 'NOTE_TITLE', 'Not:'),
  ('tr', 'AI_ASSISTANT', 'NOTE', 'Bu YZ asistanı OPEN AI tarafından desteklenmektedir ve benimle ilgili belirli bilgilerle eğitilmiştir. İlgili bilgileri vermeye çalışacaktır, ancak tuhaf veya doğru olmayan bir şey görürseniz, doğrudan bana sorun. Benim'),
  ('tr', 'AI_ASSISTANT', 'LINKEDIN', 'LinkedIn profilimi'),
  ('tr', 'AI_ASSISTANT', 'OR', 'veya'),
  ('tr', 'AI_ASSISTANT', 'CONTACT_ME', 'doğrudan benimle iletişime geçebilirsiniz'),
  ('tr', 'AI_ASSISTANT.AI_CHAT', 'CHAT_TITLE', 'Shakir''in YZ klonu'),
  ('tr', 'AI_ASSISTANT.AI_CHAT', 'CHAT_SUBTITLE', 'Becerilerim, deneyimlerim veya projelerim hakkında bana istediğinizi sorun'),
  ('tr', 'AI_ASSISTANT.AI_CHAT', 'FIRST_MESSAGE', 'Merhaba! Ben Shakir''in YZ klonum. Becerilerim, deneyimlerim veya projelerim hakkında bana istediğinizi sorun.'),
  ('tr', 'AI_ASSISTANT.AI_CHAT', 'SUGGESTED_QUESTIONS_TITLE', 'Soru sormak deneyin:'),
  ('tr', 'AI_ASSISTANT.AI_CHAT', 'SUGGESTED_QUESTIONS_1', 'Becerilerin neler?'),
  ('tr', 'AI_ASSISTANT.AI_CHAT', 'SUGGESTED_QUESTIONS_2', 'Benimle nasıl iletişime geçebilirsiniz?'),
  ('tr', 'AI_ASSISTANT.AI_CHAT', 'SUGGESTED_QUESTIONS_3', 'Neredesin?'),
  ('tr', 'AI_ASSISTANT.AI_CHAT', 'SUGGESTED_QUESTIONS_4', 'Fonksiyonun ne?'),
  ('tr', 'AI_ASSISTANT.AI_CHAT', 'SUGGESTED_QUESTIONS_5', 'Hangilerini kullanıyorsun?'),
  ('tr', 'AI_ASSISTANT.AI_CHAT', 'SUGGESTED_QUESTIONS_6', 'Ken kim?'),
  ('tr', 'AI_ASSISTANT.AI_CHAT', 'CHAT_INPUT_PLACEHOLDER', 'Bir soru sormak ister misin?'),
  ('tr', 'VIRTUAL_CV', 'LOADING', 'CV verileri yükleniyor...'),
  ('tr', 'VIRTUAL_CV', 'FULLNAME', 'Shakir SULTANOV'),
  ('tr', 'VIRTUAL_CV', 'TITLE', 'Fullstack Geliştirici'),
  ('tr', 'VIRTUAL_CV', 'PROFILE', 'PROFİL'),
  ('tr', 'VIRTUAL_CV', 'CONTACT', 'İLETİŞİM'),
  ('tr', 'VIRTUAL_CV', 'EDUCATION', 'EĞİTİM'),
  ('tr', 'VIRTUAL_CV', 'LANGUAGES', 'DİL'),
  ('tr', 'VIRTUAL_CV', 'REFERENCES', 'REFERANSLAR'),
  ('tr', 'VIRTUAL_CV', 'HOBBIES', 'HOBİLER'),
  ('tr', 'VIRTUAL_CV', 'IT_SKILLS', 'IT BECERİLERİ'),
  ('tr', 'VIRTUAL_CV', 'ADVANCED', 'İLERİ'),
  ('tr', 'VIRTUAL_CV', 'INTERMEDIATE', 'ORTA'),
  ('tr', 'VIRTUAL_CV', 'BEGINNER', 'BAŞLANGIÇ'),
  ('tr', 'VIRTUAL_CV', 'BASIC', 'BASİK'),
  ('tr', 'VIRTUAL_CV', 'WORK_EXPERIENCE', 'DENEYİM'),
  ('tr', 'VIRTUAL_CV', 'CERTIFICATIONS', 'SERTİFİKALAR'),
  ('tr', 'VIRTUAL_CV', 'DOWNLOAD_CV', 'CV İndir'),
  ('tr', 'CLOCK', 'START', 'Başlat'),
  ('tr', 'CLOCK', 'STOP', 'Durdur'),
  ('tr', 'CLOCK', 'RESET', 'Sıfırla'),
  ('tr', 'BUTTONS', 'VIEW_CODE', 'Kodu Görüntüle'),
  ('tr', 'BUTTONS', 'LIVE_DEMO', 'Canlı Demo'),
  ('tr', 'BUTTONS', 'SEND_MESSAGE', 'Bana E-posta Gönder'),
  ('tr', 'BUTTONS', 'DEMO', 'Demo'),
  ('tr', 'BUTTONS', 'CODE', 'Kod')
ON CONFLICT ("languageCode", "namespace", "key") DO NOTHING;

-- Translations for ua (135 keys)
INSERT INTO "translations" ("languageCode", "namespace", "key", "value") VALUES
  ('ua', 'HEADER', 'HOME', 'Головна'),
  ('ua', 'HEADER', 'ABOUT', 'Про мене'),
  ('ua', 'HEADER', 'PROJECTS', 'Проєкти'),
  ('ua', 'HEADER', 'CONTACT', 'Контакти'),
  ('ua', 'HEADER', 'CV', 'Резюме'),
  ('ua', 'HEADER', 'AI_ASSISTANT', 'ШІ Асистент'),
  ('ua', 'HEADER', 'CLOCK', 'Годинник'),
  ('ua', 'HEADER', 'NAVIGATION', 'Навігація'),
  ('ua', 'HERO_TITLES', 'HOME_1', 'Привіт'),
  ('ua', 'HERO_TITLES', 'HOME_2', 'це'),
  ('ua', 'HERO_TITLES', 'HOME_3', 'SHKRSLTNV'),
  ('ua', 'HERO_TITLES', 'HOME_SUBTITLE', 'Fullstack Розробник'),
  ('ua', 'HERO_TITLES', 'ABOUT_ME', 'ПРО МЕНЕ'),
  ('ua', 'HERO_TITLES', 'ABOUT_ME_SUBTITLE', 'Fullstack Розробник'),
  ('ua', 'HERO_TITLES', 'PROJECTS', 'ПРОЄКТИ'),
  ('ua', 'HERO_TITLES', 'PROJECTS_SUBTITLE', 'Давайте поглянемо на мої проєкти'),
  ('ua', 'HERO_TITLES', 'CONTACT', 'КОНТАКТИ'),
  ('ua', 'HERO_TITLES', 'CONTACT_SUBTITLE', 'Зв''яжіться зі мною'),
  ('ua', 'HERO_TITLES', 'CLOCK', 'ГОДИННИК ТА ТАЙМЕР'),
  ('ua', 'HERO_TITLES', 'CLOCK_SUBTITLE', 'Слідкуйте за часом'),
  ('ua', 'HOME', 'ABOUT_ME', 'ПРО МЕНЕ'),
  ('ua', 'HOME', 'HI', 'Привіт!'),
  ('ua', 'HOME', 'ME_DESCRIPTION', 'Я Шакір, мені 24 роки, я з України, але я турок-месхетинець, зараз живу в Швейцарії. Я міг би написати тут крутий текст, щоб здаватися вам ''крутим'', але я людина, яка любить простоту, і я просто скажу, що я люблю IT. Я люблю йти по життю і розвиватися, люблю вчитися, люблю створювати класні речі. Я роблю все, що в моїх силах, і завжди буду робити.'),
  ('ua', 'HOME', 'BUILD', 'СТВОРЮВАТИ'),
  ('ua', 'HOME', 'BUILD_DESCRIPTION', 'Створюю чисті, ефективні рішення, які вирішують реальні проблеми. Я вірю, що простота — це найвищий ступінь вишуканості.'),
  ('ua', 'HOME', 'LEARN', 'ВЧИТИСЯ'),
  ('ua', 'HOME', 'LEARN_DESCRIPTION', 'Кожен проєкт — це можливість для навчання. Я постійно вивчаю нові технології та вдосконалюю свої навички.'),
  ('ua', 'HOME', 'GROW', 'РОСТИ'),
  ('ua', 'HOME', 'GROW_DESCRIPTION', 'Приймаю виклики та зворотний зв''язок, щоб ставати кращим з кожним днем. Шлях так само важливий, як і пункт призначення.'),
  ('ua', 'HOME', 'FEATURED_PROJECTS', 'Вибрані проєкти'),
  ('ua', 'HOME', 'IN_TOUCH', 'Зв''язатися'),
  ('ua', 'HOME', 'LET''S_WORK_TOGETHER', 'Давайте працювати разом'),
  ('ua', 'HOME', 'IN_TOUCH_DESCRIPTION', 'Я завжди відкритий для обговорення нових проєктів, творчих ідей або можливостей стати частиною вашого бачення.'),
  ('ua', 'HOME', 'EMAIL_ME', 'Написати мені'),
  ('ua', 'ABOUT', 'JOURNEY', 'Мій шлях'),
  ('ua', 'ABOUT', 'HELLO', 'Привіт, я Шакір'),
  ('ua', 'ABOUT', 'IMAGE_CAPTION', 'Це я :)'),
  ('ua', 'ABOUT', 'BIO_PART1', 'Я не збираюся намагатися звучати круто або краще, ніж я є. Мені {{age}} роки, я народився і виріс у маленькому селі в Україні, за походженням я турок-месхетинець. Я завжди цікавився комп''ютерами – особливо тим, як технології поєднуються один з одним – і моєю пристрастю було використовувати цю силу для створення прекрасних речей.'),
  ('ua', 'ABOUT', 'BIO_PART2', 'У мене досить хороші базові знання майже в усіх областях IT, чому мене навчили в університеті. Після приїзду до Швейцарії у мене був шанс потрапити в power.coders, де я отримав багато інформації про Швейцарію, про робочу культуру, про можливості, вивчив нові навички розробки, і одне з найважливіших – я зустрів багато дуже класних людей.'),
  ('ua', 'ABOUT', 'BIO_PART3', 'Я завжди любив вчитися, любив розвиватися, так, були часи, коли я ''випадав'', не розумів, як це робити, до кого звернутися тощо. Але один з моїх улюблених навичок – це те, що я не люблю здаватися.'),
  ('ua', 'ABOUT', 'BIO_PART4', 'І зараз я працюю стажером у BFH Fachhohschule як Full Stack розробник, де отримав шанс працювати над досить цікавими проєктами, отримувати досвід, розвиватися та набувати нових навичок, як соціальних, так і технічних. З першого дня в університеті у мене було бажання працювати над проєктами, які можуть бути корисні людям, не тільки приносити комусь гроші, але, можливо, і допомагати комусь, ця думка завжди давала мені якесь тепло всередині, я завжди хотів це відчути. Думка про те, що те, що ти створив, десь на землі люди використовують і це їм допомагає – що може бути краще?'),
  ('ua', 'ABOUT', 'BIO_PART5', 'У світі, де і зовсім темні люди, і зовсім світлі люди мають шанс жити, я завжди хотів і завжди буду хотіти бути на боці світла.'),
  ('ua', 'ABOUT', 'EDUCATION', 'Освіта'),
  ('ua', 'ABOUT', 'UNIVERSITY', 'Бакалавр комп''ютерної інженерії - Одеський національний університет імені І.І. Мечникова'),
  ('ua', 'ABOUT', 'UNIVERSITY_DESCRIPTION', 'Один з найкращих університетів України. Вивчав архітектуру комп''ютерів, алгоритми, структури даних та принципи програмної інженерії. Розвинув сильні навички вирішення проблем і глибоке розуміння обчислювальних систем. Нас навчали майже всім сферам IT, від апаратного до програмного забезпечення.'),
  ('ua', 'ABOUT', 'POWERCODERS_DESCRIPTION', 'Інтенсивна академія програмування в Швейцарії, яка допомагає біженцям та мігрантам інтегруватися на ринок праці IT. Програма включає технічне навчання веб-розробці, семінари з м''яких навичок і компонент працевлаштування з можливостями стажування в компаніях-партнерах.'),
  ('ua', 'ABOUT', 'CAREER_JOURNEY', 'Кар''єрний шлях'),
  ('ua', 'ABOUT', 'EVENT_1', 'Освіта'),
  ('ua', 'ABOUT', 'EVENT_1_DESCRIPTION', 'Комп''ютерна інженерія'),
  ('ua', 'ABOUT', 'EVENT_2', 'Переїзд до Швейцарії'),
  ('ua', 'ABOUT', 'EVENT_2_DESCRIPTION', 'Адаптація'),
  ('ua', 'ABOUT', 'EVENT_3', 'Powercoders'),
  ('ua', 'ABOUT', 'EVENT_3_DESCRIPTION', 'Швейцарський міст в IT'),
  ('ua', 'ABOUT', 'EVENT_4', 'Стажування'),
  ('ua', 'ABOUT', 'EVENT_4_DATE', 'Теперішній час'),
  ('ua', 'ABOUT', 'EVENT_5', 'Майбутні цілі'),
  ('ua', 'ABOUT', 'EVENT_5_DESCRIPTION', 'Бути кращим, ніж вчора'),
  ('ua', 'ABOUT.SKILLS', 'TITLE', 'Навички'),
  ('ua', 'ABOUT.SKILLS', 'OTHER_SKILLS', 'Інші навички'),
  ('ua', 'ABOUT', 'INTERESTS', 'Інтереси та хобі'),
  ('ua', 'ABOUT', 'MOVIES_AND_SERIES', 'Фільми та серіали'),
  ('ua', 'ABOUT', 'MOVIES_AND_SERIES_DESCRIPTION', 'Я люблю дивитися хороші фільми та серіали. Це може здатися банальним, але їх перегляд також вимагає певної навички — потрібно вміти їх цінувати, дізнаватися через них щось нове і, найголовніше, по-справжньому насолоджуватися процесом.'),
  ('ua', 'ABOUT', 'PSYCHOLOGY', 'Психологія'),
  ('ua', 'ABOUT', 'PSYCHOLOGY_DESCRIPTION', 'У мене є інтерес до психології, особливо сьогодні важко розуміти людей, тому я намагаюся дізнатися про це більше. Чим більше розумієш, тим легше поводитися в різних ситуаціях.'),
  ('ua', 'ABOUT', 'TRAVELING', 'Подорожі'),
  ('ua', 'ABOUT', 'TRAVELING_DESCRIPTION', 'Новий інтерес після того, як я приїхав до Швейцарії. Дуже цікаво бачити різні місця, різні культури, різні життя.'),
  ('ua', 'PROJECTS', 'FEATURED_PROJECTS', 'Вибрані проєкти'),
  ('ua', 'PROJECTS', 'MORE_PROJECTS', 'Більше проєктів'),
  ('ua', 'CONTACT', 'CONTACT_INFORMATION', 'Контактна інформація'),
  ('ua', 'CONTACT', 'EMAIL', 'Пошта'),
  ('ua', 'CONTACT', 'PHONE', 'Телефон'),
  ('ua', 'CONTACT', 'LOCATION', 'Місцезнаходження'),
  ('ua', 'CONTACT', 'LOCATION_DESCRIPTION', 'Швейцарія, Цюрих'),
  ('ua', 'CONTACT', 'SEND_MESSAGE_TITLE', 'Зв''язатися'),
  ('ua', 'CONTACT.MESSAGE', 'SEND_MESSAGE', 'Надіслати повідомлення'),
  ('ua', 'CONTACT.MESSAGE', 'NAME', 'Ім''я'),
  ('ua', 'CONTACT.MESSAGE', 'EMAIL', 'Пошта'),
  ('ua', 'CONTACT.MESSAGE', 'MESSAGE', 'Повідомлення'),
  ('ua', 'CONTACT.MESSAGE', 'SEND', 'Надіслати'),
  ('ua', 'CONTACT.MESSAGE', 'SUCCESS', 'Повідомлення надіслано'),
  ('ua', 'CONTACT.MESSAGE', 'NAME_REQUIRED', 'Ім''я обов''язкове'),
  ('ua', 'CONTACT.MESSAGE', 'NAME_MINLENGTH', 'Ім''я має бути не менше 2 символів'),
  ('ua', 'CONTACT.MESSAGE', 'EMAIL_REQUIRED', 'Пошта обов''язкова'),
  ('ua', 'CONTACT.MESSAGE', 'EMAIL_INVALID', 'Будь ласка, введіть дійсну адресу електронної пошти'),
  ('ua', 'CONTACT.MESSAGE', 'SUBJECT', 'Тема'),
  ('ua', 'CONTACT.MESSAGE', 'SUBJECT_REQUIRED', 'Тема обов''язкова'),
  ('ua', 'CONTACT.MESSAGE', 'MESSAGE_REQUIRED', 'Повідомлення обов''язкове'),
  ('ua', 'CONTACT.MESSAGE', 'MESSAGE_MINLENGTH', 'Ваше повідомлення має бути не менше 10 символів'),
  ('ua', 'CONTACT.MESSAGE', 'SUCCESS_DESCRIPTION', 'Ваше повідомлення надіслано успішно! Я скоро відповім вам.'),
  ('ua', 'CONTACT.MESSAGE', 'ERROR', 'Помилка'),
  ('ua', 'CONTACT.MESSAGE', 'ERROR_DESCRIPTION', 'Сталася помилка при надсиланні повідомлення. Будь ласка, перевірте форму і спробуйте знову.'),
  ('ua', 'AI_ASSISTANT', 'SECTION_TITLE', 'Інтерактивний ШІ Асистент'),
  ('ua', 'AI_ASSISTANT', 'CHAT_TITLE', 'ШІ клон Шакіра'),
  ('ua', 'AI_ASSISTANT', 'CHAT_SUBTITLE', 'Запитуй мене про мої навички, досвід або проєкти'),
  ('ua', 'AI_ASSISTANT', 'NOTE_TITLE', 'Примітка:'),
  ('ua', 'AI_ASSISTANT', 'NOTE', 'Цей ШІ асистент працює на OPEN AI і був навчений на певній інформації про мене. Він спробує дати вам релевантну інформацію, але якщо ви бачите щось дивне або неточне, просто запитайте мене напряму. Ви можете знайти мій'),
  ('ua', 'AI_ASSISTANT', 'LINKEDIN', 'LinkedIn профіль'),
  ('ua', 'AI_ASSISTANT', 'OR', 'або'),
  ('ua', 'AI_ASSISTANT', 'CONTACT_ME', 'зв''яжіться зі мною напряму'),
  ('ua', 'AI_ASSISTANT.AI_CHAT', 'CHAT_TITLE', 'ШІ клон Шакіра'),
  ('ua', 'AI_ASSISTANT.AI_CHAT', 'CHAT_SUBTITLE', 'Запитуй мене про мої навички, досвід або проєкти'),
  ('ua', 'AI_ASSISTANT.AI_CHAT', 'FIRST_MESSAGE', 'Привіт! Я ШІ клон Шакіра. Запитуй мене про мої навички, досвід або як зв''язатися зі мною.'),
  ('ua', 'AI_ASSISTANT.AI_CHAT', 'SUGGESTED_QUESTIONS_TITLE', 'Спробуйте запитати:'),
  ('ua', 'AI_ASSISTANT.AI_CHAT', 'SUGGESTED_QUESTIONS_1', 'Які в тебе навички?'),
  ('ua', 'AI_ASSISTANT.AI_CHAT', 'SUGGESTED_QUESTIONS_2', 'Як мені з тобою зв''язатися?'),
  ('ua', 'AI_ASSISTANT.AI_CHAT', 'SUGGESTED_QUESTIONS_3', 'Де ти знаходишся?'),
  ('ua', 'AI_ASSISTANT.AI_CHAT', 'SUGGESTED_QUESTIONS_4', 'Який у тебе досвід?'),
  ('ua', 'AI_ASSISTANT.AI_CHAT', 'SUGGESTED_QUESTIONS_5', 'Які технології ти використовуєш?'),
  ('ua', 'AI_ASSISTANT.AI_CHAT', 'SUGGESTED_QUESTIONS_6', 'Хто такий Кен?'),
  ('ua', 'AI_ASSISTANT.AI_CHAT', 'CHAT_INPUT_PLACEHOLDER', 'Запитай мене що-небудь...'),
  ('ua', 'VIRTUAL_CV', 'LOADING', 'Завантаження даних резюме...'),
  ('ua', 'VIRTUAL_CV', 'FULLNAME', 'Шакір СУЛТАНОВ'),
  ('ua', 'VIRTUAL_CV', 'TITLE', 'Fullstack Розробник'),
  ('ua', 'VIRTUAL_CV', 'PROFILE', 'ПРОФІЛЬ'),
  ('ua', 'VIRTUAL_CV', 'CONTACT', 'КОНТАКТ'),
  ('ua', 'VIRTUAL_CV', 'EDUCATION', 'ОСВІТА'),
  ('ua', 'VIRTUAL_CV', 'LANGUAGES', 'ДИСЦИПЛІНИ'),
  ('ua', 'VIRTUAL_CV', 'REFERENCES', 'ДОВІДКИ'),
  ('ua', 'VIRTUAL_CV', 'HOBBIES', 'ХОБІ'),
  ('ua', 'VIRTUAL_CV', 'IT_SKILLS', 'IT НАВИЧКИ'),
  ('ua', 'VIRTUAL_CV', 'ADVANCED', 'ПРОГНОСТИЧНИЙ'),
  ('ua', 'VIRTUAL_CV', 'INTERMEDIATE', 'СЕРЕДНІЙ'),
  ('ua', 'VIRTUAL_CV', 'BEGINNER', 'ПОЧАТКОВИЙ'),
  ('ua', 'VIRTUAL_CV', 'BASIC', 'ПОЧАТКОВИЙ'),
  ('ua', 'VIRTUAL_CV', 'WORK_EXPERIENCE', 'ДОСВІД РОБОТИ'),
  ('ua', 'VIRTUAL_CV', 'CERTIFICATIONS', 'СЕРТИФІКАЦІЇ'),
  ('ua', 'VIRTUAL_CV', 'DOWNLOAD_CV', 'Завантажити резюме'),
  ('ua', 'CLOCK', 'START', 'Старт'),
  ('ua', 'CLOCK', 'STOP', 'Зупинити'),
  ('ua', 'CLOCK', 'RESET', 'Скинути'),
  ('ua', 'BUTTONS', 'VIEW_CODE', 'Переглянути код'),
  ('ua', 'BUTTONS', 'LIVE_DEMO', 'Переглянути демо'),
  ('ua', 'BUTTONS', 'SEND_MESSAGE', 'Надіслати повідомлення'),
  ('ua', 'BUTTONS', 'DEMO', 'Демо'),
  ('ua', 'BUTTONS', 'CODE', 'Код')
ON CONFLICT ("languageCode", "namespace", "key") DO NOTHING;

COMMIT;

-- ================================================
-- Done! All tables created and seeded.
-- ================================================