try {
  final notes = await notesService.getAll();
  state = NotesState.loaded(notes);
} on DioException catch (e) {
  if (e.response?.statusCode == 401) {
    ref.read(authProvider.notifier).logout();
  } else {
    state = NotesState.error(e.message ?? 'Errore sconosciuto');
  }
} catch (e) {
  state = NotesState.error('Errore imprevisto');
}