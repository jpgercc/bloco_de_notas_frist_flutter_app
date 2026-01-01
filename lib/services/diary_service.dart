import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:frist_flutterapp/models/entry.dart';

class DiaryService {
  // Metodo público para ser acessível pelo Provider e DriveService
  Future<File> getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/diary.json');
  }

  Future<List<Entry>> readEntries() async {
    try {
      final file = await getLocalFile(); // Chamada correta com ()
      if (!await file.exists()) return [];

      final contents = await file.readAsString();
      final List<dynamic> jsonList = json.decode(contents);
      return jsonList.map((e) => Entry.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveEntries(List<Entry> entries) async {
    // CORREÇÃO: Usando o novo método público com parênteses e await
    final file = await getLocalFile();

    final jsonString = json.encode(entries.map((e) => e.toJson()).toList());
    await file.writeAsString(jsonString);
  }
}