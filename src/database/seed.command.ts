import { DataSource } from 'typeorm';
import * as fs from 'fs';
import * as path from 'path';
import * as bcrypt from 'bcrypt';
import 'dotenv/config';

// Entities
import { Admin } from '../entities/admin.entity';
import { Language } from '../entities/language.entity';
import { Project } from '../entities/project.entity';
import { ProjectTechnology } from '../entities/project-technology.entity';
import { Skill, SkillCategory } from '../entities/skill.entity';
import { TechStackItem } from '../entities/tech-stack-item.entity';
import { CvProfile } from '../entities/cv-profile.entity';
import { CvSkill, CvSkillLevel } from '../entities/cv-skill.entity';
import { WorkExperience } from '../entities/work-experience.entity';
import { Education } from '../entities/education.entity';
import { Certification } from '../entities/certification.entity';
import { CvLanguage } from '../entities/cv-language.entity';
import { Reference } from '../entities/reference.entity';
import { Hobby } from '../entities/hobby.entity';
import { ContactInfo } from '../entities/contact-info.entity';
import { Translation } from '../entities/translation.entity';

// Path to frontend data files
const FRONTEND_DATA_PATH = path.resolve(
  __dirname,
  '..',
  '..',
  '..',
  'visions.shkrsltn',
  'src',
  'assets',
  'data',
);

// Path to frontend i18n files
const FRONTEND_I18N_PATH = path.resolve(
  __dirname,
  '..',
  '..',
  '..',
  'visions.shkrsltn',
  'src',
  'assets',
  'i18n',
);

const LANGUAGES_CONFIG = [
  { code: 'en', name: 'English', isDefault: true },
  { code: 'de', name: 'Deutsch', isDefault: false },
  { code: 'ru', name: 'Russian', isDefault: false },
  { code: 'tr', name: 'Turkish', isDefault: false },
  { code: 'ua', name: 'Ukrainian', isDefault: false },
];

function readJsonFile(langCode: string, filename: string): any {
  const filePath = path.join(FRONTEND_DATA_PATH, langCode, filename);
  if (!fs.existsSync(filePath)) {
    console.warn(`  File not found: ${filePath}, skipping...`);
    return null;
  }
  const content = fs.readFileSync(filePath, 'utf-8');
  return JSON.parse(content);
}

async function seed() {
  console.log('Starting database seed...\n');

  const dataSource = new DataSource({
    type: 'postgres',
    host: process.env.DB_HOST || 'localhost',
    port: parseInt(process.env.DB_PORT || '5432', 10),
    username: process.env.DB_USERNAME || 'postgres',
    password: process.env.DB_PASSWORD || 'postgres',
    database: process.env.DB_NAME || 'visions_db',
    entities: [
      Admin,
      Language,
      Project,
      ProjectTechnology,
      Skill,
      TechStackItem,
      CvProfile,
      CvSkill,
      WorkExperience,
      Education,
      Certification,
      CvLanguage,
      Reference,
      Hobby,
      ContactInfo,
      Translation,
    ],
    synchronize: true,
    logging: false,
  });

  await dataSource.initialize();
  console.log('Database connected.\n');

  // ========== 1. Seed Admin ==========
  console.log('--- Seeding Admin ---');
  const adminRepo = dataSource.getRepository(Admin);
  const existingAdmin = await adminRepo.findOne({
    where: { username: 'admin' },
  });

  if (!existingAdmin) {
    const password = process.env.ADMIN_PASSWORD || 'admin123';
    const passwordHash = await bcrypt.hash(password, 10);
    await adminRepo.save(
      adminRepo.create({ username: 'admin', passwordHash }),
    );
    console.log(`  Admin user created (username: admin, password: ${password})`);
  } else {
    console.log('  Admin user already exists, skipping.');
  }

  // ========== 2. Seed Languages ==========
  console.log('\n--- Seeding Languages ---');
  const langRepo = dataSource.getRepository(Language);

  const languageMap: Record<string, Language> = {};

  for (const langConfig of LANGUAGES_CONFIG) {
    let lang = await langRepo.findOne({ where: { code: langConfig.code } });
    if (!lang) {
      lang = await langRepo.save(
        langRepo.create({
          code: langConfig.code,
          name: langConfig.name,
          isActive: true,
          isDefault: langConfig.isDefault,
        }),
      );
      console.log(`  Created language: ${langConfig.code} (${langConfig.name})`);
    } else {
      console.log(`  Language ${langConfig.code} already exists, skipping.`);
    }
    languageMap[langConfig.code] = lang;
  }

  // ========== 3. Seed Projects ==========
  console.log('\n--- Seeding Projects ---');
  const projectRepo = dataSource.getRepository(Project);
  const projectTechRepo = dataSource.getRepository(ProjectTechnology);

  for (const langCode of Object.keys(languageMap)) {
    const language = languageMap[langCode];
    const data = readJsonFile(langCode, 'projects.json');
    if (!data) continue;

    const existingCount = await projectRepo.count({
      where: { languageId: language.id },
    });
    if (existingCount > 0) {
      console.log(
        `  Projects for ${langCode} already exist (${existingCount}), skipping.`,
      );
      continue;
    }

    const projects = data.featuredProjects || [];
    for (let i = 0; i < projects.length; i++) {
      const p = projects[i];
      const project = await projectRepo.save(
        projectRepo.create({
          languageId: language.id,
          title: p.title,
          description: p.description,
          imageUrl: p.image || null,
          demoLink: p.demoLink || null,
          codeLink: p.codeLink || null,
          featured: p.featured ?? false,
          showDemo: p.showDemo ?? true,
          showCode: p.showCode ?? true,
          orderIndex: i,
        }),
      );

      // Save technologies
      const technologies = p.technologies || [];
      for (let j = 0; j < technologies.length; j++) {
        await projectTechRepo.save(
          projectTechRepo.create({
            projectId: project.id,
            technology: technologies[j],
            orderIndex: j,
          }),
        );
      }
    }
    console.log(`  Seeded ${projects.length} projects for ${langCode}`);
  }

  // ========== 4. Seed Skills ==========
  console.log('\n--- Seeding Skills ---');
  const skillRepo = dataSource.getRepository(Skill);
  const techStackRepo = dataSource.getRepository(TechStackItem);

  for (const langCode of Object.keys(languageMap)) {
    const language = languageMap[langCode];
    const data = readJsonFile(langCode, 'skills.json');
    if (!data) continue;

    const existingCount = await skillRepo.count({
      where: { languageId: language.id },
    });
    if (existingCount > 0) {
      console.log(
        `  Skills for ${langCode} already exist (${existingCount}), skipping.`,
      );
      continue;
    }

    const categoryMap: Record<string, SkillCategory> = {
      frontendSkills: SkillCategory.FRONTEND,
      backendSkills: SkillCategory.BACKEND,
      otherSkills: SkillCategory.OTHER,
    };

    let totalSkills = 0;
    for (const [key, category] of Object.entries(categoryMap)) {
      const skills = data[key] || [];
      for (let i = 0; i < skills.length; i++) {
        await skillRepo.save(
          skillRepo.create({
            languageId: language.id,
            category,
            name: skills[i].name,
            level: skills[i].level,
            description: skills[i].description,
            orderIndex: i,
          }),
        );
        totalSkills++;
      }
    }

    // Tech stack
    const techStack = data.techStack || [];
    for (let i = 0; i < techStack.length; i++) {
      await techStackRepo.save(
        techStackRepo.create({
          languageId: language.id,
          name: techStack[i],
          orderIndex: i,
        }),
      );
    }

    console.log(
      `  Seeded ${totalSkills} skills + ${techStack.length} tech stack items for ${langCode}`,
    );
  }

  // ========== 5. Seed CV Data ==========
  console.log('\n--- Seeding CV Data ---');
  const cvProfileRepo = dataSource.getRepository(CvProfile);
  const cvSkillRepo = dataSource.getRepository(CvSkill);
  const workExpRepo = dataSource.getRepository(WorkExperience);
  const educationRepo = dataSource.getRepository(Education);
  const certRepo = dataSource.getRepository(Certification);
  const cvLangRepo = dataSource.getRepository(CvLanguage);
  const refRepo = dataSource.getRepository(Reference);
  const hobbyRepo = dataSource.getRepository(Hobby);
  const contactRepo = dataSource.getRepository(ContactInfo);

  for (const langCode of Object.keys(languageMap)) {
    const language = languageMap[langCode];
    const data = readJsonFile(langCode, 'cv-data.json');
    if (!data) continue;

    // Check if already seeded
    const existingProfile = await cvProfileRepo.findOne({
      where: { languageId: language.id },
    });
    if (existingProfile) {
      console.log(`  CV data for ${langCode} already exists, skipping.`);
      continue;
    }

    // Profile
    if (data.profile) {
      await cvProfileRepo.save(
        cvProfileRepo.create({
          languageId: language.id,
          content: data.profile,
        }),
      );
    }

    // CV Skills (grouped by level)
    if (data.skills) {
      const levelMap: Record<string, CvSkillLevel> = {
        advanced: CvSkillLevel.ADVANCED,
        intermediate: CvSkillLevel.INTERMEDIATE,
        beginner: CvSkillLevel.BEGINNER,
        basic: CvSkillLevel.BASIC,
      };

      for (const [levelKey, level] of Object.entries(levelMap)) {
        const skillNames: string[] = data.skills[levelKey] || [];
        for (let i = 0; i < skillNames.length; i++) {
          await cvSkillRepo.save(
            cvSkillRepo.create({
              languageId: language.id,
              level,
              name: skillNames[i],
              orderIndex: i,
            }),
          );
        }
      }
    }

    // Work Experience
    const workExperiences = data.workExperience || [];
    for (let i = 0; i < workExperiences.length; i++) {
      const we = workExperiences[i];
      await workExpRepo.save(
        workExpRepo.create({
          languageId: language.id,
          period: we.period,
          title: we.title,
          location: we.location,
          responsibilities: we.responsibilities || [],
          orderIndex: i,
        }),
      );
    }

    // Education
    const educations = data.education || [];
    for (let i = 0; i < educations.length; i++) {
      const ed = educations[i];
      await educationRepo.save(
        educationRepo.create({
          languageId: language.id,
          period: ed.period,
          degree: ed.degree,
          institution: ed.institution || null,
          location: ed.location,
          details: ed.details || [],
          orderIndex: i,
        }),
      );
    }

    // Certifications
    const certifications = data.certifications || [];
    for (let i = 0; i < certifications.length; i++) {
      const cert = certifications[i];
      await certRepo.save(
        certRepo.create({
          languageId: language.id,
          degree: cert.degree,
          period: cert.period,
          location: cert.location,
          details: cert.details || [],
          orderIndex: i,
        }),
      );
    }

    // CV Languages (spoken languages)
    const languages = data.languages || [];
    for (let i = 0; i < languages.length; i++) {
      await cvLangRepo.save(
        cvLangRepo.create({
          languageId: language.id,
          name: languages[i].name,
          level: languages[i].level,
          orderIndex: i,
        }),
      );
    }

    // References
    const references = data.references || [];
    for (let i = 0; i < references.length; i++) {
      const ref = references[i];
      await refRepo.save(
        refRepo.create({
          languageId: language.id,
          name: ref.name,
          position: ref.position,
          contact: ref.contact,
          website: ref.website || null,
          phone: ref.phone || null,
          orderIndex: i,
        }),
      );
    }

    // Hobbies
    const hobbies = data.hobbies || [];
    for (let i = 0; i < hobbies.length; i++) {
      await hobbyRepo.save(
        hobbyRepo.create({
          languageId: language.id,
          name: hobbies[i].name,
          description: hobbies[i].description,
          orderIndex: i,
        }),
      );
    }

    // Contact Info
    if (data.contact) {
      const c = data.contact;
      await contactRepo.save(
        contactRepo.create({
          languageId: language.id,
          nationality: c.nationality || null,
          birthdate: c.birthdate || null,
          email: c.email || null,
          phone: c.phone || null,
          address: c.address || null,
          linkedin: c.linkedin || null,
          portfolio: c.portfolio || null,
          github: c.github || null,
        }),
      );
    }

    console.log(`  Seeded CV data for ${langCode}`);
  }

  // ========== 6. Seed Translations (i18n) ==========
  console.log('\n--- Seeding Translations (i18n) ---');
  const translationRepo = dataSource.getRepository(Translation);

  function flattenJson(
    obj: Record<string, any>,
    prefix = '',
  ): Record<string, string> {
    const result: Record<string, string> = {};
    for (const [k, v] of Object.entries(obj)) {
      const fullKey = prefix ? `${prefix}.${k}` : k;
      if (typeof v === 'object' && v !== null && !Array.isArray(v)) {
        Object.assign(result, flattenJson(v, fullKey));
      } else {
        result[fullKey] = String(v);
      }
    }
    return result;
  }

  for (const langCode of Object.keys(languageMap)) {
    const i18nFilePath = path.join(FRONTEND_I18N_PATH, `${langCode}.json`);
    if (!fs.existsSync(i18nFilePath)) {
      console.log(`  i18n file not found for ${langCode}, skipping.`);
      continue;
    }

    const existingCount = await translationRepo.count({
      where: { languageCode: langCode },
    });
    if (existingCount > 0) {
      console.log(
        `  Translations for ${langCode} already exist (${existingCount}), skipping.`,
      );
      continue;
    }

    const jsonContent = JSON.parse(
      fs.readFileSync(i18nFilePath, 'utf-8'),
    );
    const flat = flattenJson(jsonContent);

    let count = 0;
    for (const [fullPath, value] of Object.entries(flat)) {
      const lastDot = fullPath.lastIndexOf('.');
      const namespace = lastDot > -1 ? fullPath.substring(0, lastDot) : '';
      const key = lastDot > -1 ? fullPath.substring(lastDot + 1) : fullPath;

      await translationRepo.save(
        translationRepo.create({
          languageCode: langCode,
          namespace,
          key,
          value,
        }),
      );
      count++;
    }

    console.log(`  Seeded ${count} translations for ${langCode}`);
  }

  console.log('\n--- Seed completed successfully! ---');
  await dataSource.destroy();
  process.exit(0);
}

seed().catch((error) => {
  console.error('Seed failed:', error);
  process.exit(1);
});
