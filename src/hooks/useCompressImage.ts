import { useState } from 'react';

export function useCompressImage(){
  const [busy, setBusy] = useState(false);
  async function compress(uri: string){
    setBusy(true);
    // placeholder for expo-image-manipulator usage
    await new Promise(r=>setTimeout(r,300));
    setBusy(false);
    return uri;
  }
  return { compress, busy };
}
