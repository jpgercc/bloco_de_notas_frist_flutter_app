import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frist_flutterapp/providers/diary_provider.dart';
import 'package:frist_flutterapp/screens/entries_by_year_screen.dart';
import 'package:frist_flutterapp/screens/entry_screen.dart';
import 'package:frist_flutterapp/screens/search_screen.dart';

class HomeScreenNew extends StatefulWidget {
  const HomeScreenNew({super.key});

  @override
  State<HomeScreenNew> createState() => _HomeScreenNewState();
}

class _HomeScreenNewState extends State<HomeScreenNew> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final diary = Provider.of<DiaryProvider>(context);
    final totalEntries = diary.entries.length;
    final totalWords = diary.entries.fold<int>(
      0,
          (sum, entry) => sum + entry.content.split(' ').length,
    );

    // Agrupa entradas por ano
    final entriesByYear = <int, int>{};
    for (var entry in diary.entries) {
      final year = entry.date.year;
      entriesByYear[year] = (entriesByYear[year] ?? 0) + 1;
    }
    final years = entriesByYear.keys.toList()..sort((a, b) => b.compareTo(a));

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '— DIÁRIO —',
                    style: GoogleFonts.courierPrime(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Modo Claro',
                          style: GoogleFonts.courierPrime(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  _buildTab('Início', 0),
                  const SizedBox(width: 32),
                  _buildTab('Anos', 1),
                  const SizedBox(width: 32),
                  _buildTab('Pesquisar', 2),
                ],
              ),
            ),

            const Divider(color: Colors.grey, height: 1),

            // Content
            Expanded(
              child: _selectedIndex == 0
                  ? _buildHomeContent(totalEntries, totalWords)
                  : _selectedIndex == 1
                  ? _buildYearsContent(years, entriesByYear)
                  : const SearchScreen(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EntryScreen()),
        ),
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.courierPrime(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.white : Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          if (isSelected)
            Container(
              height: 2,
              width: 40,
              color: Colors.white,
            ),
        ],
      ),
    );
  }

  Widget _buildHomeContent(int totalEntries, int totalWords) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Bem-vindo ao seu Diário',
            style: GoogleFonts.courierPrime(
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            'Registre seus pensamentos, ideias e memórias mais preciosas.',
            style: GoogleFonts.courierPrime(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 80),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStat(totalEntries.toString(), 'ENTRADAS'),
              const SizedBox(width: 80),
              _buildStat(totalWords.toString(), 'PALAVRAS'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: GoogleFonts.courierPrime(
            fontSize: 64,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.courierPrime(
            fontSize: 14,
            color: Colors.grey,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildYearsContent(List<int> years, Map<int, int> entriesByYear) {
    if (years.isEmpty) {
      return Center(
        child: Text(
          'Nenhuma entrada ainda.\nComece a escrever!',
          style: GoogleFonts.courierPrime(
            fontSize: 18,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: years.length,
      itemBuilder: (context, index) {
        final year = years[index];
        final count = entriesByYear[year]!;
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EntriesByYearScreen(year: year),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[800]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    year.toString(),
                    style: GoogleFonts.courierPrime(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$count ${count == 1 ? 'entrada' : 'entradas'}',
                    style: GoogleFonts.courierPrime(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}