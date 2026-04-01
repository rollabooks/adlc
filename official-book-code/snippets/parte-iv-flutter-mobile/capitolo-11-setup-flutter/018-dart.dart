// Variabili: tipizzazione forte, null safety
String name = 'Notes App';
int? count;         // Nullable
final items = <Note>[];  // Lista tipizzata, final = non riassegnabile

// Funzioni
Future<List<Note>> fetchNotes() async {
  final response = await dio.get('/api/notes');
  return (response.data['data'] as List)
      .map((json) => Note.fromJson(json))
      .toList();
}

// Classi
class Note {
  final String id;
  final String title;
  const Note({required this.id, required this.title});
}

// Widget = funzione che restituisce UI
class MyButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  
  const MyButton({super.key, required this.label, required this.onPressed});
  
  @override
  Widget build(BuildContext context) {
    return FilledButton(onPressed: onPressed, child: Text(label));
  }
}