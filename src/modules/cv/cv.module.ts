import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Language } from '../../entities/language.entity';
import { CvProfile } from '../../entities/cv-profile.entity';
import { CvSkill } from '../../entities/cv-skill.entity';
import { WorkExperience } from '../../entities/work-experience.entity';
import { Education } from '../../entities/education.entity';
import { Certification } from '../../entities/certification.entity';
import { CvLanguage } from '../../entities/cv-language.entity';
import { Reference } from '../../entities/reference.entity';
import { Hobby } from '../../entities/hobby.entity';
import { ContactInfo } from '../../entities/contact-info.entity';
import { CvController } from './cv.controller';
import { CvService } from './cv.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Language,
      CvProfile,
      CvSkill,
      WorkExperience,
      Education,
      Certification,
      CvLanguage,
      Reference,
      Hobby,
      ContactInfo,
    ]),
  ],
  controllers: [CvController],
  providers: [CvService],
  exports: [CvService],
})
export class CvModule {}
