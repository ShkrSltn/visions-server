import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule } from '@nestjs/config';
import { AppController } from './app.controller';
import { AppService } from './app.service';

// Modules
import { AuthModule } from './modules/auth/auth.module';
import { LanguagesModule } from './modules/languages/languages.module';
import { ProjectsModule } from './modules/projects/projects.module';
import { SkillsModule } from './modules/skills/skills.module';
import { CvModule } from './modules/cv/cv.module';
import { TranslationsModule } from './modules/translations/translations.module';

// Entities
import { Admin } from './entities/admin.entity';
import { Language } from './entities/language.entity';
import { Project } from './entities/project.entity';
import { ProjectTechnology } from './entities/project-technology.entity';
import { Skill } from './entities/skill.entity';
import { TechStackItem } from './entities/tech-stack-item.entity';
import { CvProfile } from './entities/cv-profile.entity';
import { CvSkill } from './entities/cv-skill.entity';
import { WorkExperience } from './entities/work-experience.entity';
import { Education } from './entities/education.entity';
import { Certification } from './entities/certification.entity';
import { CvLanguage } from './entities/cv-language.entity';
import { Reference } from './entities/reference.entity';
import { Hobby } from './entities/hobby.entity';
import { ContactInfo } from './entities/contact-info.entity';
import { Translation } from './entities/translation.entity';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    TypeOrmModule.forRoot({
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
      synchronize: process.env.NODE_ENV !== 'production', // Only for development
      logging: process.env.NODE_ENV === 'development',
    }),
    AuthModule,
    LanguagesModule,
    ProjectsModule,
    SkillsModule,
    CvModule,
    TranslationsModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
