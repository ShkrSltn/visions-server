import {
  IsString,
  IsBoolean,
  IsOptional,
  IsArray,
  IsNotEmpty,
  ValidateNested,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { BlogBlockDto } from './create-blog-post.dto';

export class SaveTranslationDto {
  @ApiProperty({ description: 'Post title' })
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
