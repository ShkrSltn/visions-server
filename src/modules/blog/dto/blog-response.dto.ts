import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class BlogBlockResponseDto {
  @ApiProperty()
  id: number;

  @ApiProperty()
  type: string;

  @ApiPropertyOptional()
  content?: string;

  @ApiPropertyOptional()
  metadata?: Record<string, any>;

  @ApiProperty()
  orderIndex: number;
}

export class BlogTranslationResponseDto {
  @ApiProperty()
  id: number;

  @ApiProperty()
  languageId: number;

  @ApiPropertyOptional()
  languageCode?: string;

  @ApiProperty()
  title: string;

  @ApiPropertyOptional()
  description?: string;

  @ApiProperty()
  isVisible: boolean;

  @ApiPropertyOptional({ type: [BlogBlockResponseDto] })
  blocks?: BlogBlockResponseDto[];
}

export class BlogPostResponseDto {
  @ApiProperty()
  id: number;

  @ApiProperty()
  slug: string;

  @ApiPropertyOptional()
  coverImageUrl?: string;

  @ApiProperty()
  isPublished: boolean;

  @ApiPropertyOptional()
  publishedAt?: Date;

  @ApiProperty()
  createdAt: Date;

  @ApiProperty()
  updatedAt: Date;

  @ApiPropertyOptional({ type: [BlogTranslationResponseDto] })
  translations?: BlogTranslationResponseDto[];
}

export class BlogPostListItemDto {
  @ApiProperty()
  id: number;

  @ApiProperty()
  slug: string;

  @ApiPropertyOptional()
  coverImageUrl?: string;

  @ApiProperty()
  title: string;

  @ApiPropertyOptional()
  description?: string;

  @ApiProperty()
  isPublished: boolean;

  @ApiPropertyOptional()
  publishedAt?: Date;

  @ApiProperty()
  createdAt: Date;
}
