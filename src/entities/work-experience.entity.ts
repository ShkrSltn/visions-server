import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { Language } from './language.entity';

@Entity('work_experiences')
export class WorkExperience {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  languageId: number;

  @ManyToOne(() => Language)
  @JoinColumn({ name: 'languageId' })
  language: Language;

  @Column({ length: 100 })
  period: string;

  @Column({ length: 200 })
  title: string;

  @Column({ length: 200 })
  location: string;

  @Column({ type: 'jsonb', default: [] })
  responsibilities: string[];

  @Column({ default: 0 })
  orderIndex: number;
}
