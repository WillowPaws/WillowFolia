import { PlantsRepository, Plant, Event } from './types';

const MOCK_PLANTS: Plant[] = [
  { id: '1', botanical_name: 'Monstera deliciosa', nickname: 'Monstera', status: 'healthy' },
  { id: '2', botanical_name: 'Alocasia zebrina', nickname: 'Zebra', status: 'attention' }
];

export const mockPlantsRepository: PlantsRepository = {
  async list(){
    return MOCK_PLANTS;
  },
  async create(input){
    const p: Plant = { id: String(Date.now()), ...input } as Plant;
    MOCK_PLANTS.push(p);
    return p;
  },
  async createEventBatch(plantIds, type, notes, date){
    const events: Event[] = plantIds.map(pid => ({ id: String(Date.now()) + pid, plant_id: pid, event_type: type, event_date: date, notes }));
    return events;
  }
}
