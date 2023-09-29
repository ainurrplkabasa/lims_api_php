import 'package:flutter/material.dart';

class DateInput extends StatefulWidget {
  final DateTime? initial;
  final TextEditingController controller;
  final String hint;

  const DateInput({
    super.key,
    this.initial,
    required this.controller,
    required this.hint,
  });

  @override
  _DateInputState createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: widget.controller,
        readOnly: true,
        onTap: () {
          _selectDate(context);
        },
        decoration: InputDecoration(
          labelText: widget.hint,
          hintText: widget.hint,
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.initial ?? DateTime.now(),
      firstDate: widget.initial ?? DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        widget.controller.text =
            "${(selectedDate ?? DateTime.now()).toLocal()}".split(' ')[0];
      });
    }
  }
}
