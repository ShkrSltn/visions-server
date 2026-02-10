import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  JoinColumn,
  Unique,
} from 'typeorm';
import { Language } from './language.entity';

@Entity('translations')
@Unique(['languageCode', 'namespace', 'key'])
export class Translation {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ length: 5 })
  languageCode: string;

  @Column({ length: 150 })
  namespace: string; // e.g. 'HEADER', 'CONTACT.MESSAGE', 'AI_ASSISTANT.AI_CHAT'

  @Column({ length: 150 })
  key: string; // e.g. 'HOME', 'NAME_REQUIRED'

  @Column({ type: 'text' })
  value: string;

  @ManyToOne(() => Language, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'languageCode', referencedColumnName: 'code' })
  language: Language;
}
