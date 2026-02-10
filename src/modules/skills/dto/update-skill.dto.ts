import { PartialType } from '@nestjs/swagger';
import { CreateSkillDto, CreateTechStackItemDto } from './create-skill.dto';

export class UpdateSkillDto extends PartialType(CreateSkillDto) {}

export class UpdateTechStackItemDto extends PartialType(CreateTechStackItemDto) {}
