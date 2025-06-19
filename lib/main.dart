import 'package:flutter/material.dart';
import 'package:health_care_app/core/helper/on_generate_routs.dart';
import 'package:health_care_app/patient_layout/patient_home_screen/patient_home_screen.dart';
import 'package:health_care_app/providers/setting_provider.dart';
import 'package:health_care_app/splash/views/splash_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settingProvider = SettingProvider();
  await settingProvider.getLang();

runApp( ChangeNotifierProvider(
  create: (context) => settingProvider,
  child: const HealthCare(), ), ); }

class HealthCare extends StatelessWidget {
  const HealthCare({super.key});

@override Widget build(BuildContext context) {
  SettingProvider settingProvider = Provider.of<SettingProvider>(context);
  return MaterialApp(
      localizationsDelegates:
      const [ AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
     supportedLocales:
     const [ Locale('en'),
             Locale('ar'),
     ],
      locale: Locale(settingProvider.language),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: onGenerateRoute,
      initialRoute: SplashScreen.routeName,
   );
  }
}