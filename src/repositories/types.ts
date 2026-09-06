export type Plant = {
  id: string;
  botanical_name?: string;
  cultivar?: string;
  nickname?: string;
  cover_photo_id?: string | null;
  status?: 'healthy'|'attention'|'recovering';
};

export type Event = {
  id: string;
  plant_id: string;
  event_type: string;
  event_date: string;
  notes?: string;
};

export interface PlantsRepository {
  list(): Promise<Plant[]>;
  create(input: Partial<Plant>): Promise<Plant>;
  createEventBatch(plantIds: string[], type: string, notes: string, date: string): Promise<Event[]>;
}
