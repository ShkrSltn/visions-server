import {
  Controller,
  Get,
  Post,
  Put,
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
  ApiBearerAuth,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { BlogService } from './blog.service';
import { CreateBlogPostDto } from './dto/create-blog-post.dto';
import { UpdateBlogPostDto } from './dto/update-blog-post.dto';
import { SaveTranslationDto } from './dto/save-translation.dto';
import {
  BlogPostResponseDto,
  BlogPostListItemDto,
} from './dto/blog-response.dto';

@ApiTags('blog')
@Controller('blog')
export class BlogController {
  constructor(private readonly blogService: BlogService) {}

  // ─── Public endpoints ───

  @Get()
  @ApiOperation({ summary: 'Get published blog posts for a language' })
  @ApiQuery({ name: 'lang', required: true, type: String, description: 'Language code (en, ru, etc.)' })
  @ApiResponse({ status: 200, type: [BlogPostListItemDto] })
  async findPublished(
    @Query('lang') lang: string,
  ): Promise<BlogPostListItemDto[]> {
    return this.blogService.findPublished(lang || 'en');
  }

  @Get('post/:slug')
  @ApiOperation({ summary: 'Get a published blog post by slug' })
  @ApiParam({ name: 'slug', type: String })
  @ApiQuery({ name: 'lang', required: true, type: String })
  @ApiResponse({ status: 200, type: BlogPostResponseDto })
  async findBySlug(
    @Param('slug') slug: string,
    @Query('lang') lang: string,
  ): Promise<BlogPostResponseDto | null> {
    return this.blogService.findBySlug(slug, lang || 'en');
  }

  // ─── Admin endpoints ───

  @Get('admin/all')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Get all blog posts (admin)' })
  @ApiResponse({ status: 200, type: [BlogPostResponseDto] })
  async findAllAdmin(): Promise<BlogPostResponseDto[]> {
    return this.blogService.findAllAdmin();
  }

  @Get('admin/by-slug/:slug')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Get blog post by slug with all translations and blocks (admin)' })
  @ApiParam({ name: 'slug', type: String })
  @ApiResponse({ status: 200, type: BlogPostResponseDto })
  async findOneAdminBySlug(
    @Param('slug') slug: string,
  ): Promise<BlogPostResponseDto> {
    return this.blogService.findOneAdminBySlug(slug);
  }

  @Get('admin/:id')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Get blog post by ID with all translations and blocks (admin)' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, type: BlogPostResponseDto })
  async findOneAdmin(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<BlogPostResponseDto> {
    return this.blogService.findOneAdmin(id);
  }

  @Post('admin')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Create a new blog post' })
  @ApiResponse({ status: 201, type: BlogPostResponseDto })
  async create(
    @Body() dto: CreateBlogPostDto,
  ): Promise<BlogPostResponseDto> {
    return this.blogService.create(dto);
  }

  @Patch('admin/:id')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Update blog post metadata' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, type: BlogPostResponseDto })
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() dto: UpdateBlogPostDto,
  ): Promise<BlogPostResponseDto> {
    return this.blogService.update(id, dto);
  }

  @Delete('admin/:id')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Delete a blog post' })
  @ApiParam({ name: 'id', type: Number })
  async remove(@Param('id', ParseIntPipe) id: number): Promise<void> {
    return this.blogService.remove(id);
  }

  @Patch('admin/:id/publish')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Toggle publish status' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, type: BlogPostResponseDto })
  async togglePublish(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<BlogPostResponseDto> {
    return this.blogService.togglePublish(id);
  }

  @Put('admin/:id/translations/:langId')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Save translation + blocks for a language' })
  @ApiParam({ name: 'id', type: Number })
  @ApiParam({ name: 'langId', type: Number })
  @ApiResponse({ status: 200, type: BlogPostResponseDto })
  async saveTranslation(
    @Param('id', ParseIntPipe) id: number,
    @Param('langId', ParseIntPipe) langId: number,
    @Body() dto: SaveTranslationDto,
  ): Promise<BlogPostResponseDto> {
    return this.blogService.saveTranslation(id, langId, dto);
  }

  @Delete('admin/:id/translations/:langId')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Delete a translation for a language' })
  @ApiParam({ name: 'id', type: Number })
  @ApiParam({ name: 'langId', type: Number })
  async deleteTranslation(
    @Param('id', ParseIntPipe) id: number,
    @Param('langId', ParseIntPipe) langId: number,
  ): Promise<void> {
    await this.blogService.deleteTranslation(id, langId);
  }
}
