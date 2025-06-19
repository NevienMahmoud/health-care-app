import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:health_care_app/auth/pressentation/screens/auht_screen/forgot_pass_screen.dart';
import 'package:health_care_app/core/constants/app_colors/app_colors.dart';
import 'package:health_care_app/doctor_layout/setting_screen/wallet_screen.dart';
import 'package:health_care_app/doctor_layout/setting_screen/change_password_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingScreen extends StatefulWidget {
  static const routeName = 'doctorsetting';

  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isLoading = true;
  bool receiveNotifications = true;
  bool vibration = true;

  String selectedLanguage = 'English';

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
      selectedLanguage = prefs.getString('selected_language') ?? 'English';
      isLoading = false;
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  void _showNotificationDialog(BuildContext context) {
    bool tempReceive = receiveNotifications;
    bool tempVibration = vibration;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Notification Settings",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    title: const Text("Receive Notifications"),
                    activeColor: AppColors.primaryColor,
                    value: tempReceive,
                    onChanged: (val) => setDialogState(() => tempReceive = val),
                  ),
                  SwitchListTile(
                    title: const Text("Vibration"),
                    activeColor: AppColors.primaryColor,
                    value: tempVibration,
                    onChanged: (val) => setDialogState(() => tempVibration = val),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel",style: TextStyle(color: Colors.black),),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  receiveNotifications = tempReceive;
                  vibration = tempVibration;
                });
                _saveSetting('receive_notifications', tempReceive);
                _saveSetting('vibration', tempVibration);
                Navigator.pop(context);
              },
              child: const Text("Save",style: TextStyle(color: AppColors.primaryColor),),
            ),
          ],
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Select Language",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("English"),
                trailing: selectedLanguage == 'English'
                    ? const Icon(Icons.check, color: AppColors.primaryColor)
                    : null,
                onTap: () {
                  setState(() {
                    selectedLanguage = 'English';
                  });
                  _saveSetting('selected_language', 'English');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("العربية"),
                trailing: selectedLanguage == 'العربية'
                    ? const Icon(Icons.check, color: AppColors.primaryColor)
                    : null,
                onTap: () {
                  setState(() {
                    selectedLanguage = 'العربية';
                  });
                  _saveSetting('selected_language', 'العربية');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Center(
                  child: Text(AppLocalizations.of(context)!.setting,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.black)),
                ),
                const SizedBox(height: 16),
                const Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primaryColor,
                      radius: 33,
                      child: CircleAvatar(
                        backgroundImage:
                        AssetImage('assets/images/apple.png'),
                        radius: 30,
                      ),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Dr.Alexa',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        SizedBox(height: 5),
                        Text('Heart Specilist',
                            style:
                            TextStyle(fontSize: 15, color: Colors.black)),
                        Row(
                          children: [
                            Icon(Icons.star_rounded,
                                color: Color(0xffFFC700)),
                            SizedBox(width: 10),
                            Text('4.8',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ],
                        )
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(WalletScreen.routeName);
                  },
                  child: const Row(
                    children: [
                      Icon((Icons.wallet)),
                      SizedBox(width: 10),
                      Text('My Wallet',
                          style:
                          TextStyle(fontSize: 18, color: Colors.black)),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                const Divider(color: Colors.black, thickness: 1),
                SizedBox(height: 10,),
                const Text('Security',
                    style: TextStyle(color: Colors.black, fontSize: 18)),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                        context, ChangePasswordScreen.routeName);
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.lock, color: Colors.black),
                      SizedBox(width: 10),
                      Text('Change password',
                          style: TextStyle(color: Colors.black))
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, ForgotPassword.routeName);
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.lock_open, color: Colors.black),
                      SizedBox(width: 10),
                      Text('Forgot password',
                          style: TextStyle(color: Colors.black))
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                const Divider(color: Colors.black, thickness: 1),
                SizedBox(height: 10,),
                const Text('General',
                    style: TextStyle(color: Colors.black, fontSize: 18)),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _showNotificationDialog(context),
                  child: Row(
                    children: [
                      const Icon(Icons.notifications, color: Colors.black),
                      const SizedBox(width: 10),
                       Text(AppLocalizations.of(context)!.notification, style: TextStyle(color: Colors.black)),
                      const Spacer(),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _showLanguageDialog(context),
                  child: Row(
                    children: [
                      const Icon(Icons.language, color: Colors.black),
                      const SizedBox(width: 10),
                      const Text('Languages', style: TextStyle(color: Colors.black)),
                      const Spacer(),
                      Text(selectedLanguage,
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Row(
                  children: [
                    Icon(Icons.help, color: Colors.black),
                    SizedBox(width: 10),
                    Text('Help and Support', style: TextStyle(color: Colors.black)),
                  ],
                ),
              ],
            ),
            ),
        );
    }
}