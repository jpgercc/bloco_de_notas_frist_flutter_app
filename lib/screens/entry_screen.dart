import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
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
        SnackBar(
          content: Text(
            'O conteúdo não pode estar vazio!',
            style: GoogleFonts.courierPrime(),
          ),
          backgroundColor: Colors.red[900],
        ),
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          widget.entry == null ? 'Nova Entrada' : 'Editar Entrada',
          style: GoogleFonts.courierPrime(fontSize: 18),
        ),
        actions: [
          if (widget.entry != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: Colors.grey[900],
                    title: Text(
                      'Excluir entrada?',
                      style: GoogleFonts.courierPrime(),
                    ),
                    content: Text(
                      'Esta ação não pode ser desfeita.',
                      style: GoogleFonts.courierPrime(color: Colors.grey),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(
                          'Cancelar',
                          style: GoogleFonts.courierPrime(),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Provider.of<DiaryProvider>(context, listen: false)
                              .delete(widget.entry!.id);
                          Navigator.pop(ctx);
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Excluir',
                          style: GoogleFonts.courierPrime(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _save,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.grey[800],
            height: 1,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Título',
                hintStyle: GoogleFonts.courierPrime(color: Colors.grey),
                border: InputBorder.none,
              ),
              style: GoogleFonts.courierPrime(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              height: 1,
              color: Colors.grey[800],
              margin: const EdgeInsets.symmetric(vertical: 16),
            ),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: 'O que você está pensando?',
                  hintStyle: GoogleFonts.courierPrime(color: Colors.grey),
                  border: InputBorder.none,
                ),
                style: GoogleFonts.courierPrime(
                  fontSize: 16,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}