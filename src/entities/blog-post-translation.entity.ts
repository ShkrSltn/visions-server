import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  OneToMany,
  JoinColumn,
  Unique,
} from 'typeorm';
import { BlogPost } from './blog-post.entity';
import { Language } from './language.entity';
import { BlogBlock } from './blog-block.entity';

@Entity('blog_post_translations')
@Unique(['postId', 'languageId'])
export class BlogPostTranslation {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  postId: number;

  @ManyToOne(() => BlogPost, (p) => p.translations, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'postId' })
  post: BlogPost;

  @Column()
  languageId: number;

  @ManyToOne(() => Language)
  @JoinColumn({ name: 'languageId' })
  language: Language;

  @Column({ length: 300 })
  title: string;

  @Column({ type: 'text', nullable: true })
  description?: string;

  @Column({ default: true })
  isVisible: boolean;

  @OneToMany(() => BlogBlock, (b) => b.translation, { cascade: true })
  blocks: BlogBlock[];
}
