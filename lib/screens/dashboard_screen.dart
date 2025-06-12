
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart';
import 'profile_screen.dart';
import '../widgets/task_item.dart';
import '../widgets/task_form_dialog.dart'; 


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  Future<void> _openAddDialog() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await showDialog(
      context: context,
      builder: (context) => TaskFormDialog(
        uid: uid,
        selectedDate: _selectedDay ?? _focusedDay,
        onSaved: () => setState(() {}),
      ),
    );
  }

  Future<void> _openEditDialog(Map<String, dynamic> task) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await showDialog(
      context: context,
      builder: (context) => TaskFormDialog(
        uid: uid,
        existingTask: task,
        onSaved: () => setState(() {}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: isDarkMode ? Colors.amber : Colors.black87,
            ),
            onPressed: () {
              final appState = context.findAncestorStateOfType<MemoireAppState>();
              appState?.toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Profile',
            onPressed: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => const ProfileScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  transitionDuration: const Duration(milliseconds: 500),
                ),
              );
            },
          ),
        ],
      ),
      body: DashboardContent(
        focusedDay: _focusedDay,
        selectedDay: _selectedDay,
        onDaySelected: _onDaySelected,
        onEditTask: _openEditDialog,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class DashboardContent extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final void Function(DateTime, DateTime) onDaySelected;
  final void Function(Map<String, dynamic>) onEditTask;

  const DashboardContent({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
    required this.onEditTask,
  });

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Center(child: Text('User tidak ditemukan'));

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('activities')
          .where('uid', isEqualTo: uid).orderBy('deadline')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final docs = snapshot.data!.docs;
        final tasks = docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {...data, 'id': doc.id};
        }).toList();

        final Map<DateTime, List<Map<String, dynamic>>> events = {};
        for (var task in tasks) {
          final ts = task['deadline'] as Timestamp?;
          if (ts != null) {
            final date = DateTime(ts.toDate().year, ts.toDate().month, ts.toDate().day);
            events.putIfAbsent(date, () => []).add(task);
          }
        }

        final selectedDate = selectedDay ?? focusedDay;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2100, 12, 31),
                  focusedDay: focusedDay,
                  selectedDayPredicate: (day) =>
                      day.year == selectedDate.year &&
                      day.month == selectedDate.month &&
                      day.day == selectedDate.day,
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    markerDecoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  eventLoader: (day) {
                    final d = DateTime(day.year, day.month, day.day);
                    return events[d] ?? [];
                  },
                  onDaySelected: onDaySelected,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Semua Tugas",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (tasks.isEmpty)
              const Center(child: Text('Belum ada tugas apapun.')),
            ...tasks.map((task) => TaskItem(
                  task: task,
                  onToggleDone: (val) async {
                    await FirebaseFirestore.instance
                        .collection('activities')
                        .doc(task['id'])
                        .update({'done': val});
                  },
                  onEdit: () => onEditTask(task),
                  onDelete: () async {
                    await FirebaseFirestore.instance
                        .collection('activities')
                        .doc(task['id'])
                        .delete();
                  },
                )),
          ],
        );
      },
    );
  }
}
