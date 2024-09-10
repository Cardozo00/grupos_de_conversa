import 'package:flutter/material.dart';
import 'package:lista_de_conversa/pages/splashscreen/splash_screen_page.dart';
import 'package:lista_de_conversa/repository/dark_mode_repository.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DarkModeRepository>(
            create: (_) => DarkModeRepository())
      ],
      child: Consumer<DarkModeRepository>(
          builder: (_, darkModeRepository, widget) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: darkModeRepository.darkMode
              ? ThemeData.dark()
              : ThemeData.light(),
          home: const SplashScreenPage(),
        );
      }),
    );
  }
}
