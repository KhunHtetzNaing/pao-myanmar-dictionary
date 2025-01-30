import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pao_myanmar_dictionary/ui/home.dart';
import 'package:upgrader/upgrader.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en'), Locale('my')],
        path: 'assets/translations',
        fallbackLocale: Locale('en'),
        startLocale: Locale("en"),
        saveLocale: true,
        child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const appcastURL =
      "https://github.com/KhunHtetzNaing/pao-myanmar-dictionary/raw/refs/heads/main/files/update.xml";

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        title: "Pa'O Myanmar Dictionary",
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            useMaterial3: true,
            fontFamily: 'Pyidaungsu'),
        darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.green, brightness: Brightness.dark),
            useMaterial3: true,
            fontFamily: 'Pyidaungsu'),
        themeMode: ThemeMode.system,
        home: UpgradeAlert(
          upgrader: Upgrader(
            durationUntilAlertAgain: Duration(seconds: 10),
            storeController: UpgraderStoreController(
              onAndroid: () => UpgraderAppcastStore(appcastURL: appcastURL),
            ),
          ),
          child: HomePage(),
        ));
  }
}
