import { IsString, IsBoolean, IsOptional, IsNotEmpty, MaxLength } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateLanguageDto {
  @ApiProperty({ description: 'Language code (e.g. en, ru, de)', maxLength: 5 })
  @IsString()
  @IsNotEmpty()
  @MaxLength(5)
  code: string;

  @ApiProperty({ description: 'Language name (e.g. English, Russian)', maxLength: 50 })
  @IsString()
  @IsNotEmpty()
  @MaxLength(50)
  name: string;

  @ApiPropertyOptional({ description: 'Is language active', default: true })
  @IsOptional()
  @IsBoolean()
  isActive?: boolean;

  @ApiPropertyOptional({ description: 'Is default language', default: false })
  @IsOptional()
  @IsBoolean()
  isDefault?: boolean;
}
