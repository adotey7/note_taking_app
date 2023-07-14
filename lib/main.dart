import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_taking/constants.dart';
import 'package:note_taking/providers/theme_mode.dart';
import 'package:note_taking/screens/task_screen.dart';
import 'package:provider/provider.dart';
import 'theme/color_schemes.g.dart';
import './screens/home_page.dart';
import './providers/tasks.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Tasks(),
        ),
        ChangeNotifierProvider(
          create: (context) => ToggleTheme(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nottie',
      themeMode: Provider.of<ToggleTheme>(context).currentTheme,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF8FDFF),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        textTheme: TextTheme(
          bodySmall: GoogleFonts.outfit(
            color: Colors.black54,
            fontSize: 14,
          ),
          titleLarge: GoogleFonts.outfit(
            fontSize: 28,
            color: kTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        // fontFamily: GoogleFonts.outfit(),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        // appBarTheme: AppBarTheme(
        //   backgroundColor: Color(0xFFF8FDFF),
        // ),
        iconTheme: const IconThemeData(
          color: Color(0xFF4FD8EB),
        ),
        textTheme: TextTheme(
          bodySmall: GoogleFonts.outfit(
            color: const Color.fromARGB(255, 12, 212, 235),
            fontSize: 14,
          ),
          titleLarge: GoogleFonts.outfit(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const MyHomePage(),
      routes: {
        AddTask.routeName: (context) => const AddTask(),
      },
    );
  }
}
