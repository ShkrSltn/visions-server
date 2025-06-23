import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  Query,
  ParseIntPipe,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiParam,
  ApiQuery,
  ApiBody,
} from '@nestjs/swagger';
import { ProjectsService } from './projects.service';
import { CreateProjectDto } from './dto/create-project.dto';
import { UpdateProjectDto } from './dto/update-project.dto';
import {
  ProjectResponseDto,
  ProjectsListResponseDto,
} from './dto/project-response.dto';

@ApiTags('projects')
@Controller('projects')
export class ProjectsController {
  constructor(private readonly projectsService: ProjectsService) {}

  @Post()
  @ApiOperation({ summary: 'Create a new project' })
  @ApiResponse({
    status: 201,
    description: 'Project created successfully',
    type: ProjectResponseDto,
  })
  @ApiBody({ type: CreateProjectDto })
  async create(
    @Body() createProjectDto: CreateProjectDto,
  ): Promise<ProjectResponseDto> {
    return this.projectsService.create(createProjectDto);
  }

  @Get()
  @ApiOperation({ summary: 'Get all projects' })
  @ApiQuery({ name: 'languageId', required: false, type: Number })
  @ApiResponse({
    status: 200,
    description: 'List of all projects',
    type: [ProjectResponseDto],
  })
  async findAll(
    @Query('languageId') languageId?: number,
  ): Promise<ProjectResponseDto[]> {
    return this.projectsService.findAll(languageId);
  }

  @Get('featured')
  @ApiOperation({ summary: 'Get featured projects' })
  @ApiQuery({ name: 'languageId', required: false, type: Number })
  @ApiResponse({
    status: 200,
    description: 'List of featured projects',
    type: [ProjectResponseDto],
  })
  async findFeatured(
    @Query('languageId') languageId?: number,
  ): Promise<ProjectResponseDto[]> {
    return this.projectsService.findFeatured(languageId);
  }

  @Get('by-language/:languageCode')
  @ApiOperation({
    summary: 'Get projects by language code (compatible with Angular service)',
  })
  @ApiParam({
    name: 'languageCode',
    type: String,
    description: 'Language code (en, ru, de, tr, ua)',
  })
  @ApiResponse({
    status: 200,
    description: 'Projects for specified language in Angular-compatible format',
    type: ProjectsListResponseDto,
  })
  async findByLanguage(
    @Param('languageCode') languageCode: string,
  ): Promise<ProjectsListResponseDto> {
    return this.projectsService.findByLanguage(languageCode);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get project by ID' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({
    status: 200,
    description: 'Project details',
    type: ProjectResponseDto,
  })
  @ApiResponse({
    status: 404,
    description: 'Project not found',
  })
  async findOne(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<ProjectResponseDto> {
    return this.projectsService.findOne(id);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update project' })
  @ApiParam({ name: 'id', type: Number })
  @ApiBody({ type: UpdateProjectDto })
  @ApiResponse({
    status: 200,
    description: 'Project updated successfully',
    type: ProjectResponseDto,
  })
  @ApiResponse({
    status: 404,
    description: 'Project not found',
  })
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updateProjectDto: UpdateProjectDto,
  ): Promise<ProjectResponseDto> {
    return this.projectsService.update(id, updateProjectDto);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Delete project' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({
    status: 204,
    description: 'Project deleted successfully',
  })
  @ApiResponse({
    status: 404,
    description: 'Project not found',
  })
  async remove(@Param('id', ParseIntPipe) id: number): Promise<void> {
    return this.projectsService.remove(id);
  }

  @Patch(':id/toggle-featured')
  @ApiOperation({ summary: 'Toggle featured status of project' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({
    status: 200,
    description: 'Project featured status toggled',
    type: ProjectResponseDto,
  })
  @ApiResponse({
    status: 404,
    description: 'Project not found',
  })
  async toggleFeatured(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<ProjectResponseDto> {
    return this.projectsService.toggleFeatured(id);
  }

  @Patch('reorder/:languageId')
  @ApiOperation({ summary: 'Reorder projects for a specific language' })
  @ApiParam({ name: 'languageId', type: Number })
  @ApiBody({
    description: 'Array of project IDs in desired order',
    schema: {
      type: 'object',
      properties: {
        projectIds: {
          type: 'array',
          items: { type: 'number' },
          description: 'Array of project IDs in the desired order',
        },
      },
    },
  })
  @ApiResponse({
    status: 200,
    description: 'Projects reordered successfully',
    type: [ProjectResponseDto],
  })
  async reorderProjects(
    @Param('languageId', ParseIntPipe) languageId: number,
    @Body('projectIds') projectIds: number[],
  ): Promise<ProjectResponseDto[]> {
    return this.projectsService.reorderProjects(languageId, projectIds);
  }
}
