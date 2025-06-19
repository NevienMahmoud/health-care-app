import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:health_care_app/core/constants/app_colors/app_colors.dart';

class NotificationSettingsScreen extends StatefulWidget {
  static const routeName = 'notificationsettings';

  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool receiveNotifications = true;
  bool vibration = true;
  bool promoNotifications = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      receiveNotifications = prefs.getBool('receive_notifications') ?? true;
      vibration = prefs.getBool('vibration') ?? true;
      promoNotifications = prefs.getBool('promo_notifications') ?? false;
    });
  }

  Future<void> _saveSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notification Settings',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),

        iconTheme: const IconThemeData(color: AppColors.primaryColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildSwitchTile(
              title: 'Receive Notifications',
              value: receiveNotifications,
              onChanged: (val) {
                setState(() => receiveNotifications = val);
                _saveSetting('receive_notifications', val);
              },
            ),
            buildSwitchTile(
              title: 'Vibration',
              value: vibration,
              onChanged: (val) {
                setState(() => vibration = val);
                _saveSetting('vibration', val);
              },
            ),
            buildSwitchTile(
              title: 'Promotional Notifications',
              value: promoNotifications,
              onChanged: (val) {
                setState(() => promoNotifications = val);
                _saveSetting('promo_notifications', val);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSwitchTile({
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
        title: Text(title, style: const TextStyle(fontSize: 18, color: Colors.black)),
        value: value,
        activeColor: AppColors.primaryColor,
        onChanged: onChanged,
        );
    }
}