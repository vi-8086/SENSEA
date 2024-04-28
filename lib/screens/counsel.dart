import 'package:flutter/material.dart';
import 'package:sensea/database/database.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counseling',
      home: CounselingPage(),
      theme: ThemeData(
        primaryColor: Colors.brown[200], // Setting primary color to pastel beige
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.brown[800]), // Setting accent color to brown
      ),
    );
  }
}

class CounselingPage extends StatefulWidget {
  @override
  _CounselingPageState createState() => _CounselingPageState();
}

class _CounselingPageState extends State<CounselingPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _doctors = [
    {'name': 'Dr. John Ulmann', 'specialization': 'Psychologist'},
    {'name': 'Dr. Jane Abrham Shilberschatz', 'specialization': 'Therapist'},
  ];

  final List<String> _timeSlots = [
    '10:00 AM - 11:00 AM',
    '11:00 AM - 12:00 PM',
    '12:00 PM - 01:00 PM',
    '02:00 PM - 03:00 PM',
    // Add more time slots as needed
  ];

  String _selectedTimeSlot = '';

  @override
  void initState() {
    super.initState();
    initdbConnection();
  }

  void initdbConnection() async {
    await connection.open();
    print("Database Connected!");
  }

  void dispose() {
    connection.close();
    super.dispose();
  }

  void _bookAppointment(String doctorName) async {
    if (_selectedTimeSlot.isEmpty) {
      _showErrorDialog('Please select a time slot.');
      return;
    }

    final DateTime bookingTime = DateTime.now();
    final String formattedBookingTime = bookingTime.toIso8601String();

    try {
      final result = await connection.query(
        'INSERT INTO appointments (doctor_name, appointment_slot, booking_time) VALUES (@doctorName, @appointmentSlot, @bookingTime)',
        substitutionValues: {
          'doctorName': doctorName,
          'appointmentSlot': _selectedTimeSlot,
          'bookingTime': formattedBookingTime,
        },
      );

      if (result != null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Appointment booked successfully!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {}); // Refresh the UI to reflect the booked appointment
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        _showErrorDialog('Failed to book appointment. Please try again.');
      }
    } catch (e) {
      _showErrorDialog('An error occurred while booking the appointment. Please try again later.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Counseling'),
      ),
      body: ListView.builder(
        itemCount: _doctors.length,
        itemBuilder: (context, index) {
          final doctor = _doctors[index];
          return _buildDoctorCard(doctor);
        },
      ),
    );
  }

  Widget _buildDoctorCard(Map<String, dynamic> doctor) {
    return Card(
      margin: EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      color: Colors.brown[100], // Setting card color to pastel beige
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Doctor: ${doctor['name']}',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown[800]), // Changing text color to brown
            ),
            SizedBox(height: 8.0),
            Text('Specialization: ${doctor['specialization']}', style: TextStyle(color: Colors.brown[800])), // Changing text color to brown
            SizedBox(height: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Select a time slot:', style: TextStyle(color: Colors.brown[800])), // Changing text color to brown
                SizedBox(height: 8.0),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: _buildTimeSlotButtons(),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                _bookAppointment(doctor['name']);
              },
              child: Text('Book Appointment', style: TextStyle(color: Colors.brown[50])), // Changing text color to complementary beige
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown[300], // Setting button color to complementary beige
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<ElevatedButton> _buildTimeSlotButtons() {
    return _timeSlots.map((timeSlot) {
      return ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedTimeSlot = timeSlot;
          });
        },
        child: Text(timeSlot, style: TextStyle(color: Colors.brown[800])), // Changing text color to brown
      );
    }).toList();
  }
}
