import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { Language } from './language.entity';

@Entity('cv_languages')
export class CvLanguage {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  languageId: number;

  @ManyToOne(() => Language)
  @JoinColumn({ name: 'languageId' })
  language: Language;

  @Column({ length: 100 })
  name: string;

  @Column({ length: 100 })
  level: string;

  @Column({ default: 0 })
  orderIndex: number;
}
