import 'package:flutter/material.dart';
import 'package:health_care_app/core/constants/app_colors/app_colors.dart';

class NotificationScreen extends StatefulWidget {
  static const routeName = 'doctornotification';

  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // بيانات محجوزة وهمية مؤقتاً
  List<Map<String, dynamic>> notifications = [
    {
      'name': 'Mr. Jack Sparrow',
      'message':
      'wants to fix an appointment with you for medical checkup.',
      'time': '5 min ago',
    },
    {
      'name': 'Mr. John Doe',
      'message': 'wants to consult about chest pain.',
      'time': '10 min ago',
    },
  ];

  void acceptRequest(int index) {
    // هنا في المستقبل هنربطه بـ API وهنوديه لـ upcoming
    setState(() {
      notifications.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Appointment accepted')),
    );
  }

  void rejectRequest(int index) {
    setState(() {
      notifications.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Appointment rejected')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
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
                child: notifications.isEmpty
                    ? const Center(child: Text('No notifications'))
                    : ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                leading: const CircleAvatar(
                                  backgroundImage:
                                  AssetImage('assets/images/apple.png'),
                                  radius: 30,
                                ),
                                title: Text(
                                  notification['name'],
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  notification['message'],
                                  style: const TextStyle(color: Colors.white),
                                ),
                                trailing: GestureDetector(
                                  onTap: () => rejectRequest(index),
                                  child: const Icon(Icons.close,
                                      color: Colors.white),
                                ),
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
                                  Text(
                                    notification['time'],
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => acceptRequest(index),
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