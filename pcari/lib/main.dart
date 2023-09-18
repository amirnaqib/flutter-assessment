import 'package:flutter/material.dart';
import 'package:pcari/conf/app_theme.dart';
import 'package:pcari/provider/favorite_provider.dart';
import 'package:pcari/screen/main_contact.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FavoriteProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: ApplicationTheme.primaryColor),
          useMaterial3: true,
        ),
        home: const mainContactScreen(),
      ),
    );
  }
}
