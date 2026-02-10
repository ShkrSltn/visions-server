import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
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
  ApiBody,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { LanguagesService } from './languages.service';
import { CreateLanguageDto } from './dto/create-language.dto';
import { UpdateLanguageDto } from './dto/update-language.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { Language } from '../../entities/language.entity';

@ApiTags('languages')
@Controller('languages')
export class LanguagesController {
  constructor(private readonly languagesService: LanguagesService) {}

  @Get()
  @ApiOperation({ summary: 'Get all active languages' })
  @ApiResponse({ status: 200, description: 'List of active languages' })
  async findAll(): Promise<Language[]> {
    return this.languagesService.findActive();
  }

  @Get('all')
  @ApiOperation({ summary: 'Get all languages (including inactive)' })
  @ApiResponse({ status: 200, description: 'List of all languages' })
  async findAllIncludingInactive(): Promise<Language[]> {
    return this.languagesService.findAll();
  }

  @Get(':code')
  @ApiOperation({ summary: 'Get language by code' })
  @ApiParam({ name: 'code', type: String, description: 'Language code (e.g. en, ru)' })
  @ApiResponse({ status: 200, description: 'Language details' })
  @ApiResponse({ status: 404, description: 'Language not found' })
  async findByCode(@Param('code') code: string): Promise<Language> {
    return this.languagesService.findByCode(code);
  }

  @Post()
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Create a new language' })
  @ApiBody({ type: CreateLanguageDto })
  @ApiResponse({ status: 201, description: 'Language created successfully' })
  @ApiResponse({ status: 409, description: 'Language code already exists' })
  async create(@Body() createLanguageDto: CreateLanguageDto): Promise<Language> {
    return this.languagesService.create(createLanguageDto);
  }

  @Patch(':id')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Update a language' })
  @ApiParam({ name: 'id', type: Number })
  @ApiBody({ type: UpdateLanguageDto })
  @ApiResponse({ status: 200, description: 'Language updated successfully' })
  @ApiResponse({ status: 404, description: 'Language not found' })
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updateLanguageDto: UpdateLanguageDto,
  ): Promise<Language> {
    return this.languagesService.update(id, updateLanguageDto);
  }

  @Delete(':id')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Delete a language' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 204, description: 'Language deleted successfully' })
  @ApiResponse({ status: 404, description: 'Language not found' })
  async remove(@Param('id', ParseIntPipe) id: number): Promise<void> {
    return this.languagesService.remove(id);
  }
}
