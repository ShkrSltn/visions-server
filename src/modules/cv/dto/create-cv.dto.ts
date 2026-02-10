import {
  IsString,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsArray,
  IsEnum,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { CvSkillLevel } from '../../../entities/cv-skill.entity';

// Profile
export class UpsertCvProfileDto {
  @ApiProperty({ description: 'Profile text content' })
  @IsString()
  @IsNotEmpty()
  content: string;
}

// CV Skill
export class CreateCvSkillDto {
  @ApiProperty({ description: 'Language ID' })
  @IsNumber()
  languageId: number;

  @ApiProperty({ enum: CvSkillLevel })
  @IsEnum(CvSkillLevel)
  level: CvSkillLevel;

  @ApiProperty({ description: 'Skill name' })
  @IsString()
  @IsNotEmpty()
  name: string;

  @ApiPropertyOptional({ default: 0 })
  @IsOptional()
  @IsNumber()
  orderIndex?: number;
}

// Work Experience
export class CreateWorkExperienceDto {
  @ApiProperty({ description: 'Language ID' })
  @IsNumber()
  languageId: number;

  @ApiProperty({ description: 'Period (e.g. "08.2024 - Present")' })
  @IsString()
  @IsNotEmpty()
  period: string;

  @ApiProperty({ description: 'Job title and company' })
  @IsString()
  @IsNotEmpty()
  title: string;

  @ApiProperty({ description: 'Location' })
  @IsString()
  @IsNotEmpty()
  location: string;

  @ApiProperty({ description: 'List of responsibilities', type: [String] })
  @IsArray()
  @IsString({ each: true })
  responsibilities: string[];

  @ApiPropertyOptional({ default: 0 })
  @IsOptional()
  @IsNumber()
  orderIndex?: number;
}

// Education
export class CreateEducationDto {
  @ApiProperty({ description: 'Language ID' })
  @IsNumber()
  languageId: number;

  @ApiProperty()
  @IsString()
  @IsNotEmpty()
  period: string;

  @ApiProperty()
  @IsString()
  @IsNotEmpty()
  degree: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  institution?: string;

  @ApiProperty()
  @IsString()
  @IsNotEmpty()
  location: string;

  @ApiProperty({ type: [String] })
  @IsArray()
  @IsString({ each: true })
  details: string[];

  @ApiPropertyOptional({ default: 0 })
  @IsOptional()
  @IsNumber()
  orderIndex?: number;
}

// Certification
export class CreateCertificationDto {
  @ApiProperty({ description: 'Language ID' })
  @IsNumber()
  languageId: number;

  @ApiProperty()
  @IsString()
  @IsNotEmpty()
  degree: string;

  @ApiProperty()
  @IsString()
  @IsNotEmpty()
  period: string;

  @ApiProperty()
  @IsString()
  @IsNotEmpty()
  location: string;

  @ApiProperty({ type: [String] })
  @IsArray()
  @IsString({ each: true })
  details: string[];

  @ApiPropertyOptional({ default: 0 })
  @IsOptional()
  @IsNumber()
  orderIndex?: number;
}

// CV Language (spoken language)
export class CreateCvLanguageDto {
  @ApiProperty({ description: 'Language ID (system language)' })
  @IsNumber()
  languageId: number;

  @ApiProperty({ description: 'Spoken language name' })
  @IsString()
  @IsNotEmpty()
  name: string;

  @ApiProperty({ description: 'Proficiency level' })
  @IsString()
  @IsNotEmpty()
  level: string;

  @ApiPropertyOptional({ default: 0 })
  @IsOptional()
  @IsNumber()
  orderIndex?: number;
}

// Reference
export class CreateReferenceDto {
  @ApiProperty({ description: 'Language ID' })
  @IsNumber()
  languageId: number;

  @ApiProperty()
  @IsString()
  @IsNotEmpty()
  name: string;

  @ApiProperty()
  @IsString()
  @IsNotEmpty()
  position: string;

  @ApiProperty()
  @IsString()
  @IsNotEmpty()
  contact: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  website?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  phone?: string;

  @ApiPropertyOptional({ default: 0 })
  @IsOptional()
  @IsNumber()
  orderIndex?: number;
}

// Hobby
export class CreateHobbyDto {
  @ApiProperty({ description: 'Language ID' })
  @IsNumber()
  languageId: number;

  @ApiProperty()
  @IsString()
  @IsNotEmpty()
  name: string;

  @ApiProperty()
  @IsString()
  @IsNotEmpty()
  description: string;

  @ApiPropertyOptional({ default: 0 })
  @IsOptional()
  @IsNumber()
  orderIndex?: number;
}

// Contact Info
export class UpsertContactInfoDto {
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  nationality?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  birthdate?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  email?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  phone?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  address?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  linkedin?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  portfolio?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  github?: string;
}
