import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { BlogPost } from '../../entities/blog-post.entity';
import { BlogPostTranslation } from '../../entities/blog-post-translation.entity';
import { BlogBlock } from '../../entities/blog-block.entity';
import { Language } from '../../entities/language.entity';
import { CreateBlogPostDto } from './dto/create-blog-post.dto';
import { UpdateBlogPostDto } from './dto/update-blog-post.dto';
import { SaveTranslationDto } from './dto/save-translation.dto';
import {
  BlogPostResponseDto,
  BlogPostListItemDto,
  BlogTranslationResponseDto,
  BlogBlockResponseDto,
} from './dto/blog-response.dto';

@Injectable()
export class BlogService {
  constructor(
    @InjectRepository(BlogPost)
    private postRepo: Repository<BlogPost>,
    @InjectRepository(BlogPostTranslation)
    private translationRepo: Repository<BlogPostTranslation>,
    @InjectRepository(BlogBlock)
    private blockRepo: Repository<BlogBlock>,
    @InjectRepository(Language)
    private languageRepo: Repository<Language>,
  ) {}

  // ─── Public endpoints ───

  async findPublished(lang: string): Promise<BlogPostListItemDto[]> {
    const language = await this.languageRepo.findOne({
      where: { code: lang, isActive: true },
    });

    if (!language) {
      return [];
    }

    const translations = await this.translationRepo
      .createQueryBuilder('t')
      .innerJoinAndSelect('t.post', 'post')
      .where('t.languageId = :langId', { langId: language.id })
      .andWhere('t.isVisible = :visible', { visible: true })
      .andWhere('post.isPublished = :published', { published: true })
      .orderBy('post.publishedAt', 'DESC')
      .getMany();

    return translations.map((t) => ({
      id: t.post.id,
      slug: t.post.slug,
      coverImageUrl: t.post.coverImageUrl,
      title: t.title,
      description: t.description,
      isPublished: t.post.isPublished,
      publishedAt: t.post.publishedAt,
      createdAt: t.post.createdAt,
    }));
  }

  async findBySlug(
    slug: string,
    lang: string,
  ): Promise<BlogPostResponseDto | null> {
    const language = await this.languageRepo.findOne({
      where: { code: lang, isActive: true },
    });

    if (!language) {
      throw new NotFoundException(`Language "${lang}" not found`);
    }

    const post = await this.postRepo.findOne({
      where: { slug, isPublished: true },
    });

    if (!post) {
      throw new NotFoundException(`Blog post "${slug}" not found`);
    }

    const translation = await this.translationRepo.findOne({
      where: { postId: post.id, languageId: language.id, isVisible: true },
      relations: ['blocks'],
    });

    if (!translation) {
      throw new NotFoundException(
        `Translation for "${slug}" in "${lang}" not found`,
      );
    }

    const sortedBlocks = (translation.blocks || []).sort(
      (a, b) => a.orderIndex - b.orderIndex,
    );

    return {
      id: post.id,
      slug: post.slug,
      coverImageUrl: post.coverImageUrl,
      isPublished: post.isPublished,
      publishedAt: post.publishedAt,
      createdAt: post.createdAt,
      updatedAt: post.updatedAt,
      translations: [
        {
          id: translation.id,
          languageId: translation.languageId,
          languageCode: lang,
          title: translation.title,
          description: translation.description,
          isVisible: translation.isVisible,
          blocks: sortedBlocks.map((b) => this.mapBlockToDto(b)),
        },
      ],
    };
  }

  // ─── Admin endpoints ───

  async findAllAdmin(): Promise<BlogPostResponseDto[]> {
    const posts = await this.postRepo.find({
      relations: ['translations', 'translations.language'],
      order: { createdAt: 'DESC' },
    });

    return posts.map((post) => ({
      id: post.id,
      slug: post.slug,
      coverImageUrl: post.coverImageUrl,
      isPublished: post.isPublished,
      publishedAt: post.publishedAt,
      createdAt: post.createdAt,
      updatedAt: post.updatedAt,
      translations: (post.translations || []).map((t) => ({
        id: t.id,
        languageId: t.languageId,
        languageCode: t.language?.code,
        title: t.title,
        description: t.description,
        isVisible: t.isVisible,
      })),
    }));
  }

  async findOneAdminBySlug(slug: string): Promise<BlogPostResponseDto> {
    const post = await this.postRepo.findOne({
      where: { slug },
      relations: [
        'translations',
        'translations.language',
        'translations.blocks',
      ],
    });

    if (!post) {
      throw new NotFoundException(`Blog post "${slug}" not found`);
    }

    return this.mapPostToAdminDto(post);
  }

  async findOneAdmin(id: number): Promise<BlogPostResponseDto> {
    const post = await this.postRepo.findOne({
      where: { id },
      relations: [
        'translations',
        'translations.language',
        'translations.blocks',
      ],
    });

    if (!post) {
      throw new NotFoundException(`Blog post with ID ${id} not found`);
    }

    return this.mapPostToAdminDto(post);
  }

  async create(dto: CreateBlogPostDto): Promise<BlogPostResponseDto> {
    const post = new BlogPost();
    post.slug = dto.slug;
    post.coverImageUrl = dto.coverImageUrl;
    post.isPublished = dto.isPublished || false;
    if (dto.isPublished) {
      post.publishedAt = new Date();
    }

    const savedPost = await this.postRepo.save(post);

    if (dto.translations?.length) {
      for (const tDto of dto.translations) {
        await this.saveTranslationInternal(
          savedPost.id,
          tDto.languageId,
          tDto,
        );
      }
    }

    return this.findOneAdmin(savedPost.id);
  }

  async update(
    id: number,
    dto: UpdateBlogPostDto,
  ): Promise<BlogPostResponseDto> {
    const post = await this.postRepo.findOne({ where: { id } });
    if (!post) {
      throw new NotFoundException(`Blog post with ID ${id} not found`);
    }

    if (dto.slug !== undefined) post.slug = dto.slug;
    if (dto.coverImageUrl !== undefined) post.coverImageUrl = dto.coverImageUrl;
    if (dto.isPublished !== undefined) {
      if (dto.isPublished && !post.isPublished) {
        post.publishedAt = new Date();
      }
      post.isPublished = dto.isPublished;
    }

    await this.postRepo.save(post);

    return this.findOneAdmin(id);
  }

  async remove(id: number): Promise<void> {
    const post = await this.postRepo.findOne({ where: { id } });
    if (!post) {
      throw new NotFoundException(`Blog post with ID ${id} not found`);
    }
    await this.postRepo.remove(post);
  }

  async togglePublish(id: number): Promise<BlogPostResponseDto> {
    const post = await this.postRepo.findOne({ where: { id } });
    if (!post) {
      throw new NotFoundException(`Blog post with ID ${id} not found`);
    }

    post.isPublished = !post.isPublished;
    if (post.isPublished && !post.publishedAt) {
      post.publishedAt = new Date();
    }

    await this.postRepo.save(post);
    return this.findOneAdmin(id);
  }

  async saveTranslation(
    postId: number,
    languageId: number,
    dto: SaveTranslationDto,
  ): Promise<BlogPostResponseDto> {
    const post = await this.postRepo.findOne({ where: { id: postId } });
    if (!post) {
      throw new NotFoundException(`Blog post with ID ${postId} not found`);
    }

    await this.saveTranslationInternal(postId, languageId, {
      languageId,
      title: dto.title,
      description: dto.description,
      isVisible: dto.isVisible,
      blocks: dto.blocks,
    });

    return this.findOneAdmin(postId);
  }

  async deleteTranslation(
    postId: number,
    languageId: number,
  ): Promise<BlogPostResponseDto> {
    const translation = await this.translationRepo.findOne({
      where: { postId, languageId },
    });

    if (translation) {
      await this.blockRepo.delete({ translationId: translation.id });
      await this.translationRepo.remove(translation);
    }

    return this.findOneAdmin(postId);
  }

  // ─── Internal helpers ───

  private async saveTranslationInternal(
    postId: number,
    languageId: number,
    data: {
      languageId: number;
      title: string;
      description?: string;
      isVisible?: boolean;
      blocks?: { type: string; content?: string; metadata?: Record<string, any>; orderIndex: number }[];
    },
  ): Promise<void> {
    let translation = await this.translationRepo.findOne({
      where: { postId, languageId },
    });

    if (translation) {
      translation.title = data.title;
      translation.description = data.description;
      translation.isVisible = data.isVisible ?? true;
      await this.translationRepo.save(translation);
    } else {
      const newTranslation = new BlogPostTranslation();
      newTranslation.postId = postId;
      newTranslation.languageId = languageId;
      newTranslation.title = data.title;
      newTranslation.description = data.description;
      newTranslation.isVisible = data.isVisible ?? true;
      translation = await this.translationRepo.save(newTranslation);
    }

    // Sync blocks: delete old, insert new
    await this.blockRepo.delete({ translationId: translation.id });

    if (data.blocks?.length) {
      const blocks = data.blocks.map((b, index) => {
        const block = new BlogBlock();
        block.translationId = translation!.id;
        block.type = b.type;
        block.content = b.content;
        block.metadata = b.metadata;
        block.orderIndex = b.orderIndex ?? index;
        return block;
      });
      await this.blockRepo.save(blocks);
    }
  }

  private mapPostToAdminDto(post: BlogPost): BlogPostResponseDto {
    return {
      id: post.id,
      slug: post.slug,
      coverImageUrl: post.coverImageUrl,
      isPublished: post.isPublished,
      publishedAt: post.publishedAt,
      createdAt: post.createdAt,
      updatedAt: post.updatedAt,
      translations: (post.translations || []).map((t) => ({
        id: t.id,
        languageId: t.languageId,
        languageCode: t.language?.code,
        title: t.title,
        description: t.description,
        isVisible: t.isVisible,
        blocks: (t.blocks || [])
          .sort((a, b) => a.orderIndex - b.orderIndex)
          .map((b) => this.mapBlockToDto(b)),
      })),
    };
  }

  private mapBlockToDto(block: BlogBlock): BlogBlockResponseDto {
    return {
      id: block.id,
      type: block.type,
      content: block.content,
      metadata: block.metadata,
      orderIndex: block.orderIndex,
    };
  }
}
