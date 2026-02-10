import { ApiProperty } from '@nestjs/swagger';

export class SkillResponseDto {
  @ApiProperty()
  name: string;

  @ApiProperty()
  level: string;

  @ApiProperty()
  description: string;
}

export class SkillsListResponseDto {
  @ApiProperty({ type: [SkillResponseDto] })
  frontendSkills: SkillResponseDto[];

  @ApiProperty({ type: [SkillResponseDto] })
  backendSkills: SkillResponseDto[];

  @ApiProperty({ type: [SkillResponseDto] })
  otherSkills: SkillResponseDto[];

  @ApiProperty({ type: [String] })
  techStack: string[];
}
