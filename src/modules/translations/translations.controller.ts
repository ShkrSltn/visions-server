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
import { TranslationsService } from './translations.service';
import { CreateTranslationDto } from './dto/create-translation.dto';
import { UpdateTranslationDto } from './dto/update-translation.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@ApiTags('translations')
@Controller('translations')
export class TranslationsController {
  constructor(private readonly translationsService: TranslationsService) {}

  /**
   * Public endpoint for ngx-translate.
   * Returns nested JSON: { HEADER: { HOME: "Home", ... }, ... }
   */
  @Get(':code')
  @ApiOperation({ summary: 'Get all translations for a language (nested JSON for ngx-translate)' })
  @ApiParam({ name: 'code', type: String, description: 'Language code (en, ru, de...)' })
  @ApiResponse({ status: 200, description: 'Nested JSON translations object' })
  async getByLanguage(
    @Param('code') code: string,
  ): Promise<Record<string, any>> {
    return this.translationsService.getNestedByLanguage(code);
  }

  /**
   * Admin endpoint: flat list of translations for a language.
   */
  @Get('admin/:code')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Get flat list of translations for admin panel' })
  @ApiParam({ name: 'code', type: String })
  @ApiResponse({ status: 200, description: 'Flat list of translation records' })
  async getAdminByLanguage(@Param('code') code: string) {
    return this.translationsService.getFlatByLanguage(code);
  }

  /**
   * Admin endpoint: list of unique namespaces for a language.
   */
  @Get('admin/:code/namespaces')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Get unique namespaces for a language' })
  @ApiParam({ name: 'code', type: String })
  async getNamespaces(@Param('code') code: string) {
    return this.translationsService.getNamespaces(code);
  }

  @Post()
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Create a translation' })
  @ApiBody({ type: CreateTranslationDto })
  @ApiResponse({ status: 201, description: 'Translation created' })
  async create(@Body() dto: CreateTranslationDto) {
    return this.translationsService.create(dto);
  }

  @Patch(':id')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Update a translation' })
  @ApiParam({ name: 'id', type: Number })
  @ApiBody({ type: UpdateTranslationDto })
  @ApiResponse({ status: 200, description: 'Translation updated' })
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() dto: UpdateTranslationDto,
  ) {
    return this.translationsService.update(id, dto);
  }

  @Delete(':id')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Delete a translation' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 204, description: 'Translation deleted' })
  async remove(@Param('id', ParseIntPipe) id: number) {
    return this.translationsService.remove(id);
  }

  /**
   * Import a full JSON translations file for a language.
   * Flattens and upserts all key-value pairs.
   */
  @Post('import/:code')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Import translations JSON for a language' })
  @ApiParam({ name: 'code', type: String })
  @ApiResponse({ status: 200, description: 'Import result with counts' })
  async importJson(
    @Param('code') code: string,
    @Body() json: Record<string, any>,
  ) {
    return this.translationsService.importJson(code, json);
  }
}
