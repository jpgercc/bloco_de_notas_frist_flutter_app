import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:frist_flutterapp/models/entry.dart';

class DiaryService {
  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/diary.json');
  }

  Future<List<Entry>> readEntries() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) return [];

      final contents = await file.readAsString();
      final List<dynamic> jsonList = json.decode(contents);
      return jsonList.map((e) => Entry.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveEntries(List<Entry> entries) async {
    final file = await _localFile;
    print("Caminho do arquivo: ${file.absolute.path}");
    final jsonString = json.encode(entries.map((e) => e.toJson()).toList());
    await file.writeAsString(jsonString);
  }
}
