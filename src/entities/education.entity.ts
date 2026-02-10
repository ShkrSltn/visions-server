import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { Language } from './language.entity';

@Entity('educations')
export class Education {
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
  degree: string;

  @Column({ length: 200, nullable: true })
  institution: string;

  @Column({ length: 200 })
  location: string;

  @Column({ type: 'jsonb', default: [] })
  details: string[];

  @Column({ default: 0 })
  orderIndex: number;
}
