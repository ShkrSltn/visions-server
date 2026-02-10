import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { Language } from './language.entity';

@Entity('cv_references')
export class Reference {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  languageId: number;

  @ManyToOne(() => Language)
  @JoinColumn({ name: 'languageId' })
  language: Language;

  @Column({ length: 200 })
  name: string;

  @Column({ length: 300 })
  position: string;

  @Column({ length: 200 })
  contact: string;

  @Column({ length: 300, nullable: true })
  website: string;

  @Column({ length: 50, nullable: true })
  phone: string;

  @Column({ default: 0 })
  orderIndex: number;
}
