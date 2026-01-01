import 'package:flutter/material.dart';
import '../models/entry.dart';
import '../services/diary_service.dart';
import '../services/drive_service.dart';

class DiaryProvider with ChangeNotifier {
  List<Entry> _entries = [];
  final DiaryService _service = DiaryService();
  final DriveService _drive = DriveService(); // Agora vai encontrar a classe certa

  List<Entry> get entries => [..._entries];

  Future<void> loadEntries() async {
    _entries = await _service.readEntries();
    notifyListeners();
  }

  Future<void> syncFromCloud() async {
    try {
      final file = await _service.getLocalFile();
      await _drive.download(file);
      await loadEntries();
    } catch (e) {
      debugPrint("Erro no sync: $e");
    }
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
    _uploadToCloud();
  }

  Future<void> delete(int id) async {
    _entries.removeWhere((e) => e.id == id);
    notifyListeners();
    await _service.saveEntries(_entries);
    _uploadToCloud();
  }

  Future<void> _uploadToCloud() async {
    try {
      final file = await _service.getLocalFile();
      await _drive.upload(file);
    } catch (e) {
      debugPrint("Erro no upload: $e");
    }
  }
}