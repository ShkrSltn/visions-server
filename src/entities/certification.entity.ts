import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { Language } from './language.entity';

@Entity('certifications')
export class Certification {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  languageId: number;

  @ManyToOne(() => Language)
  @JoinColumn({ name: 'languageId' })
  language: Language;

  @Column({ length: 300 })
  degree: string;

  @Column({ length: 100 })
  period: string;

  @Column({ length: 200 })
  location: string;

  @Column({ type: 'jsonb', default: [] })
  details: string[];

  @Column({ default: 0 })
  orderIndex: number;
}
