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
  UseGuards,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiParam,
  ApiQuery,
  ApiBody,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { SkillsService } from './skills.service';
import { CreateSkillDto, CreateTechStackItemDto } from './dto/create-skill.dto';
import { UpdateSkillDto, UpdateTechStackItemDto } from './dto/update-skill.dto';
import { SkillsListResponseDto } from './dto/skills-response.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { Skill } from '../../entities/skill.entity';
import { TechStackItem } from '../../entities/tech-stack-item.entity';

@ApiTags('skills')
@Controller('skills')
export class SkillsController {
  constructor(private readonly skillsService: SkillsService) {}

  @Get('by-language/:languageCode')
  @ApiOperation({
    summary: 'Get skills by language code (Angular-compatible format)',
  })
  @ApiParam({
    name: 'languageCode',
    type: String,
    description: 'Language code (en, ru, de, tr, ua)',
  })
  @ApiResponse({
    status: 200,
    description: 'Skills grouped by category with tech stack',
    type: SkillsListResponseDto,
  })
  async findByLanguage(
    @Param('languageCode') languageCode: string,
  ): Promise<SkillsListResponseDto> {
    return this.skillsService.findByLanguage(languageCode);
  }

  @Get()
  @ApiOperation({ summary: 'Get all skills' })
  @ApiQuery({ name: 'languageId', required: false, type: Number })
  @ApiResponse({ status: 200, description: 'List of all skills' })
  async findAll(@Query('languageId') languageId?: number): Promise<Skill[]> {
    return this.skillsService.findAll(languageId);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get skill by ID' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, description: 'Skill details' })
  @ApiResponse({ status: 404, description: 'Skill not found' })
  async findOne(@Param('id', ParseIntPipe) id: number): Promise<Skill> {
    return this.skillsService.findOne(id);
  }

  @Post()
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Create a new skill' })
  @ApiBody({ type: CreateSkillDto })
  @ApiResponse({ status: 201, description: 'Skill created successfully' })
  async create(@Body() createSkillDto: CreateSkillDto): Promise<Skill> {
    return this.skillsService.create(createSkillDto);
  }

  @Patch(':id')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Update a skill' })
  @ApiParam({ name: 'id', type: Number })
  @ApiBody({ type: UpdateSkillDto })
  @ApiResponse({ status: 200, description: 'Skill updated successfully' })
  @ApiResponse({ status: 404, description: 'Skill not found' })
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updateSkillDto: UpdateSkillDto,
  ): Promise<Skill> {
    return this.skillsService.update(id, updateSkillDto);
  }

  @Delete(':id')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Delete a skill' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 204, description: 'Skill deleted successfully' })
  @ApiResponse({ status: 404, description: 'Skill not found' })
  async remove(@Param('id', ParseIntPipe) id: number): Promise<void> {
    return this.skillsService.remove(id);
  }

  // Tech Stack endpoints
  @Get('tech-stack/all')
  @ApiOperation({ summary: 'Get all tech stack items' })
  @ApiQuery({ name: 'languageId', required: false, type: Number })
  @ApiResponse({ status: 200, description: 'List of tech stack items' })
  async findAllTechStack(
    @Query('languageId') languageId?: number,
  ): Promise<TechStackItem[]> {
    return this.skillsService.findAllTechStack(languageId);
  }

  @Post('tech-stack')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Create a tech stack item' })
  @ApiBody({ type: CreateTechStackItemDto })
  @ApiResponse({
    status: 201,
    description: 'Tech stack item created successfully',
  })
  async createTechStackItem(
    @Body() dto: CreateTechStackItemDto,
  ): Promise<TechStackItem> {
    return this.skillsService.createTechStackItem(dto);
  }

  @Patch('tech-stack/:id')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Update a tech stack item' })
  @ApiParam({ name: 'id', type: Number })
  @ApiBody({ type: UpdateTechStackItemDto })
  @ApiResponse({
    status: 200,
    description: 'Tech stack item updated successfully',
  })
  async updateTechStackItem(
    @Param('id', ParseIntPipe) id: number,
    @Body() dto: UpdateTechStackItemDto,
  ): Promise<TechStackItem> {
    return this.skillsService.updateTechStackItem(id, dto);
  }

  @Delete('tech-stack/:id')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Delete a tech stack item' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({
    status: 204,
    description: 'Tech stack item deleted successfully',
  })
  async removeTechStackItem(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<void> {
    return this.skillsService.removeTechStackItem(id);
  }
}
