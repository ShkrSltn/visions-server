import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Skill, SkillCategory } from '../../entities/skill.entity';
import { TechStackItem } from '../../entities/tech-stack-item.entity';
import { Language } from '../../entities/language.entity';
import { CreateSkillDto, CreateTechStackItemDto } from './dto/create-skill.dto';
import { UpdateSkillDto, UpdateTechStackItemDto } from './dto/update-skill.dto';
import {
  SkillResponseDto,
  SkillsListResponseDto,
} from './dto/skills-response.dto';

@Injectable()
export class SkillsService {
  constructor(
    @InjectRepository(Skill)
    private skillRepository: Repository<Skill>,
    @InjectRepository(TechStackItem)
    private techStackItemRepository: Repository<TechStackItem>,
    @InjectRepository(Language)
    private languageRepository: Repository<Language>,
  ) {}

  async findByLanguage(languageCode: string): Promise<SkillsListResponseDto> {
    const language = await this.languageRepository.findOne({
      where: { code: languageCode },
    });

    if (!language) {
      throw new NotFoundException(
        `Language with code "${languageCode}" not found`,
      );
    }

    const skills = await this.skillRepository.find({
      where: { languageId: language.id },
      order: { orderIndex: 'ASC' },
    });

    const techStackItems = await this.techStackItemRepository.find({
      where: { languageId: language.id },
      order: { orderIndex: 'ASC' },
    });

    const mapSkill = (skill: Skill): SkillResponseDto => ({
      name: skill.name,
      level: skill.level,
      description: skill.description,
    });

    return {
      frontendSkills: skills
        .filter((s) => s.category === SkillCategory.FRONTEND)
        .map(mapSkill),
      backendSkills: skills
        .filter((s) => s.category === SkillCategory.BACKEND)
        .map(mapSkill),
      otherSkills: skills
        .filter((s) => s.category === SkillCategory.OTHER)
        .map(mapSkill),
      techStack: techStackItems.map((item) => item.name),
    };
  }

  async findAll(languageId?: number): Promise<Skill[]> {
    const where = languageId ? { languageId } : {};
    return this.skillRepository.find({
      where,
      order: { category: 'ASC', orderIndex: 'ASC' },
    });
  }

  async findOne(id: number): Promise<Skill> {
    const skill = await this.skillRepository.findOne({ where: { id } });
    if (!skill) {
      throw new NotFoundException(`Skill with ID ${id} not found`);
    }
    return skill;
  }

  async create(createSkillDto: CreateSkillDto): Promise<Skill> {
    const skill = this.skillRepository.create(createSkillDto);
    return this.skillRepository.save(skill);
  }

  async update(id: number, updateSkillDto: UpdateSkillDto): Promise<Skill> {
    const skill = await this.findOne(id);
    Object.assign(skill, updateSkillDto);
    return this.skillRepository.save(skill);
  }

  async remove(id: number): Promise<void> {
    const skill = await this.findOne(id);
    await this.skillRepository.remove(skill);
  }

  // Tech Stack CRUD
  async findAllTechStack(languageId?: number): Promise<TechStackItem[]> {
    const where = languageId ? { languageId } : {};
    return this.techStackItemRepository.find({
      where,
      order: { orderIndex: 'ASC' },
    });
  }

  async createTechStackItem(
    dto: CreateTechStackItemDto,
  ): Promise<TechStackItem> {
    const item = this.techStackItemRepository.create(dto);
    return this.techStackItemRepository.save(item);
  }

  async updateTechStackItem(
    id: number,
    dto: UpdateTechStackItemDto,
  ): Promise<TechStackItem> {
    const item = await this.techStackItemRepository.findOne({ where: { id } });
    if (!item) {
      throw new NotFoundException(`Tech stack item with ID ${id} not found`);
    }
    Object.assign(item, dto);
    return this.techStackItemRepository.save(item);
  }

  async removeTechStackItem(id: number): Promise<void> {
    const item = await this.techStackItemRepository.findOne({ where: { id } });
    if (!item) {
      throw new NotFoundException(`Tech stack item with ID ${id} not found`);
    }
    await this.techStackItemRepository.remove(item);
  }
}
