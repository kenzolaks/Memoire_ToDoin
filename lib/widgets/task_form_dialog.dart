
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskFormDialog extends StatefulWidget {
  final String uid;
  final Map<String, dynamic>? existingTask;
  final DateTime? selectedDate;
  final VoidCallback? onSaved;

  const TaskFormDialog({
    super.key,
    required this.uid,
    this.existingTask,
    this.selectedDate,
    this.onSaved,
  });

  @override
  State<TaskFormDialog> createState() => _TaskFormDialogState();
}

class _TaskFormDialogState extends State<TaskFormDialog> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingTask != null) {
      final task = widget.existingTask!;
      _titleController.text = task['title'] ?? '';
      _descController.text = task['desc'] ?? '';
      final ts = task['deadline'] as Timestamp?;
      if (ts != null) {
        final dt = ts.toDate();
        _selectedDate = dt;
        _selectedTime = TimeOfDay.fromDateTime(dt);
      }
    } else if (widget.selectedDate != null) {
      _selectedDate = widget.selectedDate;
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  Future<void> _submit() async {
    if (_titleController.text.trim().isEmpty || _selectedDate == null || _selectedTime == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Judul, tanggal, dan jam wajib diisi!')),
        );
      }
      return;
    }

    setState(() => _isLoading = true);
    final deadline = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final data = {
      'uid': widget.uid,
      'title': _titleController.text.trim(),
      'desc': _descController.text.trim(),
      'deadline': Timestamp.fromDate(deadline),
      'done': widget.existingTask?['done'] ?? false,
      'createdAt': FieldValue.serverTimestamp(),
    };

    try {
      final docRef = FirebaseFirestore.instance.collection('activities');
      if (widget.existingTask != null && widget.existingTask!['id'] != null) {
        await docRef.doc(widget.existingTask!['id']).update(data);
      } else {
        await docRef.add(data);
      }

      if (widget.onSaved != null) widget.onSaved!();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return AlertDialog(
      backgroundColor: theme.scaffoldBackgroundColor,
      title: Text(
        widget.existingTask != null ? 'Edit Tugas' : 'Tambah Tugas',
        style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(style: textTheme.bodyMedium,
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Judul'),
            ),
            const SizedBox(height: 8),
            TextField(style: textTheme.bodyMedium,
              controller: _descController,
              maxLines: 2,
              decoration: InputDecoration(labelText: 'Deskripsi'),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.date_range),
                    label: Text(_selectedDate == null
                        ? 'Pilih Tanggal'
                        : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
                    onPressed: _pickDate,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.access_time),
                    label: Text(_selectedTime == null
                        ? 'Pilih Jam'
                        : _selectedTime!.format(context)),
                    onPressed: _pickTime,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Batal'),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          child: _isLoading
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Simpan'),
        ),
      ],
    );
  }
}
