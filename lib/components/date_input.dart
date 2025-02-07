import 'package:bnbscout24/components/custom_text_input.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting dates

class DateInput extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final Function(DateTime)? onDateSelected;

  const DateInput({
    super.key,
    this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.onDateSelected,
  });

  @override
  _DateInputState createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  final TextEditingController _controller = TextEditingController();

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.initialDate ?? DateTime.now(),
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );

    if (pickedDate != null) {
      setState(() {
        _controller.text = DateFormat.yMMMd().format(pickedDate);
      });

      if (widget.onDateSelected != null) {
        widget.onDateSelected!(pickedDate);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.initialDate != null) {
      _controller.text = DateFormat.yMMMd().format(widget.initialDate!);
    }

    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer( // Prevents manual typing
        child: CustomTextInput(
          hint: "Date",
          controller: _controller,
          suffixIcon: Icon(Icons.calendar_today),
          readOnly: true, // Ensures the user cannot type into the field
        ),
      ),
    );
  }
}