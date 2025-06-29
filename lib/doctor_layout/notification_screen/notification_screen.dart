import 'package:flutter/material.dart';
import 'package:health_care_app/core/constants/app_colors/app_colors.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  static const routeName = 'doctornotification';

  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<dynamic> appointments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('logged_in_email');
    if (email == null) return;

    try {
      final response = await Dio().get('https://healthcare-4scv.vercel.app/api/doctors');
      final doctors = response.data['data'];
      final doctor = doctors.firstWhere((doc) => doc['email'] == email);
      final doctorId = doctor['_id'];

      final appointmentsResponse = await Dio().get(
        'https://healthcare-4scv.vercel.app/api/appointments/doctor/$doctorId',
      );

      final allAppointments = appointmentsResponse.data['data'];
      setState(() {
        appointments = allAppointments.where((a) => a['status'] == 'booked').toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('❌ Error fetching appointments: $e');
    }
  }

  Future<void> acceptRequest(String appointmentId) async {
    try {
      await Dio().put(
        'https://healthcare-4scv.vercel.app/api/appointments/update/$appointmentId',
        data: {"status": "accepted"},
      );
      setState(() {
        appointments.removeWhere((a) => a['_id'] == appointmentId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment accepted')),
      );
    } catch (e) {
      print('❌ Error accepting appointment: $e');
    }
  }

  Future<void> rejectRequest(String appointmentId) async {
    try {
      await Dio().delete(
        'https://healthcare-4scv.vercel.app/api/appointments/cancel/$appointmentId',
      );
      setState(() {
        appointments.removeWhere((a) => a['_id'] == appointmentId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment rejected')),
      );
    } catch (e) {
      print('❌ Error rejecting appointment: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
            children: [
              const Center(
                child: Text(
                  'Notifications',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: appointments.isEmpty
                    ? const Center(child: Text('No new appointments'))
                    : ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    final appointment = appointments[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              leading: const CircleAvatar(
                                backgroundImage: AssetImage(
                                    'assets/images/apple.png'),
                                radius: 30,
                              ),
                              title: Text(
                                'Appointment Request',
                                style: const TextStyle(
                                    color: Colors.white),
                              ),
                              subtitle: Text(
                                '${appointment['date']} at ${appointment['time']}',
                                style: const TextStyle(
                                    color: Colors.white),
                              ),
                              trailing: GestureDetector(
                                onTap: () =>
                                    rejectRequest(appointment['_id']),
                                child: const Icon(Icons.close,
                                    color: Colors.white),
                              ),
                            ),
                            const Divider(color: Colors.white),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'New Request',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => acceptRequest(
                                        appointment['_id']),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor:
                                      AppColors.primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text('Accept'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            ),
        );
    }
}