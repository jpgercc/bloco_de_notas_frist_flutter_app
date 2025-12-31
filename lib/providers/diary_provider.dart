import 'package:flutter/material.dart';
import '../models/entry.dart';
import '../services/diary_service.dart';

class DiaryProvider with ChangeNotifier {
  List<Entry> _entries = [];
  final DiaryService _service = DiaryService();

  List<Entry> get entries => [..._entries];

  Future<void> loadEntries() async {
    _entries = await _service.readEntries();
    notifyListeners();
  }

  Future<void> addOrUpdate(Entry entry) async {
    final index = _entries.indexWhere((e) => e.id == entry.id);
    if (index != -1) {
      _entries[index] = entry;
    } else {
      _entries.insert(0, entry);
    }
    notifyListeners();
    await _service.saveEntries(_entries);
  }

  Future<void> delete(int id) async {
    _entries.removeWhere((e) => e.id == id);
    notifyListeners();
    await _service.saveEntries(_entries);
  }
}