import {
  IsString,
  IsBoolean,
  IsOptional,
  IsArray,
  IsNotEmpty,
  IsNumber,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateProjectDto {
  @ApiProperty({ description: 'Language ID for the project' })
  @IsNumber()
  @IsNotEmpty()
  languageId: number;

  @ApiProperty({ description: 'Project title', maxLength: 200 })
  @IsString()
  @IsNotEmpty()
  title: string;

  @ApiProperty({ description: 'Project description' })
  @IsString()
  @IsNotEmpty()
  description: string;

  @ApiPropertyOptional({ description: 'Project image URL', maxLength: 500 })
  @IsOptional()
  @IsString()
  imageUrl?: string;

  @ApiPropertyOptional({ description: 'Demo link URL', maxLength: 500 })
  @IsOptional()
  @IsString()
  demoLink?: string;

  @ApiPropertyOptional({ description: 'Code repository URL', maxLength: 500 })
  @IsOptional()
  @IsString()
  codeLink?: string;

  @ApiPropertyOptional({ description: 'Is featured project', default: false })
  @IsOptional()
  @IsBoolean()
  featured?: boolean;

  @ApiPropertyOptional({ description: 'Show demo button', default: true })
  @IsOptional()
  @IsBoolean()
  showDemo?: boolean;

  @ApiPropertyOptional({ description: 'Show code button', default: true })
  @IsOptional()
  @IsBoolean()
  showCode?: boolean;

  @ApiPropertyOptional({ description: 'Order index for sorting', default: 0 })
  @IsOptional()
  @IsNumber()
  orderIndex?: number;

  @ApiProperty({ description: 'Array of technologies used', type: [String] })
  @IsArray()
  @IsString({ each: true })
  technologies: string[];
}
