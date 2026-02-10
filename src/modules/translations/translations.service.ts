import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Translation } from '../../entities/translation.entity';
import { CreateTranslationDto } from './dto/create-translation.dto';
import { UpdateTranslationDto } from './dto/update-translation.dto';

@Injectable()
export class TranslationsService {
  constructor(
    @InjectRepository(Translation)
    private readonly translationRepo: Repository<Translation>,
  ) {}

  /**
   * Get all translations for a language as nested JSON (for ngx-translate).
   */
  async getNestedByLanguage(code: string): Promise<Record<string, any>> {
    const rows = await this.translationRepo.find({
      where: { languageCode: code },
      order: { namespace: 'ASC', key: 'ASC' },
    });

    const result: Record<string, any> = {};

    for (const row of rows) {
      const path = row.namespace
        ? `${row.namespace}.${row.key}`
        : row.key;

      this.setNestedValue(result, path, row.value);
    }

    return result;
  }

  /**
   * Get all translations for a language as flat list (for admin panel).
   */
  async getFlatByLanguage(code: string): Promise<Translation[]> {
    return this.translationRepo.find({
      where: { languageCode: code },
      order: { namespace: 'ASC', key: 'ASC' },
    });
  }

  /**
   * Get all namespaces for a language (for filtering in admin).
   */
  async getNamespaces(code: string): Promise<string[]> {
    const result = await this.translationRepo
      .createQueryBuilder('t')
      .select('DISTINCT t.namespace', 'namespace')
      .where('t.languageCode = :code', { code })
      .orderBy('t.namespace', 'ASC')
      .getRawMany();

    return result.map((r) => r.namespace);
  }

  async findOne(id: number): Promise<Translation> {
    const translation = await this.translationRepo.findOne({ where: { id } });
    if (!translation) {
      throw new NotFoundException(`Translation #${id} not found`);
    }
    return translation;
  }

  async create(dto: CreateTranslationDto): Promise<Translation> {
    const entity = this.translationRepo.create(dto);
    return this.translationRepo.save(entity);
  }

  async update(id: number, dto: UpdateTranslationDto): Promise<Translation> {
    const translation = await this.findOne(id);
    Object.assign(translation, dto);
    return this.translationRepo.save(translation);
  }

  async remove(id: number): Promise<void> {
    const translation = await this.findOne(id);
    await this.translationRepo.remove(translation);
  }

  /**
   * Import a full nested JSON object for a language.
   * Flattens it and upserts all key-value pairs.
   */
  async importJson(
    code: string,
    json: Record<string, any>,
  ): Promise<{ created: number; updated: number }> {
    const flat = this.flattenJson(json);
    let created = 0;
    let updated = 0;

    for (const [fullPath, value] of Object.entries(flat)) {
      const lastDot = fullPath.lastIndexOf('.');
      const namespace = lastDot > -1 ? fullPath.substring(0, lastDot) : '';
      const key = lastDot > -1 ? fullPath.substring(lastDot + 1) : fullPath;

      const existing = await this.translationRepo.findOne({
        where: { languageCode: code, namespace, key },
      });

      if (existing) {
        if (existing.value !== value) {
          existing.value = value;
          await this.translationRepo.save(existing);
          updated++;
        }
      } else {
        await this.translationRepo.save(
          this.translationRepo.create({
            languageCode: code,
            namespace,
            key,
            value,
          }),
        );
        created++;
      }
    }

    return { created, updated };
  }

  /**
   * Flatten nested JSON to dot-notation paths.
   * { HEADER: { HOME: "Home" } } -> { "HEADER.HOME": "Home" }
   */
  private flattenJson(
    obj: Record<string, any>,
    prefix = '',
  ): Record<string, string> {
    const result: Record<string, string> = {};

    for (const [k, v] of Object.entries(obj)) {
      const fullKey = prefix ? `${prefix}.${k}` : k;
      if (typeof v === 'object' && v !== null && !Array.isArray(v)) {
        Object.assign(result, this.flattenJson(v, fullKey));
      } else {
        result[fullKey] = String(v);
      }
    }

    return result;
  }

  /**
   * Set a value in a nested object by dot-notation path.
   * setNestedValue(obj, "CONTACT.MESSAGE.NAME", "Name")
   * -> obj.CONTACT.MESSAGE.NAME = "Name"
   */
  private setNestedValue(
    obj: Record<string, any>,
    path: string,
    value: string,
  ): void {
    const parts = path.split('.');
    let current = obj;

    for (let i = 0; i < parts.length - 1; i++) {
      if (!current[parts[i]] || typeof current[parts[i]] !== 'object') {
        current[parts[i]] = {};
      }
      current = current[parts[i]];
    }

    current[parts[parts.length - 1]] = value;
  }
}
