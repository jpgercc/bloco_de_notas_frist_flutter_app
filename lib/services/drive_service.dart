import 'dart:io';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';

class DriveService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [drive.DriveApi.driveAppdataScope],
  );

  Future<drive.DriveApi?> _getDriveApi() async {
    final account = await _googleSignIn.signIn();
    return account?.getDriveApi();
  }

  Future<void> upload(File file) async {
    final api = await _getDriveApi();
    if (api == null) return;

    final media = drive.Media(file.openRead(), file.lengthSync());

    // Procura se o arquivo já existe no Drive
    final list = await api.files.list(q: "name = 'diary.json'", spaces: 'appDataFolder');

    if (list.files != null && list.files!.isNotEmpty) {
      // Atualiza existente
      await api.files.update(drive.File(), list.files!.first.id!, uploadMedia: media);
    } else {
      // Cria novo
      final driveFile = drive.File()..name = 'diary.json'..parents = ['appDataFolder'];
      await api.files.create(driveFile, uploadMedia: media);
    }
  }

  Future<void> download(File localFile) async {
    final api = await _getDriveApi();
    if (api == null) return;

    final list = await api.files.list(q: "name = 'diary.json'", spaces: 'appDataFolder');
    if (list.files == null || list.files!.isEmpty) return;

    final driveFile = await api.files.get(list.files!.first.id!, downloadOptions: drive.DownloadOptions.metadata);
    final response = await api.files.get(list.files!.first.id!, downloadOptions: drive.DownloadOptions.fullMedia) as drive.Media;

    final List<int> dataStore = [];
    await response.stream.listen((data) => dataStore.addAll(data)).asFuture();
    await localFile.writeAsBytes(dataStore);
  }
}