import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CvSkillsResponseDto {
  @ApiProperty({ type: [String] })
  advanced: string[];

  @ApiProperty({ type: [String] })
  intermediate: string[];

  @ApiProperty({ type: [String] })
  beginner: string[];

  @ApiProperty({ type: [String] })
  basic: string[];
}

export class WorkExperienceResponseDto {
  @ApiProperty()
  period: string;

  @ApiProperty()
  title: string;

  @ApiProperty()
  location: string;

  @ApiProperty({ type: [String] })
  responsibilities: string[];
}

export class EducationResponseDto {
  @ApiProperty()
  period: string;

  @ApiProperty()
  degree: string;

  @ApiPropertyOptional()
  institution?: string;

  @ApiProperty()
  location: string;

  @ApiProperty({ type: [String] })
  details: string[];
}

export class CertificationResponseDto {
  @ApiProperty()
  degree: string;

  @ApiProperty()
  period: string;

  @ApiProperty()
  location: string;

  @ApiProperty({ type: [String] })
  details: string[];
}

export class CvLanguageResponseDto {
  @ApiProperty()
  name: string;

  @ApiProperty()
  level: string;
}

export class ReferenceResponseDto {
  @ApiProperty()
  name: string;

  @ApiProperty()
  position: string;

  @ApiProperty()
  contact: string;

  @ApiPropertyOptional()
  website?: string;

  @ApiPropertyOptional()
  phone?: string;
}

export class HobbyResponseDto {
  @ApiProperty()
  name: string;

  @ApiProperty()
  description: string;
}

export class ContactInfoResponseDto {
  @ApiPropertyOptional()
  nationality?: string;

  @ApiPropertyOptional()
  birthdate?: string;

  @ApiPropertyOptional()
  email?: string;

  @ApiPropertyOptional()
  phone?: string;

  @ApiPropertyOptional()
  address?: string;

  @ApiPropertyOptional()
  linkedin?: string;

  @ApiPropertyOptional()
  portfolio?: string;

  @ApiPropertyOptional()
  github?: string;
}

export class CvDataResponseDto {
  @ApiProperty()
  profile: string;

  @ApiProperty({ type: CvSkillsResponseDto })
  skills: CvSkillsResponseDto;

  @ApiProperty({ type: [WorkExperienceResponseDto] })
  workExperience: WorkExperienceResponseDto[];

  @ApiProperty({ type: [EducationResponseDto] })
  education: EducationResponseDto[];

  @ApiProperty({ type: [CertificationResponseDto] })
  certifications: CertificationResponseDto[];

  @ApiProperty({ type: [CvLanguageResponseDto] })
  languages: CvLanguageResponseDto[];

  @ApiProperty({ type: [ReferenceResponseDto] })
  references: ReferenceResponseDto[];

  @ApiProperty({ type: [HobbyResponseDto] })
  hobbies: HobbyResponseDto[];

  @ApiProperty({ type: ContactInfoResponseDto })
  contact: ContactInfoResponseDto;
}
