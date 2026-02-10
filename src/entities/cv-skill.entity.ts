import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { Language } from './language.entity';

export enum CvSkillLevel {
  ADVANCED = 'advanced',
  INTERMEDIATE = 'intermediate',
  BEGINNER = 'beginner',
  BASIC = 'basic',
}

@Entity('cv_skills')
export class CvSkill {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  languageId: number;

  @ManyToOne(() => Language)
  @JoinColumn({ name: 'languageId' })
  language: Language;

  @Column({ type: 'enum', enum: CvSkillLevel })
  level: CvSkillLevel;

  @Column({ length: 100 })
  name: string;

  @Column({ default: 0 })
  orderIndex: number;
}
