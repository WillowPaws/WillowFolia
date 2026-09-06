// supabasePlantsRepository.ts
// Placeholder implementation — requires SUPABASE client setup
import { PlantsRepository, Plant, Event } from './types';
import { createClient } from '@supabase/supabase-js';

const url = process.env.SUPABASE_URL || '';
const key = process.env.SUPABASE_ANON_KEY || '';
const supabase = createClient(url, key);

export const supabasePlantsRepository: PlantsRepository = {
  async list(){
    const { data, error } = await supabase.from('plants').select('*').eq('archived', false);
    if(error) throw error;
    return (data || []) as Plant[];
  },
  async create(input){
    const { data, error } = await supabase.from('plants').insert([input]).select().single();
    if(error) throw error;
    return data as Plant;
  },
  async createEventBatch(plantIds, type, notes, date){
    const { data, error } = await supabase.rpc('create_events_batch', { p_plant_ids: plantIds, p_event_type: type, p_notes: notes, p_event_date: date });
    if(error) throw error;
    return (data || []) as Event[];
  }
}
