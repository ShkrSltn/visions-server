import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Language } from '../../entities/language.entity';
import { CvProfile } from '../../entities/cv-profile.entity';
import { CvSkill, CvSkillLevel } from '../../entities/cv-skill.entity';
import { WorkExperience } from '../../entities/work-experience.entity';
import { Education } from '../../entities/education.entity';
import { Certification } from '../../entities/certification.entity';
import { CvLanguage } from '../../entities/cv-language.entity';
import { Reference } from '../../entities/reference.entity';
import { Hobby } from '../../entities/hobby.entity';
import { ContactInfo } from '../../entities/contact-info.entity';
import { CvDataResponseDto } from './dto/cv-response.dto';
import {
  UpsertCvProfileDto,
  CreateCvSkillDto,
  CreateWorkExperienceDto,
  CreateEducationDto,
  CreateCertificationDto,
  CreateCvLanguageDto,
  CreateReferenceDto,
  CreateHobbyDto,
  UpsertContactInfoDto,
} from './dto/create-cv.dto';
import {
  UpdateCvSkillDto,
  UpdateWorkExperienceDto,
  UpdateEducationDto,
  UpdateCertificationDto,
  UpdateCvLanguageDto,
  UpdateReferenceDto,
  UpdateHobbyDto,
} from './dto/update-cv.dto';

@Injectable()
export class CvService {
  constructor(
    @InjectRepository(Language)
    private languageRepository: Repository<Language>,
    @InjectRepository(CvProfile)
    private cvProfileRepository: Repository<CvProfile>,
    @InjectRepository(CvSkill)
    private cvSkillRepository: Repository<CvSkill>,
    @InjectRepository(WorkExperience)
    private workExperienceRepository: Repository<WorkExperience>,
    @InjectRepository(Education)
    private educationRepository: Repository<Education>,
    @InjectRepository(Certification)
    private certificationRepository: Repository<Certification>,
    @InjectRepository(CvLanguage)
    private cvLanguageRepository: Repository<CvLanguage>,
    @InjectRepository(Reference)
    private referenceRepository: Repository<Reference>,
    @InjectRepository(Hobby)
    private hobbyRepository: Repository<Hobby>,
    @InjectRepository(ContactInfo)
    private contactInfoRepository: Repository<ContactInfo>,
  ) {}

  private async getLanguageByCode(code: string): Promise<Language> {
    const language = await this.languageRepository.findOne({
      where: { code },
    });
    if (!language) {
      throw new NotFoundException(`Language with code "${code}" not found`);
    }
    return language;
  }

  async findByLanguage(languageCode: string): Promise<CvDataResponseDto> {
    const language = await this.getLanguageByCode(languageCode);
    const langId = language.id;

    const [
      profile,
      cvSkills,
      workExperiences,
      educations,
      certifications,
      cvLanguages,
      references,
      hobbies,
      contactInfo,
    ] = await Promise.all([
      this.cvProfileRepository.findOne({ where: { languageId: langId } }),
      this.cvSkillRepository.find({
        where: { languageId: langId },
        order: { level: 'ASC', orderIndex: 'ASC' },
      }),
      this.workExperienceRepository.find({
        where: { languageId: langId },
        order: { orderIndex: 'ASC' },
      }),
      this.educationRepository.find({
        where: { languageId: langId },
        order: { orderIndex: 'ASC' },
      }),
      this.certificationRepository.find({
        where: { languageId: langId },
        order: { orderIndex: 'ASC' },
      }),
      this.cvLanguageRepository.find({
        where: { languageId: langId },
        order: { orderIndex: 'ASC' },
      }),
      this.referenceRepository.find({
        where: { languageId: langId },
        order: { orderIndex: 'ASC' },
      }),
      this.hobbyRepository.find({
        where: { languageId: langId },
        order: { orderIndex: 'ASC' },
      }),
      this.contactInfoRepository.findOne({ where: { languageId: langId } }),
    ]);

    // Group CV skills by level
    const skillsByLevel = {
      advanced: cvSkills
        .filter((s) => s.level === CvSkillLevel.ADVANCED)
        .map((s) => s.name),
      intermediate: cvSkills
        .filter((s) => s.level === CvSkillLevel.INTERMEDIATE)
        .map((s) => s.name),
      beginner: cvSkills
        .filter((s) => s.level === CvSkillLevel.BEGINNER)
        .map((s) => s.name),
      basic: cvSkills
        .filter((s) => s.level === CvSkillLevel.BASIC)
        .map((s) => s.name),
    };

    return {
      profile: profile?.content || '',
      skills: skillsByLevel,
      workExperience: workExperiences.map((we) => ({
        period: we.period,
        title: we.title,
        location: we.location,
        responsibilities: we.responsibilities,
      })),
      education: educations.map((ed) => ({
        period: ed.period,
        degree: ed.degree,
        institution: ed.institution || undefined,
        location: ed.location,
        details: ed.details,
      })),
      certifications: certifications.map((cert) => ({
        degree: cert.degree,
        period: cert.period,
        location: cert.location,
        details: cert.details,
      })),
      languages: cvLanguages.map((lang) => ({
        name: lang.name,
        level: lang.level,
      })),
      references: references.map((ref) => ({
        name: ref.name,
        position: ref.position,
        contact: ref.contact,
        website: ref.website || undefined,
        phone: ref.phone || undefined,
      })),
      hobbies: hobbies.map((h) => ({
        name: h.name,
        description: h.description,
      })),
      contact: contactInfo
        ? {
            nationality: contactInfo.nationality || undefined,
            birthdate: contactInfo.birthdate || undefined,
            email: contactInfo.email || undefined,
            phone: contactInfo.phone || undefined,
            address: contactInfo.address || undefined,
            linkedin: contactInfo.linkedin || undefined,
            portfolio: contactInfo.portfolio || undefined,
            github: contactInfo.github || undefined,
          }
        : {
            nationality: undefined,
            birthdate: undefined,
            email: undefined,
            phone: undefined,
            address: undefined,
            linkedin: undefined,
            portfolio: undefined,
            github: undefined,
          },
    };
  }

  /**
   * Admin endpoint: returns raw entities WITH IDs for CRUD operations.
   */
  async findByLanguageAdmin(languageCode: string): Promise<any> {
    const language = await this.getLanguageByCode(languageCode);
    const langId = language.id;

    const [
      profile,
      cvSkills,
      workExperiences,
      educations,
      certifications,
      cvLanguages,
      references,
      hobbies,
      contactInfo,
    ] = await Promise.all([
      this.cvProfileRepository.findOne({ where: { languageId: langId } }),
      this.cvSkillRepository.find({
        where: { languageId: langId },
        order: { level: 'ASC', orderIndex: 'ASC' },
      }),
      this.workExperienceRepository.find({
        where: { languageId: langId },
        order: { orderIndex: 'ASC' },
      }),
      this.educationRepository.find({
        where: { languageId: langId },
        order: { orderIndex: 'ASC' },
      }),
      this.certificationRepository.find({
        where: { languageId: langId },
        order: { orderIndex: 'ASC' },
      }),
      this.cvLanguageRepository.find({
        where: { languageId: langId },
        order: { orderIndex: 'ASC' },
      }),
      this.referenceRepository.find({
        where: { languageId: langId },
        order: { orderIndex: 'ASC' },
      }),
      this.hobbyRepository.find({
        where: { languageId: langId },
        order: { orderIndex: 'ASC' },
      }),
      this.contactInfoRepository.findOne({ where: { languageId: langId } }),
    ]);

    return {
      profile: profile || null,
      cvSkills,
      workExperiences,
      educations,
      certifications,
      cvLanguages,
      references,
      hobbies,
      contact: contactInfo || null,
    };
  }

  // ========== Profile ==========
  async upsertProfile(
    languageId: number,
    dto: UpsertCvProfileDto,
  ): Promise<CvProfile> {
    let profile = await this.cvProfileRepository.findOne({
      where: { languageId },
    });
    if (profile) {
      profile.content = dto.content;
    } else {
      profile = this.cvProfileRepository.create({ languageId, ...dto });
    }
    return this.cvProfileRepository.save(profile);
  }

  // ========== CV Skills ==========
  async createCvSkill(dto: CreateCvSkillDto): Promise<CvSkill> {
    const skill = this.cvSkillRepository.create(dto);
    return this.cvSkillRepository.save(skill);
  }

  async updateCvSkill(id: number, dto: UpdateCvSkillDto): Promise<CvSkill> {
    const skill = await this.cvSkillRepository.findOne({ where: { id } });
    if (!skill) throw new NotFoundException(`CV Skill with ID ${id} not found`);
    Object.assign(skill, dto);
    return this.cvSkillRepository.save(skill);
  }

  async removeCvSkill(id: number): Promise<void> {
    const skill = await this.cvSkillRepository.findOne({ where: { id } });
    if (!skill) throw new NotFoundException(`CV Skill with ID ${id} not found`);
    await this.cvSkillRepository.remove(skill);
  }

  // ========== Work Experience ==========
  async createWorkExperience(
    dto: CreateWorkExperienceDto,
  ): Promise<WorkExperience> {
    const we = this.workExperienceRepository.create(dto);
    return this.workExperienceRepository.save(we);
  }

  async updateWorkExperience(
    id: number,
    dto: UpdateWorkExperienceDto,
  ): Promise<WorkExperience> {
    const we = await this.workExperienceRepository.findOne({ where: { id } });
    if (!we)
      throw new NotFoundException(`Work experience with ID ${id} not found`);
    Object.assign(we, dto);
    return this.workExperienceRepository.save(we);
  }

  async removeWorkExperience(id: number): Promise<void> {
    const we = await this.workExperienceRepository.findOne({ where: { id } });
    if (!we)
      throw new NotFoundException(`Work experience with ID ${id} not found`);
    await this.workExperienceRepository.remove(we);
  }

  // ========== Education ==========
  async createEducation(dto: CreateEducationDto): Promise<Education> {
    const edu = this.educationRepository.create(dto);
    return this.educationRepository.save(edu);
  }

  async updateEducation(
    id: number,
    dto: UpdateEducationDto,
  ): Promise<Education> {
    const edu = await this.educationRepository.findOne({ where: { id } });
    if (!edu)
      throw new NotFoundException(`Education with ID ${id} not found`);
    Object.assign(edu, dto);
    return this.educationRepository.save(edu);
  }

  async removeEducation(id: number): Promise<void> {
    const edu = await this.educationRepository.findOne({ where: { id } });
    if (!edu)
      throw new NotFoundException(`Education with ID ${id} not found`);
    await this.educationRepository.remove(edu);
  }

  // ========== Certifications ==========
  async createCertification(
    dto: CreateCertificationDto,
  ): Promise<Certification> {
    const cert = this.certificationRepository.create(dto);
    return this.certificationRepository.save(cert);
  }

  async updateCertification(
    id: number,
    dto: UpdateCertificationDto,
  ): Promise<Certification> {
    const cert = await this.certificationRepository.findOne({ where: { id } });
    if (!cert)
      throw new NotFoundException(`Certification with ID ${id} not found`);
    Object.assign(cert, dto);
    return this.certificationRepository.save(cert);
  }

  async removeCertification(id: number): Promise<void> {
    const cert = await this.certificationRepository.findOne({ where: { id } });
    if (!cert)
      throw new NotFoundException(`Certification with ID ${id} not found`);
    await this.certificationRepository.remove(cert);
  }

  // ========== CV Languages ==========
  async createCvLanguage(dto: CreateCvLanguageDto): Promise<CvLanguage> {
    const lang = this.cvLanguageRepository.create(dto);
    return this.cvLanguageRepository.save(lang);
  }

  async updateCvLanguage(
    id: number,
    dto: UpdateCvLanguageDto,
  ): Promise<CvLanguage> {
    const lang = await this.cvLanguageRepository.findOne({ where: { id } });
    if (!lang)
      throw new NotFoundException(`CV Language with ID ${id} not found`);
    Object.assign(lang, dto);
    return this.cvLanguageRepository.save(lang);
  }

  async removeCvLanguage(id: number): Promise<void> {
    const lang = await this.cvLanguageRepository.findOne({ where: { id } });
    if (!lang)
      throw new NotFoundException(`CV Language with ID ${id} not found`);
    await this.cvLanguageRepository.remove(lang);
  }

  // ========== References ==========
  async createReference(dto: CreateReferenceDto): Promise<Reference> {
    const ref = this.referenceRepository.create(dto);
    return this.referenceRepository.save(ref);
  }

  async updateReference(
    id: number,
    dto: UpdateReferenceDto,
  ): Promise<Reference> {
    const ref = await this.referenceRepository.findOne({ where: { id } });
    if (!ref)
      throw new NotFoundException(`Reference with ID ${id} not found`);
    Object.assign(ref, dto);
    return this.referenceRepository.save(ref);
  }

  async removeReference(id: number): Promise<void> {
    const ref = await this.referenceRepository.findOne({ where: { id } });
    if (!ref)
      throw new NotFoundException(`Reference with ID ${id} not found`);
    await this.referenceRepository.remove(ref);
  }

  // ========== Hobbies ==========
  async createHobby(dto: CreateHobbyDto): Promise<Hobby> {
    const hobby = this.hobbyRepository.create(dto);
    return this.hobbyRepository.save(hobby);
  }

  async updateHobby(id: number, dto: UpdateHobbyDto): Promise<Hobby> {
    const hobby = await this.hobbyRepository.findOne({ where: { id } });
    if (!hobby)
      throw new NotFoundException(`Hobby with ID ${id} not found`);
    Object.assign(hobby, dto);
    return this.hobbyRepository.save(hobby);
  }

  async removeHobby(id: number): Promise<void> {
    const hobby = await this.hobbyRepository.findOne({ where: { id } });
    if (!hobby)
      throw new NotFoundException(`Hobby with ID ${id} not found`);
    await this.hobbyRepository.remove(hobby);
  }

  // ========== Contact Info ==========
  async upsertContactInfo(
    languageId: number,
    dto: UpsertContactInfoDto,
  ): Promise<ContactInfo> {
    let contactInfo = await this.contactInfoRepository.findOne({
      where: { languageId },
    });
    if (contactInfo) {
      Object.assign(contactInfo, dto);
    } else {
      contactInfo = this.contactInfoRepository.create({
        languageId,
        ...dto,
      });
    }
    return this.contactInfoRepository.save(contactInfo);
  }
}
