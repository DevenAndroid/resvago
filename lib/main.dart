
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resvago/admin/loginscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/local_string.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBN7-pBlJcY6p8stbdeDRgo-JVF6MO2K30",
            authDomain: "resvago-ire.firebaseapp.com",
            databaseURL: "https://resvago-ire-default-rtdb.firebaseio.com",
            projectId: "resvago-ire",
            storageBucket: "resvago-ire.appspot.com",
            messagingSenderId: "382013840274",
            appId: "1:382013840274:web:05b02bbef51966a4abff4b",));
  }
  else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}



class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  updateLanguage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? appLanguage = sharedPreferences.getString("app_language");
    if (appLanguage == null || appLanguage == "English") {
      Get.updateLocale(const Locale('en', 'US'));
    } else if (appLanguage == "French") {
      Get.updateLocale(const Locale('fr', 'FR'));
    }
  }

  @override
  void initState() {
    super.initState();
    updateLanguage();
  }
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: LocaleString(),
      locale: const Locale('en', 'US'),
      title: 'Resvago Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LogInScreen(),
    );
  }
}

