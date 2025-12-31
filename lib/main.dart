import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frist_flutterapp/providers/diary_provider.dart';
import 'package:frist_flutterapp/screens/entry_screen.dart';

void main() {
  // Garante que os plugins (path_provider) funcionem antes do runApp
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // O ..loadEntries() força o Flutter a ler o JSON do disco na hora que o app abre
      create: (context) => DiaryProvider()..loadEntries(),
      child: MaterialApp(
        title: 'Meu Diário',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // listen: true (padrão) faz a tela atualizar quando você salva uma nota
    final diary = Provider.of<DiaryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Diário'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: diary.entries.isEmpty
          ? const Center(child: Text('Nenhuma nota por aqui.'))
          : ListView.builder(
        itemCount: diary.entries.length,
        itemBuilder: (ctx, i) {
          final item = diary.entries[i];
          return ListTile(
            title: Text(item.title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(item.content,
                maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: Text(item.date.toString().split(' ')[0]),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => EntryScreen(entry: item)),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EntryScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}