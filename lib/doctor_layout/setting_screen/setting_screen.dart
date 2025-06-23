import 'package:flutter/material.dart';
import 'package:health_care_app/doctor_layout/setting_screen/help_support_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:health_care_app/auth/pressentation/screens/auht_screen/forgot_pass_screen.dart';
import 'package:health_care_app/core/constants/app_colors/app_colors.dart';
import 'package:health_care_app/doctor_layout/setting_screen/change_password_screen.dart';
import 'package:health_care_app/doctor_layout/setting_screen/wallet_screen.dart';
import 'package:health_care_app/providers/setting_provider.dart';
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

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      receiveNotifications = prefs.getBool('receive_notifications') ?? true;
      vibration = prefs.getBool('vibration') ?? true;
      isLoading = false;
    });
  }

  Future<void> _saveSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  void _showNotificationDialog(BuildContext context) {
    bool tempReceive = receiveNotifications;
    bool tempVibration = vibration;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.notification),
          content: StatefulBuilder(
            builder: (context, setStateDialog) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    title: Text(AppLocalizations.of(context)!.receiveNotifications),
                    value: tempReceive,
                    activeColor: AppColors.primaryColor,
                    onChanged: (val) {
                      setStateDialog(() => tempReceive = val);
                    },
                  ),
                  SwitchListTile(
                    title: Text(AppLocalizations.of(context)!.vibration),
                    value: tempVibration,
                    activeColor: AppColors.primaryColor,
                    onChanged: (val) {
                      setStateDialog(() => tempVibration = val);
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel,
                  style: const TextStyle(color: Colors.black)),
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
              child: Text(AppLocalizations.of(context)!.save,
                  style: const TextStyle(color: AppColors.primaryColor)),
            ),
          ],
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final provider = Provider.of<SettingProvider>(context, listen: false);
    String currentLang = provider.language;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.language),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("English"),
                trailing: currentLang == 'en'
                    ? const Icon(Icons.check, color: AppColors.primaryColor)
                    : null,
                onTap: () {
                  provider.changeLanguage('en');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("العربية"),
                trailing: currentLang == 'ar'
                    ? const Icon(Icons.check, color: AppColors.primaryColor)
                    : null,
                onTap: () {
                  provider.changeLanguage('ar');
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
    final provider = Provider.of<SettingProvider>(context);
    final lang = provider.language;
    final loc = AppLocalizations.of(context)!;

    return SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    loc.setting,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.black),
                  ),
                ),
                const SizedBox(height: 16),
                const Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primaryColor,
                      radius: 33,
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/images/apple.png'),
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
                  child: Row(
                    children: [
                      const Icon(Icons.wallet),
                      const SizedBox(width: 10),
                      Text(loc.wallet,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(color: Colors.black),
                const SizedBox(height: 10),
                Text(loc.security,
                    style: const TextStyle(
                        fontSize: 18, color: Colors.black)),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                        context, ChangePasswordScreen.routeName);
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.lock),
                      const SizedBox(width: 10),
                      Text(loc.changePassword,
                          style: const TextStyle(color: Colors.black))
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, ForgotPassword.routeName);
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.lock_open),
                      const SizedBox(width: 10),
                      Text(loc.forgotPassword,
                          style: const TextStyle(color: Colors.black))
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(color: Colors.black),
                const SizedBox(height: 10),
                Text(loc.general,
                    style: const TextStyle(
                        fontSize: 18, color: Colors.black)),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _showNotificationDialog(context),
                  child: Row(
                    children: [
                      const Icon(Icons.notifications, color: Colors.black),
                      const SizedBox(width: 10),
                      Text(loc.notification,
                          style: const TextStyle(color: Colors.black)),
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
                      Text(loc.language,
                          style: const TextStyle(color: Colors.black)),
                      const Spacer(),
                      Text(lang == 'en' ? 'English' : 'العربية',
                          style: const TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, SupportScreen.routeName);
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.help, color: Colors.black),
                      const SizedBox(width: 10),
                      Text(loc.helpSupport,
                          style: const TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
              ],
            ),
            ),
        );
    }
}