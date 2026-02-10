import {
  IsString,
  IsBoolean,
  IsOptional,
  IsArray,
  IsNotEmpty,
  IsNumber,
  ValidateNested,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';

export class BlogBlockDto {
  @ApiProperty({ description: 'Block type (heading, paragraph, list, quote, divider, code, image, callout, toggle)' })
  @IsString()
  @IsNotEmpty()
  type: string;

  @ApiPropertyOptional({ description: 'Block text content' })
  @IsOptional()
  @IsString()
  content?: string;

  @ApiPropertyOptional({ description: 'Block metadata (JSON)' })
  @IsOptional()
  metadata?: Record<string, any>;

  @ApiProperty({ description: 'Block order index' })
  @IsNumber()
  orderIndex: number;
}

export class BlogTranslationDto {
  @ApiProperty({ description: 'Language ID' })
  @IsNumber()
  @IsNotEmpty()
  languageId: number;

  @ApiProperty({ description: 'Post title in this language' })
  @IsString()
  @IsNotEmpty()
  title: string;

  @ApiPropertyOptional({ description: 'Short description' })
  @IsOptional()
  @IsString()
  description?: string;

  @ApiPropertyOptional({ description: 'Whether this translation is visible', default: true })
  @IsOptional()
  @IsBoolean()
  isVisible?: boolean;

  @ApiPropertyOptional({ description: 'Content blocks', type: [BlogBlockDto] })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => BlogBlockDto)
  blocks?: BlogBlockDto[];
}

export class CreateBlogPostDto {
  @ApiProperty({ description: 'URL-friendly slug', maxLength: 300 })
  @IsString()
  @IsNotEmpty()
  slug: string;

  @ApiPropertyOptional({ description: 'Cover image URL', maxLength: 500 })
  @IsOptional()
  @IsString()
  coverImageUrl?: string;

  @ApiPropertyOptional({ description: 'Is published', default: false })
  @IsOptional()
  @IsBoolean()
  isPublished?: boolean;

  @ApiPropertyOptional({ description: 'Translations with blocks', type: [BlogTranslationDto] })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => BlogTranslationDto)
  translations?: BlogTranslationDto[];
}
