import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TaskItem extends StatelessWidget {
  final Map<String, dynamic> task;
  final VoidCallback? onEdit;
  final VoidCallback onDelete;
  final Function(bool?) onToggleDone;

  const TaskItem({
    super.key,
    required this.task,
    this.onEdit,
    required this.onDelete,
    required this.onToggleDone,
  });

  @override
  Widget build(BuildContext context) {
    final title = task['title'] ?? '';
    final desc = task['desc'] ?? '';
    final done = task['done'] ?? false;
    final deadline = (task['deadline'] as Timestamp?)?.toDate();
    final deadlineStr = deadline != null
        ? DateFormat('yyyy-MM-dd – HH:mm').format(deadline)
        : null;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? const Color.fromARGB(255, 83, 71, 131)
        : const Color(0xFFE0D7F8); // Light purple for light theme
    final textColor = isDark ? Colors.white : Colors.black;

    final textStyle = TextStyle(
      decoration: done ? TextDecoration.lineThrough : TextDecoration.none,
      color: textColor,
      fontWeight: FontWeight.w600,
      fontSize: 16,
    );

    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: done,
              onChanged: onToggleDone,
              activeColor: Colors.deepPurple,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: textStyle),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  if (deadlineStr != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Tenggat: $deadlineStr',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
                    ),
                  ]
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.orangeAccent),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: onDelete,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
