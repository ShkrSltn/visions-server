import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { Language } from './language.entity';

@Entity('contact_info')
export class ContactInfo {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true })
  languageId: number;

  @ManyToOne(() => Language)
  @JoinColumn({ name: 'languageId' })
  language: Language;

  @Column({ length: 100, nullable: true })
  nationality: string;

  @Column({ length: 20, nullable: true })
  birthdate: string;

  @Column({ length: 200, nullable: true })
  email: string;

  @Column({ length: 50, nullable: true })
  phone: string;

  @Column({ length: 300, nullable: true })
  address: string;

  @Column({ length: 300, nullable: true })
  linkedin: string;

  @Column({ length: 300, nullable: true })
  portfolio: string;

  @Column({ length: 300, nullable: true })
  github: string;
}
