import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:health_care_app/core/constants/app_colors/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DoctorHomeScreen extends StatefulWidget {
  static const routeName = 'doctorhome';

  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, String>> appointments = [
    {
      'name': "Mr. Jack Sparrow",
      'type': "Heart Patient",
      'time': "5:00pm to 5:20pm",
      'date': "13 Aug, 2023",
      'phone': "01069611488",
    },
    {
      'name': "Ms. Emily Watson",
      'type': "Heart Patient",
      'time': "3:00pm to 3:30pm",
      'date': "14 Aug, 2023",
      'phone': "01557596674",
    },
  ];

  List<Map<String, String>> filteredAppointments = [];

  @override
  void initState() {
    super.initState();
    filteredAppointments = appointments;
    _searchController.addListener(_filterAppointments);
  }

  void _filterAppointments() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredAppointments = appointments.where((appt) {
        return appt['date']!.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _makePhoneCall(String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot make the call')),
      );
    }
  }

  void _openWhatsAppSimple(String phone) async {
    // تأكد من أن رقم الهاتف يبدأ بـ كود الدولة (مثلاً 20 للمصريين)
    String formattedPhone = phone;
    if (!phone.startsWith('20')) {
      formattedPhone = '20' + phone;
    }

    final whatsappUrl = Uri.parse("https://wa.me/$formattedPhone");
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot open WhatsApp')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
            children: [
              // Header + Search
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage('assets/images/apple.png'),
                            radius: 30,
                          ),
                        ],
                      ),
                    ),
                     Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.welcome,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                     Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(AppLocalizations.of(context)!.haveANiceDay,
                              style: TextStyle(color: Colors.white, fontSize: 15)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            controller: _searchController,
                            decoration:  InputDecoration(
                              hintText: AppLocalizations.of(context)!.search,
                              border: InputBorder.none,
                              suffixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              // Title
               Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.upcomingAppointments,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              // Appointments list
              Expanded(
                child: filteredAppointments.isEmpty
                    ? const Center(
                  child: Text("No Appointments Found"),
                )
                    : ListView.builder(
                  itemCount: filteredAppointments.length,
                  itemBuilder: (context, index) {
                    final appt = filteredAppointments[index];
                    return Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: const CircleAvatar(
                                  backgroundImage:
                                  AssetImage('assets/images/apple.png'),
                                  radius: 30,
                                ),
                                title: Text(appt['name']!,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                subtitle: Text(appt['type']!,
                                    style: const TextStyle(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                                child: Text(appt['time']!,
                                    style: const TextStyle(color: Colors.white)),
                              ),
                              Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Icon(
                                      Icons.date_range,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    appt['date']!,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(Icons.call,
                                        color: Colors.white),
                                    onPressed: () {
                                      _makePhoneCall(appt['phone']!);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.chat,
                                        color: Colors.white),
                                    onPressed: () {
                                      _openWhatsAppSimple(appt['phone']!);
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            ));
    }
}