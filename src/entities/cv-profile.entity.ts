import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { Language } from './language.entity';

@Entity('cv_profiles')
export class CvProfile {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true })
  languageId: number;

  @ManyToOne(() => Language)
  @JoinColumn({ name: 'languageId' })
  language: Language;

  @Column({ type: 'text' })
  content: string;
}
