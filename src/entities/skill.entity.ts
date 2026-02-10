import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { Language } from './language.entity';

export enum SkillCategory {
  FRONTEND = 'frontend',
  BACKEND = 'backend',
  OTHER = 'other',
}

@Entity('skills')
export class Skill {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  languageId: number;

  @ManyToOne(() => Language)
  @JoinColumn({ name: 'languageId' })
  language: Language;

  @Column({ type: 'enum', enum: SkillCategory })
  category: SkillCategory;

  @Column({ length: 100 })
  name: string;

  @Column({ length: 100 })
  level: string;

  @Column({ type: 'text' })
  description: string;

  @Column({ default: 0 })
  orderIndex: number;
}
