import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
@Entity('project_technologies')
export class ProjectTechnology {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  projectId: number;

  @ManyToOne('Project', 'technologies', {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'projectId' })
  project: any;

  @Column({ length: 100 })
  technology: string;

  @Column({ default: 0 })
  orderIndex: number;
}
