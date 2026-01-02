import 'package:flutter/material.dart';
import '../models/entry.dart';
import '../services/diary_service.dart';
import 'package:flutter/foundation.dart'; // Necessário para debugPrint

class DiaryProvider with ChangeNotifier {
  late final DiaryService _diaryService;
  List<Entry> _entries = [];
  bool _isLoading = false;
  bool _isConfigured = false;
  bool _isInitialized = false;

  // Cache para estatísticas
  int _totalWords = 0;
  Map<int, int> _entriesByYear = {};
  List<int> _years = [];

  List<Entry> get entries => _entries;
  bool get isLoading => _isLoading;
  bool get isConfigured => _isConfigured;
  bool get isInitialized => _isInitialized;
  
  // Getters para estatísticas
  int get totalWords => _totalWords;
  Map<int, int> get entriesByYear => _entriesByYear;
  List<int> get years => _years;

  DiaryProvider() {
    _diaryService = DiaryService();
    _init();
  }

  Future<void> _init() async {
    _setLoading(true);
    _isConfigured = await _diaryService.isCloudConfigured();
    
    // 1. Carrega o que tem no celular
    await _loadEntries(); 

    // 2. CORREÇÃO CRITICA:
    // Se o celular estiver vazio (instalacaoo nova) E tivermos nuvem configurada,
    // OBRIGA a esperar o download da nuvem antes de iniciar.
    if (_entries.isEmpty && _isConfigured) {
      debugPrint("Cache vazio. Forçando download da nuvem antes de iniciar...");
       await syncCloud();
    } else if (_isConfigured) {
       // Se já tem dados locais, inicia rápido e atualiza em background
      debugPrint("Cache encontrado. Iniciando e sincronizando em background...");
       syncCloud();
    }

    _isInitialized = true;
    _setLoading(false);
  }

  Future<void> _loadEntries() async {
    _entries = await _diaryService.loadEntries();
    _sortEntries();
    _calculateStats();
    notifyListeners();
  }

  Future<void> syncCloud() async {
    try {
      // Sincroniza e atualiza a lista
      await _diaryService.sync();
      // Recarrega do disco para a memória
      await _loadEntries(); 
    } catch (e) {
      debugPrint("Erro no sync: $e");
    }
  }

  Future<void> addOrUpdate(Entry entry) async {
    final index = _entries.indexWhere((e) => e.id == entry.id);
    if (index >= 0) {
      _entries[index] = entry;
    } else {
      _entries.add(entry);
    }
    
    _sortEntries();
    _calculateStats();
    notifyListeners();
    
    await _diaryService.saveEntries(_entries);
  }

  Future<void> delete(int id) async {
    _entries.removeWhere((e) => e.id == id);
    _calculateStats();
    notifyListeners();
    await _diaryService.saveEntries(_entries);
  }
  
  void _sortEntries() {
    _entries.sort((a, b) {
      final dateCompare = b.date.compareTo(a.date);
      if (dateCompare != 0) return dateCompare;
      return b.id.compareTo(a.id);
    });
  }

  void _calculateStats() {
    _totalWords = _entries.fold<int>(
      0,
      (sum, entry) => sum + (entry.content.trim().isEmpty ? 0 : entry.content.trim().split(RegExp(r'\s+')).length),
    );

    _entriesByYear = {};
    for (var entry in _entries) {
      final year = entry.date.year;
      _entriesByYear[year] = (_entriesByYear[year] ?? 0) + 1;
    }
    _years = _entriesByYear.keys.toList()..sort((a, b) => b.compareTo(a));
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
