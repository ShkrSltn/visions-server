import {
  Controller,
  Get,
  Post,
  Put,
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
import { CvService } from './cv.service';
import { CvDataResponseDto } from './dto/cv-response.dto';
import {
  UpsertCvProfileDto,
  CreateCvSkillDto,
  CreateWorkExperienceDto,
  CreateEducationDto,
  CreateCertificationDto,
  CreateCvLanguageDto,
  CreateReferenceDto,
  CreateHobbyDto,
  UpsertContactInfoDto,
} from './dto/create-cv.dto';
import {
  UpdateCvSkillDto,
  UpdateWorkExperienceDto,
  UpdateEducationDto,
  UpdateCertificationDto,
  UpdateCvLanguageDto,
  UpdateReferenceDto,
  UpdateHobbyDto,
} from './dto/update-cv.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@ApiTags('cv')
@Controller('cv')
export class CvController {
  constructor(private readonly cvService: CvService) {}

  // ========== Main endpoint (Angular-compatible) ==========

  @Get('by-language/:languageCode')
  @ApiOperation({
    summary: 'Get full CV data by language code (Angular-compatible format)',
  })
  @ApiParam({
    name: 'languageCode',
    type: String,
    description: 'Language code (en, ru, de, tr, ua)',
  })
  @ApiResponse({
    status: 200,
    description: 'Full CV data',
    type: CvDataResponseDto,
  })
  async findByLanguage(
    @Param('languageCode') languageCode: string,
  ): Promise<CvDataResponseDto> {
    return this.cvService.findByLanguage(languageCode);
  }

  // ========== Profile ==========

  @Put('profile/:languageId')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Upsert CV profile for a language' })
  @ApiParam({ name: 'languageId', type: Number })
  @ApiBody({ type: UpsertCvProfileDto })
  @ApiResponse({ status: 200, description: 'Profile upserted successfully' })
  async upsertProfile(
    @Param('languageId', ParseIntPipe) languageId: number,
    @Body() dto: UpsertCvProfileDto,
  ) {
    return this.cvService.upsertProfile(languageId, dto);
  }

  // ========== CV Skills ==========

  @Post('skill')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Create a CV skill entry' })
  @ApiBody({ type: CreateCvSkillDto })
  @ApiResponse({ status: 201, description: 'CV skill created' })
  async createCvSkill(@Body() dto: CreateCvSkillDto) {
    return this.cvService.createCvSkill(dto);
  }

  @Patch('skill/:id')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Update a CV skill entry' })
  @ApiParam({ name: 'id', type: Number })
  @ApiBody({ type: UpdateCvSkillDto })
  async updateCvSkill(
    @Param('id', ParseIntPipe) id: number,
    @Body() dto: UpdateCvSkillDto,
  ) {
    return this.cvService.updateCvSkill(id, dto);
  }

  @Delete('skill/:id')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Delete a CV skill entry' })
  @ApiParam({ name: 'id', type: Number })
  async removeCvSkill(@Param('id', ParseIntPipe) id: number) {
    return this.cvService.removeCvSkill(id);
  }

  // ========== Work Experience ==========

  @Post('work-experience')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Create a work experience entry' })
  @ApiBody({ type: CreateWorkExperienceDto })
  @ApiResponse({ status: 201, description: 'Work experience created' })
  async createWorkExperience(@Body() dto: CreateWorkExperienceDto) {
    return this.cvService.createWorkExperience(dto);
  }

  @Patch('work-experience/:id')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Update a work experience entry' })
  @ApiParam({ name: 'id', type: Number })
  @ApiBody({ type: UpdateWorkExperienceDto })
  async updateWorkExperience(
    @Param('id', ParseIntPipe) id: number,
    @Body() dto: UpdateWorkExperienceDto,
  ) {
    return this.cvService.updateWorkExperience(id, dto);
  }

  @Delete('work-experience/:id')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Delete a work experience entry' })
  @ApiParam({ name: 'id', type: Number })
  async removeWorkExperience(@Param('id', ParseIntPipe) id: number) {
    return this.cvService.removeWorkExperience(id);
  }

  // ========== Education ==========

  @Post('education')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Create an education entry' })
  @ApiBody({ type: CreateEducationDto })
  @ApiResponse({ status: 201, description: 'Education entry created' })
  async createEducation(@Body() dto: CreateEducationDto) {
    return this.cvService.createEducation(dto);
  }

  @Patch('education/:id')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Update an education entry' })
  @ApiParam({ name: 'id', type: Number })
  @ApiBody({ type: UpdateEducationDto })
  async updateEducation(
    @Param('id', ParseIntPipe) id: number,
    @Body() dto: UpdateEducationDto,
  ) {
    return this.cvService.updateEducation(id, dto);
  }

  @Delete('education/:id')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Delete an education entry' })
  @ApiParam({ name: 'id', type: Number })
  async removeEducation(@Param('id', ParseIntPipe) id: number) {
    return this.cvService.removeEducation(id);
  }

  // ========== Certifications ==========

  @Post('certification')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Create a certification entry' })
  @ApiBody({ type: CreateCertificationDto })
  @ApiResponse({ status: 201, description: 'Certification created' })
  async createCertification(@Body() dto: CreateCertificationDto) {
    return this.cvService.createCertification(dto);
  }

  @Patch('certification/:id')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Update a certification entry' })
  @ApiParam({ name: 'id', type: Number })
  @ApiBody({ type: UpdateCertificationDto })
  async updateCertification(
    @Param('id', ParseIntPipe) id: number,
    @Body() dto: UpdateCertificationDto,
  ) {
    return this.cvService.updateCertification(id, dto);
  }

  @Delete('certification/:id')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Delete a certification entry' })
  @ApiParam({ name: 'id', type: Number })
  async removeCertification(@Param('id', ParseIntPipe) id: number) {
    return this.cvService.removeCertification(id);
  }

  // ========== CV Languages (spoken) ==========

  @Post('language')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Create a CV language entry (spoken language)' })
  @ApiBody({ type: CreateCvLanguageDto })
  @ApiResponse({ status: 201, description: 'CV language created' })
  async createCvLanguage(@Body() dto: CreateCvLanguageDto) {
    return this.cvService.createCvLanguage(dto);
  }

  @Patch('language/:id')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Update a CV language entry' })
  @ApiParam({ name: 'id', type: Number })
  @ApiBody({ type: UpdateCvLanguageDto })
  async updateCvLanguage(
    @Param('id', ParseIntPipe) id: number,
    @Body() dto: UpdateCvLanguageDto,
  ) {
    return this.cvService.updateCvLanguage(id, dto);
  }

  @Delete('language/:id')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Delete a CV language entry' })
  @ApiParam({ name: 'id', type: Number })
  async removeCvLanguage(@Param('id', ParseIntPipe) id: number) {
    return this.cvService.removeCvLanguage(id);
  }

  // ========== References ==========

  @Post('reference')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Create a reference entry' })
  @ApiBody({ type: CreateReferenceDto })
  @ApiResponse({ status: 201, description: 'Reference created' })
  async createReference(@Body() dto: CreateReferenceDto) {
    return this.cvService.createReference(dto);
  }

  @Patch('reference/:id')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Update a reference entry' })
  @ApiParam({ name: 'id', type: Number })
  @ApiBody({ type: UpdateReferenceDto })
  async updateReference(
    @Param('id', ParseIntPipe) id: number,
    @Body() dto: UpdateReferenceDto,
  ) {
    return this.cvService.updateReference(id, dto);
  }

  @Delete('reference/:id')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Delete a reference entry' })
  @ApiParam({ name: 'id', type: Number })
  async removeReference(@Param('id', ParseIntPipe) id: number) {
    return this.cvService.removeReference(id);
  }

  // ========== Hobbies ==========

  @Post('hobby')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Create a hobby entry' })
  @ApiBody({ type: CreateHobbyDto })
  @ApiResponse({ status: 201, description: 'Hobby created' })
  async createHobby(@Body() dto: CreateHobbyDto) {
    return this.cvService.createHobby(dto);
  }

  @Patch('hobby/:id')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Update a hobby entry' })
  @ApiParam({ name: 'id', type: Number })
  @ApiBody({ type: UpdateHobbyDto })
  async updateHobby(
    @Param('id', ParseIntPipe) id: number,
    @Body() dto: UpdateHobbyDto,
  ) {
    return this.cvService.updateHobby(id, dto);
  }

  @Delete('hobby/:id')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Delete a hobby entry' })
  @ApiParam({ name: 'id', type: Number })
  async removeHobby(@Param('id', ParseIntPipe) id: number) {
    return this.cvService.removeHobby(id);
  }

  // ========== Contact Info ==========

  @Put('contact/:languageId')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Upsert contact info for a language' })
  @ApiParam({ name: 'languageId', type: Number })
  @ApiBody({ type: UpsertContactInfoDto })
  @ApiResponse({
    status: 200,
    description: 'Contact info upserted successfully',
  })
  async upsertContactInfo(
    @Param('languageId', ParseIntPipe) languageId: number,
    @Body() dto: UpsertContactInfoDto,
  ) {
    return this.cvService.upsertContactInfo(languageId, dto);
  }
}
