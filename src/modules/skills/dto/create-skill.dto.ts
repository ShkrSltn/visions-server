import {
  IsString,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsEnum,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { SkillCategory } from '../../../entities/skill.entity';

export class CreateSkillDto {
  @ApiProperty({ description: 'Language ID' })
  @IsNumber()
  @IsNotEmpty()
  languageId: number;

  @ApiProperty({
    description: 'Skill category',
    enum: SkillCategory,
    example: SkillCategory.FRONTEND,
  })
  @IsEnum(SkillCategory)
  @IsNotEmpty()
  category: SkillCategory;

  @ApiProperty({ description: 'Skill name', maxLength: 100 })
  @IsString()
  @IsNotEmpty()
  name: string;

  @ApiProperty({ description: 'Skill level', maxLength: 100 })
  @IsString()
  @IsNotEmpty()
  level: string;

  @ApiProperty({ description: 'Skill description' })
  @IsString()
  @IsNotEmpty()
  description: string;

  @ApiPropertyOptional({ description: 'Order index', default: 0 })
  @IsOptional()
  @IsNumber()
  orderIndex?: number;
}

export class CreateTechStackItemDto {
  @ApiProperty({ description: 'Language ID' })
  @IsNumber()
  @IsNotEmpty()
  languageId: number;

  @ApiProperty({ description: 'Technology name', maxLength: 100 })
  @IsString()
  @IsNotEmpty()
  name: string;

  @ApiPropertyOptional({ description: 'Order index', default: 0 })
  @IsOptional()
  @IsNumber()
  orderIndex?: number;
}
