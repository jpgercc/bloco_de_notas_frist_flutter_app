import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:frist_flutterapp/providers/diary_provider.dart';
import 'package:frist_flutterapp/screens/entry_screen.dart';

class EntriesByYearScreen extends StatelessWidget {
  final int year;

  const EntriesByYearScreen({super.key, required this.year});

  String _getMonthName(int month) {
    const months = [
      'JANEIRO', 'FEVEREIRO', 'MARÇO', 'ABRIL', 'MAIO', 'JUNHO',
      'JULHO', 'AGOSTO', 'SETEMBRO', 'OUTUBRO', 'NOVEMBRO', 'DEZEMBRO'
    ];
    return months[month - 1];
  }

  String _getWeekday(int weekday) {
    const weekdays = ['SEG', 'TER', 'QUA', 'QUI', 'SEX', 'SÁB', 'DOM'];
    return weekdays[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final diary = Provider.of<DiaryProvider>(context);
    final entriesInYear = diary.entries
        .where((entry) => entry.date.year == year)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    // Agrupa por mês
    final entriesByMonth = <int, List>{};
    for (var entry in entriesInYear) {
      final month = entry.date.month;
      entriesByMonth.putIfAbsent(month, () => []).add(entry);
    }
    final months = entriesByMonth.keys.toList()..sort((a, b) => b.compareTo(a));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          year.toString(),
          style: GoogleFonts.courierPrime(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.grey[800],
            height: 1,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: months.length,
        itemBuilder: (context, index) {
          final month = months[index];
          final entries = entriesByMonth[month]!;
          final monthName = _getMonthName(month);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16, top: 16),
                child: Text(
                  monthName,
                  style: GoogleFonts.courierPrime(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.grey,
                  ),
                ),
              ),
              ...entries.map((entry) {
                final day = entry.date.day.toString();
                final weekday = _getWeekday(entry.date.weekday);

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
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 60,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  day,
                                  style: GoogleFonts.courierPrime(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  weekday,
                                  style: GoogleFonts.courierPrime(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (entry.title.isNotEmpty && entry.title != 'Sem título')
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
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
                                  entry.content,
                                  style: GoogleFonts.courierPrime(
                                    fontSize: 14,
                                    color: Colors.grey[400],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }
}