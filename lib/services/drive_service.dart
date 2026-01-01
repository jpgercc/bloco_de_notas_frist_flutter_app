import 'dart:io';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

// Crie esta classe pequena para fornecer o AuthClient que a API exige
class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }
}

class DriveService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [drive.DriveApi.driveAppdataScope],
  );

  Future<drive.DriveApi?> _getDriveApi() async {
    final account = await _googleSignIn.signIn();
    if (account == null) return null;

    final authHeaders = await account.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);

    return drive.DriveApi(authenticateClient);
  }

  Future<void> upload(File file) async {
    final api = await _getDriveApi();
    if (api == null) return;

    final media = drive.Media(file.openRead(), file.lengthSync());

    // Busca o arquivo
    final list = await api.files.list(
        q: "name = 'diary.json'",
        spaces: 'appDataFolder'
    );

    if (list.files != null && list.files!.isNotEmpty) {
      // Update
      await api.files.update(
          drive.File(),
          list.files!.first.id!,
          uploadMedia: media
      );
    } else {
      // Create
      final driveFile = drive.File()
        ..name = 'diary.json'
        ..parents = ['appDataFolder'];
      await api.files.create(driveFile, uploadMedia: media);
    }
  }

  Future<void> download(File localFile) async {
    final api = await _getDriveApi();
    if (api == null) return;

    final list = await api.files.list(
        q: "name = 'diary.json'",
        spaces: 'appDataFolder'
    );
    if (list.files == null || list.files!.isEmpty) return;

    final response = await api.files.get(
        list.files!.first.id!,
        downloadOptions: drive.DownloadOptions.fullMedia
    ) as drive.Media;

    final List<int> dataStore = [];
    await for (final data in response.stream) {
      dataStore.addAll(data);
    }
    await localFile.writeAsBytes(dataStore);
  }
}