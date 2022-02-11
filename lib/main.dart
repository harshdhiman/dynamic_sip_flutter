import 'package:dynamic_sip_flutter/constants.dart';
import 'package:dynamic_sip_flutter/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DSIP Flutter',
      theme: ThemeData.from(
        colorScheme: const ColorScheme.dark(
          primary: kAppPrimaryColor,
          onPrimary: Colors.white,
        ),
      ).copyWith(
        appBarTheme: const AppBarTheme(
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          centerTitle: true,
        ),
        scaffoldBackgroundColor: kAppBackgroudColor,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
