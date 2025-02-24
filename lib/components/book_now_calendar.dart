import 'package:appwrite/appwrite.dart';
import 'package:bnbscout24/components/confirmation_bottom_sheet.dart';
import 'package:bnbscout24/constants/constants.dart';
import 'package:bnbscout24/data/booking.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingBottomSheet extends StatefulWidget {
  final String id;
  final String propertyId;
  final String? userId;
  final String? status;
  final DateTime? startDate;
  final DateTime? endDate;

  BookingBottomSheet(
  {required this.propertyId,
  this.userId,
  this.status,
  this.startDate,
  this.endDate,
  String? id})
: id = id ?? ID.unique();

  @override
  _BookingBottomSheetState createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<BookingBottomSheet> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedStartDay;
  DateTime? _selectedEndDay;
  final Set<DateTime> _unavailableDays = {
    DateTime(2025, 2, 5), // Dates at midnight (00:00:00.000)
    DateTime(2025, 2, 6),
    DateTime(2025, 2, 7),
  };

  final DateTime _firstDay = DateTime.utc(2023, 1, 1);
  final DateTime _lastDay = DateTime.utc(2028, 12, 31);

  bool _isDayAvailable(DateTime day) {
    // Check if any date in _unavailableDays is the same day (ignoring time)
    return !_unavailableDays.any((unavailableDay) => isSameDay(unavailableDay, day));
  }

  bool _hasUnavailableInRange(DateTime start, DateTime end) {
    final actualStart = start.isBefore(end) ? start : end;
    final actualEnd = start.isBefore(end) ? end : start;

    DateTime currentDay = actualStart;
    while (currentDay.isBefore(actualEnd) || isSameDay(currentDay, actualEnd)) {
      if (!_isDayAvailable(currentDay)) {
        return true; // Found an unavailable day
      }
      currentDay = currentDay.add(Duration(days: 1));
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    // Clamp _focusedDay to valid range
    _focusedDay = _focusedDay.isBefore(_firstDay)
        ? _firstDay
        : (_focusedDay.isAfter(_lastDay) ? _lastDay : _focusedDay);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: ColorPalette.primary, // Override default blue selection color
              ),
            ),
            child: TableCalendar(
              firstDay: _firstDay,
              lastDay: _lastDay,
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              rangeStartDay: _selectedStartDay,
              rangeEndDay: _selectedEndDay,
              enabledDayPredicate: (day) => _isDayAvailable(day),
              calendarStyle: CalendarStyle(
                rangeHighlightColor: ColorPalette.lightPrimary.withOpacity(0.3),
              ),
              onDaySelected: (selectedDay, focusedDay) {
                if (!_isDayAvailable(selectedDay)) return;

                setState(() {
                  if (_selectedStartDay == null || _selectedEndDay != null) {
                    _selectedStartDay = selectedDay;
                    _selectedEndDay = null;
                  } else if (selectedDay.isAfter(_selectedStartDay!)) {
                    _selectedEndDay = selectedDay;
                  } else {
                    _selectedStartDay = selectedDay;
                    _selectedEndDay = null;
                  }

                  if (_selectedStartDay != null && _selectedEndDay != null) {
                    if (_hasUnavailableInRange(_selectedStartDay!, _selectedEndDay!)) {
                      _selectedStartDay = null;
                      _selectedEndDay = null;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Unavailable days in selected range!'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                  _focusedDay = focusedDay;
                });
              },
              onPageChanged: (focusedDay) {
                setState(() {
                  // Ensure focusedDay is within the valid range
                  if (focusedDay.isBefore(_firstDay)) {
                    _focusedDay = _firstDay;
                  } else if (focusedDay.isAfter(_lastDay)) {
                    _focusedDay = _lastDay;
                  } else {
                    _focusedDay = focusedDay;
                  }
                });
              },
              selectedDayPredicate: (day) =>
              isSameDay(_selectedStartDay, day) || isSameDay(_selectedEndDay, day),
              rangeSelectionMode: RangeSelectionMode.toggledOn,
              calendarBuilders: CalendarBuilders(
                disabledBuilder: (context, date, _) => Container(
                  decoration: BoxDecoration(
                    color: ColorPalette.lighterGrey.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text('${date.day}',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                selectedBuilder: (context, date, _) => Container(
                  decoration: BoxDecoration(
                    color: ColorPalette.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text('${date.day}',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                withinRangeBuilder: (context, date, _) => Container(
                  decoration: BoxDecoration(
                    color: ColorPalette.lightPrimary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text('${date.day}'),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorPalette.primary,
              foregroundColor: ColorPalette.white,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            onPressed: () {
              if (_selectedStartDay != null && _selectedEndDay != null) {
                Booking newBooking = Booking(propertyId: widget.propertyId, userId: "user_id", status: "confirmed", startDate: _selectedStartDay, endDate: _selectedEndDay);
                Booking.createBooking(newBooking);
                print('Selected: $_selectedStartDay to $_selectedEndDay');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ConfirmationBottomSheet()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Select a valid period')),
                );
              }
            },
            child: Text('Confirm Booking',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}