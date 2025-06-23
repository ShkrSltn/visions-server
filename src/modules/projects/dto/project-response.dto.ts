import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class ProjectResponseDto {
  @ApiProperty({ description: 'Project ID' })
  id: number;

  @ApiProperty({ description: 'Language ID' })
  languageId: number;

  @ApiProperty({ description: 'Project title' })
  title: string;

  @ApiProperty({ description: 'Project description' })
  description: string;

  @ApiPropertyOptional({ description: 'Project image URL' })
  imageUrl?: string;

  @ApiPropertyOptional({ description: 'Demo link URL' })
  demoLink?: string;

  @ApiPropertyOptional({ description: 'Code repository URL' })
  codeLink?: string;

  @ApiProperty({ description: 'Is featured project' })
  featured: boolean;

  @ApiProperty({ description: 'Show demo button' })
  showDemo: boolean;

  @ApiProperty({ description: 'Show code button' })
  showCode: boolean;

  @ApiProperty({ description: 'Order index for sorting' })
  orderIndex: number;

  @ApiProperty({ description: 'Array of technologies used', type: [String] })
  technologies: string[];

  @ApiProperty({ description: 'Creation date' })
  createdAt: Date;

  @ApiProperty({ description: 'Last update date' })
  updatedAt: Date;
}

export class ProjectsListResponseDto {
  @ApiProperty({
    description: 'List of featured projects',
    type: [ProjectResponseDto],
  })
  featuredProjects: ProjectResponseDto[];
}
