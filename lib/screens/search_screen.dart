import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:frist_flutterapp/providers/diary_provider.dart';
import 'package:frist_flutterapp/screens/entry_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
      'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final diary = Provider.of<DiaryProvider>(context);
    final filteredEntries = _searchQuery.isEmpty
        ? diary.entries
        : diary.entries.where((entry) {
      final query = _searchQuery.toLowerCase();
      return entry.title.toLowerCase().contains(query) ||
          entry.content.toLowerCase().contains(query);
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: TextField(
            controller: _searchController,
            style: GoogleFonts.courierPrime(fontSize: 16),
            decoration: InputDecoration(
              hintText: 'Pesquisar entradas...',
              hintStyle: GoogleFonts.courierPrime(color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[900],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),
        Expanded(
          child: filteredEntries.isEmpty
              ? Center(
            child: Text(
              _searchQuery.isEmpty
                  ? 'Digite para pesquisar'
                  : 'Nenhuma entrada encontrada',
              style: GoogleFonts.courierPrime(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: filteredEntries.length,
            itemBuilder: (context, index) {
              final entry = filteredEntries[index];
              final dateStr = _formatDate(entry.date);

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EntryScreen(entry: entry),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[800]!),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            if (entry.title.isNotEmpty &&
                                entry.title != 'Sem título')
                              Expanded(
                                child: Text(
                                  entry.title,
                                  style: GoogleFonts.courierPrime(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            Text(
                              dateStr,
                              style: GoogleFonts.courierPrime(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          entry.content,
                          style: GoogleFonts.courierPrime(
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}