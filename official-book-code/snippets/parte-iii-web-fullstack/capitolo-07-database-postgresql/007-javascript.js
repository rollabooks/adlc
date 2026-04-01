// notesService.js - nuova versione
import prisma from '../lib/prisma.js';

export async function getAllNotes() {
  return await prisma.note.findMany({
    orderBy: { createdAt: 'desc' }
  });
}