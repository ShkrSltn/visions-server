import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  OneToMany,
} from 'typeorm';
import { BlogPostTranslation } from './blog-post-translation.entity';

@Entity('blog_posts')
export class BlogPost {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true, length: 300 })
  slug: string;

  @Column({ length: 500, nullable: true })
  coverImageUrl?: string;

  @Column({ default: false })
  isPublished: boolean;

  @Column({ type: 'timestamp', nullable: true })
  publishedAt?: Date;

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  createdAt: Date;

  @Column({
    type: 'timestamp',
    default: () => 'CURRENT_TIMESTAMP',
    onUpdate: 'CURRENT_TIMESTAMP',
  })
  updatedAt: Date;

  @OneToMany(() => BlogPostTranslation, (t) => t.post, { cascade: true })
  translations: BlogPostTranslation[];
}
