import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frist_flutterapp/providers/diary_provider.dart';
import 'package:frist_flutterapp/screens/home_screen_new.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DiaryProvider()..loadEntries(),
      child: MaterialApp(
        title: 'Meu Diário',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          colorScheme: ColorScheme.dark(
            primary: Colors.white,
            secondary: Colors.grey[800]!,
            surface: Colors.black,
          ),
          textTheme: GoogleFonts.courierPrimeTextTheme(
            ThemeData.dark().textTheme,
          ),
          useMaterial3: true,
        ),
        home: const HomeScreenNew(),
      ),
    );
  }
}