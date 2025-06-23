import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Project } from '../../entities/project.entity';
import { ProjectTechnology } from '../../entities/project-technology.entity';
import { CreateProjectDto } from './dto/create-project.dto';
import { UpdateProjectDto } from './dto/update-project.dto';
import {
  ProjectResponseDto,
  ProjectsListResponseDto,
} from './dto/project-response.dto';

@Injectable()
export class ProjectsService {
  constructor(
    @InjectRepository(Project)
    private projectRepository: Repository<Project>,
    @InjectRepository(ProjectTechnology)
    private projectTechnologyRepository: Repository<ProjectTechnology>,
  ) {}

  async create(
    createProjectDto: CreateProjectDto,
  ): Promise<ProjectResponseDto> {
    const { technologies, ...projectData } = createProjectDto;

    const project = this.projectRepository.create(projectData);
    const savedProject = await this.projectRepository.save(project);

    // Сохраняем технологии
    const projectTechnologies = technologies.map((tech, index) =>
      this.projectTechnologyRepository.create({
        projectId: savedProject.id,
        technology: tech,
        orderIndex: index,
      }),
    );

    await this.projectTechnologyRepository.save(projectTechnologies);

    return this.findOne(savedProject.id);
  }

  async findAll(languageId?: number): Promise<ProjectResponseDto[]> {
    const queryBuilder = this.projectRepository
      .createQueryBuilder('project')
      .leftJoinAndSelect('project.technologies', 'technologies')
      .orderBy('project.orderIndex', 'ASC')
      .addOrderBy('technologies.orderIndex', 'ASC');

    if (languageId) {
      queryBuilder.where('project.languageId = :languageId', { languageId });
    }

    const projects = await queryBuilder.getMany();

    return projects.map((project) => this.mapToResponseDto(project));
  }

  async findByLanguage(languageCode: string): Promise<ProjectsListResponseDto> {
    const projects = await this.projectRepository
      .createQueryBuilder('project')
      .leftJoinAndSelect('project.language', 'language')
      .leftJoinAndSelect('project.technologies', 'technologies')
      .where('language.code = :languageCode', { languageCode })
      .orderBy('project.orderIndex', 'ASC')
      .addOrderBy('technologies.orderIndex', 'ASC')
      .getMany();

    const featuredProjects = projects.map((project) =>
      this.mapToResponseDto(project),
    );

    return { featuredProjects };
  }

  async findFeatured(languageId?: number): Promise<ProjectResponseDto[]> {
    const queryBuilder = this.projectRepository
      .createQueryBuilder('project')
      .leftJoinAndSelect('project.technologies', 'technologies')
      .where('project.featured = :featured', { featured: true })
      .orderBy('project.orderIndex', 'ASC')
      .addOrderBy('technologies.orderIndex', 'ASC');

    if (languageId) {
      queryBuilder.andWhere('project.languageId = :languageId', { languageId });
    }

    const projects = await queryBuilder.getMany();

    return projects.map((project) => this.mapToResponseDto(project));
  }

  async findOne(id: number): Promise<ProjectResponseDto> {
    const project = await this.projectRepository
      .createQueryBuilder('project')
      .leftJoinAndSelect('project.technologies', 'technologies')
      .where('project.id = :id', { id })
      .orderBy('technologies.orderIndex', 'ASC')
      .getOne();

    if (!project) {
      throw new NotFoundException(`Project with ID ${id} not found`);
    }

    return this.mapToResponseDto(project);
  }

  async update(
    id: number,
    updateProjectDto: UpdateProjectDto,
  ): Promise<ProjectResponseDto> {
    const { technologies, ...projectData } = updateProjectDto;

    const project = await this.projectRepository.findOne({ where: { id } });
    if (!project) {
      throw new NotFoundException(`Project with ID ${id} not found`);
    }

    // Обновляем основные данные проекта
    await this.projectRepository.update(id, projectData);

    // Если переданы технологии, обновляем их
    if (technologies) {
      // Удаляем старые технологии
      await this.projectTechnologyRepository.delete({ projectId: id });

      // Добавляем новые
      const projectTechnologies = technologies.map((tech, index) =>
        this.projectTechnologyRepository.create({
          projectId: id,
          technology: tech,
          orderIndex: index,
        }),
      );

      await this.projectTechnologyRepository.save(projectTechnologies);
    }

    return this.findOne(id);
  }

  async remove(id: number): Promise<void> {
    const project = await this.projectRepository.findOne({ where: { id } });
    if (!project) {
      throw new NotFoundException(`Project with ID ${id} not found`);
    }

    await this.projectRepository.remove(project);
  }

  async toggleFeatured(id: number): Promise<ProjectResponseDto> {
    const project = await this.projectRepository.findOne({ where: { id } });
    if (!project) {
      throw new NotFoundException(`Project with ID ${id} not found`);
    }

    project.featured = !project.featured;
    await this.projectRepository.save(project);

    return this.findOne(id);
  }

  async reorderProjects(
    languageId: number,
    projectIds: number[],
  ): Promise<ProjectResponseDto[]> {
    for (let i = 0; i < projectIds.length; i++) {
      await this.projectRepository.update(
        { id: projectIds[i], languageId },
        { orderIndex: i },
      );
    }

    return this.findAll(languageId);
  }

  private mapToResponseDto(project: Project): ProjectResponseDto {
    return {
      id: project.id,
      languageId: project.languageId,
      title: project.title,
      description: project.description,
      imageUrl: project.imageUrl,
      demoLink: project.demoLink,
      codeLink: project.codeLink,
      featured: project.featured,
      showDemo: project.showDemo,
      showCode: project.showCode,
      orderIndex: project.orderIndex,
      technologies: project.technologies?.map((tech) => tech.technology) || [],
      createdAt: project.createdAt,
      updatedAt: project.updatedAt,
    };
  }
}
