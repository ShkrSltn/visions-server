import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Enable CORS for admin panel
  const allowedOrigins = [
    'http://localhost:5173',
    'http://127.0.0.1:5173',
    'http://localhost:4200',
  ];

  // Add production origins from env (comma-separated)
  if (process.env.CORS_ORIGINS) {
    allowedOrigins.push(
      ...process.env.CORS_ORIGINS.split(',').map((o) => o.trim()),
    );
  }

  app.enableCors({
    origin: allowedOrigins,
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization'],
    credentials: true,
  });

  // Global validation pipe
  app.useGlobalPipes(
    new ValidationPipe({
      transform: true,
      whitelist: true,
      forbidNonWhitelisted: true,
    }),
  );

  // API prefix
  app.setGlobalPrefix('api');

  // Swagger configuration
  const config = new DocumentBuilder()
    .setTitle('Visions Portfolio API')
    .setDescription(
      'API for managing portfolio data including projects, CV information, and skills',
    )
    .setVersion('1.0')
    .addTag('auth', 'Authentication endpoints')
    .addTag('languages', 'Language management endpoints')
    .addTag('projects', 'Project management endpoints')
    .addTag('skills', 'Skills management endpoints')
    .addTag('cv', 'CV data management endpoints')
    .addTag('translations', 'Translation management endpoints')
    .addTag('app', 'Application health endpoints')
    .addBearerAuth(
      {
        type: 'http',
        scheme: 'bearer',
        bearerFormat: 'JWT',
        name: 'JWT',
        description: 'Enter JWT token',
        in: 'header',
      },
      'JWT-auth', // This name here is important for matching up with @ApiBearerAuth() in your controller!
    )
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api/docs', app, document, {
    customSiteTitle: 'Visions API Documentation',
    customCss: '.swagger-ui .topbar { display: none }',
  });

  const port = process.env.PORT || 3000;
  await app.listen(port);

  console.log(`🚀 Application is running on: http://localhost:${port}`);
  console.log(
    `📚 Swagger documentation available at: http://localhost:${port}/api/docs`,
  );
  console.log(`🎯 API endpoints available at: http://localhost:${port}/api`);
}
bootstrap();
