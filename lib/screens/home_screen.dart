import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:diary_flutter_app/providers/diary_provider.dart';
import 'package:diary_flutter_app/screens/entries_by_year_screen.dart';
import 'package:diary_flutter_app/screens/entry_screen.dart';
import 'package:diary_flutter_app/screens/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
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
                  const Text(
                    '— DIÁRIO —',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      fontFamily: 'Courier New',
                    ),
                  ),
                  // Indicador discreto de status
                  Selector<DiaryProvider, bool>(
                    selector: (_, diary) => diary.isConfigured,
                    builder: (context, isConfigured, _) {
                      return Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: isConfigured ? Colors.green : Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isConfigured ? 'Sync On' : 'Offline',
                            style: const TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'Courier New'),
                          ),
                        ],
                      );
                    },
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
                  ? const HomeContent()
                  : _selectedIndex == 1
                  ? const YearsContent()
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
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.white : Colors.grey,
              fontFamily: 'Courier New',
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
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Bem-vindo ao seu Diário',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'Courier New',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const Text(
            'O que seria de nós sem nossas memórias? Em Lete, Mnemosine.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontFamily: 'Courier New',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 80),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Selector<DiaryProvider, int>(
                selector: (_, diary) => diary.entries.length,
                builder: (context, count, _) => _buildStat(count.toString(), 'ENTRADAS'),
              ),
              const SizedBox(width: 80),
              Selector<DiaryProvider, int>(
                selector: (_, diary) => diary.totalWords,
                builder: (context, count, _) => _buildStat(count.toString(), 'PALAVRAS'),
              ),
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
          style: const TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.bold,
            fontFamily: 'Courier New',
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            letterSpacing: 2,
            fontFamily: 'Courier New',
          ),
        ),
      ],
    );
  }
}

class YearsContent extends StatelessWidget {
  const YearsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<DiaryProvider, List<int>>(
      selector: (_, diary) => diary.years,
      builder: (context, years, _) {
        if (years.isEmpty) {
          return const Center(
            child: Text(
              'Nenhuma entrada ainda.\nComece a escrever!',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontFamily: 'Courier New',
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
            return Selector<DiaryProvider, int>(
              selector: (_, diary) => diary.entriesByYear[year] ?? 0,
              builder: (context, count, _) {
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
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Courier New',
                            ),
                          ),
                          Text(
                            '$count ${count == 1 ? 'entrada' : 'entradas'}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontFamily: 'Courier New',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            );
          },
        );
      },
    );
  }
}
