import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frist_flutterapp/models/entry.dart';
import 'package:frist_flutterapp/providers/diary_provider.dart';

class EntryScreen extends StatefulWidget {
  final Entry? entry;
  const EntryScreen({super.key, this.entry});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.entry?.title ?? '');
    _contentController = TextEditingController(text: widget.entry?.content ?? '');
  }

  void _save() {
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O conteúdo não pode estar vazio!')),
      );
      return;
    }

    final diaryProvider = Provider.of<DiaryProvider>(context, listen: false);

    final newEntry = Entry(
      id: widget.entry?.id ?? DateTime.now().millisecondsSinceEpoch,
      title: _titleController.text.isEmpty ? 'Sem título' : _titleController.text,
      content: _contentController.text,
      date: widget.entry?.date ?? DateTime.now(),
    );

    diaryProvider.addOrUpdate(newEntry);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entry == null ? 'Nova Nota' : 'Editar'),
        actions: [
          if (widget.entry != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                Provider.of<DiaryProvider>(context, listen: false).delete(widget.entry!.id);
                Navigator.pop(context);
              },
            ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _save,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Título',
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'O que você está pensando?',
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}