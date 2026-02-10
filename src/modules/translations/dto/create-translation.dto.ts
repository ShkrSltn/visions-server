import { IsString, IsNotEmpty, MaxLength } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateTranslationDto {
  @ApiProperty({ description: 'Language code', example: 'en', maxLength: 5 })
  @IsString()
  @IsNotEmpty()
  @MaxLength(5)
  languageCode: string;

  @ApiProperty({
    description: 'Namespace / section path',
    example: 'CONTACT.MESSAGE',
    maxLength: 150,
  })
  @IsString()
  @IsNotEmpty()
  @MaxLength(150)
  namespace: string;

  @ApiProperty({
    description: 'Translation key within namespace',
    example: 'NAME_REQUIRED',
    maxLength: 150,
  })
  @IsString()
  @IsNotEmpty()
  @MaxLength(150)
  key: string;

  @ApiProperty({
    description: 'Translated text value',
    example: 'Name is required',
  })
  @IsString()
  @IsNotEmpty()
  value: string;
}
