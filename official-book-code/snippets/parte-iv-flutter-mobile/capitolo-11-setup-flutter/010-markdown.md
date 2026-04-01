---
name: flutter-mobile-developer
description: Skill per lo sviluppo di app mobile Flutter con Material
  Design 3, Riverpod e Dio.
---

# Flutter Mobile Developer Skill

## Struttura Widget

Un widget Flutter segue questo pattern:

```dart
class NoteCard extends ConsumerWidget {
  final Note note;
  final VoidCallback? onTap;

  const NoteCard({
    super.key,
    required this.note,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        title: Text(note.title),
        subtitle: Text(note.content, maxLines: 2),
        onTap: onTap,
      ),
    );
  }
}