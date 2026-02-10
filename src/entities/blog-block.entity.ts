import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { BlogPostTranslation } from './blog-post-translation.entity';

@Entity('blog_blocks')
export class BlogBlock {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  translationId: number;

  @ManyToOne(() => BlogPostTranslation, (t) => t.blocks, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'translationId' })
  translation: BlogPostTranslation;

  @Column({ length: 50 })
  type: string;

  @Column({ type: 'text', nullable: true })
  content?: string;

  @Column({ type: 'jsonb', nullable: true })
  metadata?: Record<string, any>;

  @Column({ default: 0 })
  orderIndex: number;
}
