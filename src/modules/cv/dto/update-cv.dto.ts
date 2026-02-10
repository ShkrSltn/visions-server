import { PartialType } from '@nestjs/swagger';
import {
  CreateCvSkillDto,
  CreateWorkExperienceDto,
  CreateEducationDto,
  CreateCertificationDto,
  CreateCvLanguageDto,
  CreateReferenceDto,
  CreateHobbyDto,
} from './create-cv.dto';

export class UpdateCvSkillDto extends PartialType(CreateCvSkillDto) {}
export class UpdateWorkExperienceDto extends PartialType(CreateWorkExperienceDto) {}
export class UpdateEducationDto extends PartialType(CreateEducationDto) {}
export class UpdateCertificationDto extends PartialType(CreateCertificationDto) {}
export class UpdateCvLanguageDto extends PartialType(CreateCvLanguageDto) {}
export class UpdateReferenceDto extends PartialType(CreateReferenceDto) {}
export class UpdateHobbyDto extends PartialType(CreateHobbyDto) {}
