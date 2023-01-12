import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:current_weather_temp/pages/home_page.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '지금 날씨는',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
      ],
      locale: const Locale('ko'),
      theme: ThemeData(
          primaryColor: const Color(0xff123597),
          backgroundColor: const Color.fromARGB(255, 65, 111, 238),
          iconTheme: IconThemeData(
            color: Colors.grey[100],
            size: 20,
          ),
          textTheme: TextTheme(
            bodyText1: TextStyle(color: Colors.grey[100], fontSize: 14),
            bodyText2: TextStyle(color: Colors.grey[100], fontSize: 14),
            subtitle1: const TextStyle(color: Colors.black, fontSize: 18),
            subtitle2: TextStyle(color: Colors.grey[100], fontSize: 70),
          )),
      home: const HomePage(),
    );
  }
}
