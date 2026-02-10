import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { BlogService } from './blog.service';
import { BlogController } from './blog.controller';
import { BlogPost } from '../../entities/blog-post.entity';
import { BlogPostTranslation } from '../../entities/blog-post-translation.entity';
import { BlogBlock } from '../../entities/blog-block.entity';
import { Language } from '../../entities/language.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      BlogPost,
      BlogPostTranslation,
      BlogBlock,
      Language,
    ]),
  ],
  controllers: [BlogController],
  providers: [BlogService],
  exports: [BlogService],
})
export class BlogModule {}
