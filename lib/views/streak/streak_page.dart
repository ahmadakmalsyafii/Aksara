// lib/views/streak/streak_page.dart

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:aksara/services/user_stats_service.dart';

class StreakPage extends StatefulWidget {
  const StreakPage({super.key});

  @override
  State<StreakPage> createState() => _StreakPageState();
}

class _StreakPageState extends State<StreakPage> {
  final StatsService _statsService = StatsService();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;


  final Set<DateTime> _streakHistory = {
    DateTime.utc(2025, 9, 3),
    DateTime.utc(2025, 9, 4),
  };

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Streak Kamu"),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _statsService.getStats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text("Gagal memuat data streak."));
          }

          final stats = snapshot.data!;
          final int streakCount = stats['streak'] ?? 0;
          final int freezeUsed = stats['freezeUsed'] ?? 1; // Ganti dengan data asli
          const int streakGoal = 14;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildInfoCards(streakCount, freezeUsed),
                const SizedBox(height: 20),
                _buildStreakGoalCard(streakCount, streakGoal),
                const SizedBox(height: 20),
                _buildCalendarCard(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCards(int streakCount, int freezeUsed) {
    return Row(
      children: [
        Expanded(
          child: Card(
            color: const Color(0xFF338EC6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            clipBehavior: Clip.antiAlias, // Penting untuk memotong gambar sesuai bentuk kartu
            child: Stack(
              children: [
                // Lapisan Latar Belakang (Gambar)
                Positioned(
                  bottom: -7,
                  right: -6,
                  child: Image.asset(
                    'assets/images/streak_card.png',
                    height: 120,
                  ),
                ),
                // Lapisan Konten
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        streakCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Streak Days",
                        style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 40),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            clipBehavior: Clip.antiAlias, // Penting untuk memotong gambar
            child: Stack(
              children: [

                Positioned(
                  bottom: -6,
                  right: -5,
                  child: Image.asset(
                    'assets/images/freeze_card.png',
                    height: 120,
                  ),
                ),
                // Lapisan Konten
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        freezeUsed.toString(),
                        style: TextStyle(
                          color: Color(0xff338EC6),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Freeze Used",
                        style: TextStyle(color: Color(0xff338EC6), fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 40), // Beri ruang
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStreakGoalCard(int currentStreak, int goal) {
    double progress = currentStreak / goal;
    if (progress > 1.0) progress = 1.0;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Streak Goal", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text("$currentStreak / $goal", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 4),
            Text("${goal - currentStreak} Streak buat goal selanjutnya!", style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 16),
            Stack(
              alignment: Alignment.center,
              children: [
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 12,
                  borderRadius: BorderRadius.circular(10),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(radius: 12, backgroundColor: Colors.orange, child: Text("1", style: TextStyle(color: Colors.white, fontSize: 12))),
                      CircleAvatar(radius: 12, backgroundColor: Colors.grey, child: Icon(Icons.local_fire_department, color: Colors.white, size: 14)),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TableCalendar(
          locale: 'id_ID', // Untuk Bahasa Indonesia
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              final isStreakDay = _streakHistory.any((d) => isSameDay(d, date));
              if (isStreakDay) {
                return const Center(
                  child: Icon(Icons.local_fire_department, color: Colors.orange, size: 30),
                );
              }
              return null;
            },
            defaultBuilder: (context, day, focusedDay) {
              final isStreakDay = _streakHistory.any((d) => isSameDay(d, day));
              if (isStreakDay) {
                return Center(
                  child: Text(
                    '${day.day}',
                    style: const TextStyle(color: Colors.transparent),
                  ),
                );
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}