import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecosync/constants.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';


/// The hove page which hosts the calendar
class Calander extends StatefulWidget {

  /// Creates the home page to display teh calendar widget.
  const Calander({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CalanderState createState() => _CalanderState();
}

class _CalanderState extends State<Calander> {
  List<Meeting> meetings=[];

@override
void initState() {
  super.initState();
  getMeetingsFromFirebase().then((fetchedMeetings) {
    setState(() {
      meetings = fetchedMeetings;
    });
    print(meetings);
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: appbar(context,"Event Calander"),
        body: SafeArea(
          child: SfCalendar(
                view: CalendarView.month,
                dataSource: MeetingDataSource(meetings),
                
                monthViewSettings: const MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
              ),
        ));
  }


Future<List<Meeting>> getMeetingsFromFirebase() async {
  final meetings = <Meeting>[];
  final QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('events')
      .get();

  for (final DocumentSnapshot doc in snapshot.docs) {
    final data = doc.data() as Map<String, dynamic>;
    final title = data['title'] as String;
    final startTime = data['event_datetime'].toDate();
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    final colorValue = const Color(0xFF0F8644);

    meetings.add(Meeting(
      title,
      startTime,
      endTime,
      Color(0xFF0F8644),
    ));
  }

  return meetings;
}
}

/// An object to set the appointment collection data source to calendar, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

 

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

}