import { Injectable, NotFoundException, ConflictException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Language } from '../../entities/language.entity';
import { CreateLanguageDto } from './dto/create-language.dto';
import { UpdateLanguageDto } from './dto/update-language.dto';

@Injectable()
export class LanguagesService {
  constructor(
    @InjectRepository(Language)
    private languageRepository: Repository<Language>,
  ) {}

  async findAll(): Promise<Language[]> {
    return this.languageRepository.find({
      order: { isDefault: 'DESC', code: 'ASC' },
    });
  }

  async findActive(): Promise<Language[]> {
    return this.languageRepository.find({
      where: { isActive: true },
      order: { isDefault: 'DESC', code: 'ASC' },
    });
  }

  async findByCode(code: string): Promise<Language> {
    const language = await this.languageRepository.findOne({
      where: { code },
    });

    if (!language) {
      throw new NotFoundException(`Language with code "${code}" not found`);
    }

    return language;
  }

  async create(createLanguageDto: CreateLanguageDto): Promise<Language> {
    const existing = await this.languageRepository.findOne({
      where: { code: createLanguageDto.code },
    });

    if (existing) {
      throw new ConflictException(
        `Language with code "${createLanguageDto.code}" already exists`,
      );
    }

    if (createLanguageDto.isDefault) {
      await this.languageRepository.update({}, { isDefault: false });
    }

    const language = this.languageRepository.create(createLanguageDto);
    return this.languageRepository.save(language);
  }

  async update(
    id: number,
    updateLanguageDto: UpdateLanguageDto,
  ): Promise<Language> {
    const language = await this.languageRepository.findOne({ where: { id } });

    if (!language) {
      throw new NotFoundException(`Language with ID ${id} not found`);
    }

    if (updateLanguageDto.isDefault) {
      await this.languageRepository.update({}, { isDefault: false });
    }

    Object.assign(language, updateLanguageDto);
    return this.languageRepository.save(language);
  }

  async remove(id: number): Promise<void> {
    const language = await this.languageRepository.findOne({ where: { id } });

    if (!language) {
      throw new NotFoundException(`Language with ID ${id} not found`);
    }

    await this.languageRepository.remove(language);
  }
}
