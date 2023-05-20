import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTextFormField extends StatefulWidget {
  const DateTextFormField({
    super.key,
    required this.dateController,
  });

  final TextEditingController dateController;

  @override
  State<DateTextFormField> createState() => _DateTextFormFieldState();
}

class _DateTextFormFieldState extends State<DateTextFormField> {
  Future<void> _onTap() async {
    DateTime date;
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));
    if (pickedDate != null) {
      if (context.mounted) {
        TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: const TimeOfDay(hour: 00, minute: 00));
        if (pickedTime != null) {
          date = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          setState(() {
            widget.dateController.text =
                DateFormat('dd.MM.yyyy HH:mm').format(date);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.dateController,
      readOnly: true,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.date_range_outlined),
        hintText: 'Tarih',
        labelText: 'Tarih',
      ),
      onTap: _onTap,
    );
  }
}
