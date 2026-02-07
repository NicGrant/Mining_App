import 'package:flutter/material.dart';
import 'pages/dashboard.dart';
import 'pages/miners.dart';
import 'pages/trends.dart';
import 'pages/logs.dart';
import 'models/bitaxe_device.dart';
import 'widgets/app_background.dart';
import 'services/bitaxe_updater.dart'; // 🔥 ADD THIS

void main() {
  runApp(const BitaxeApp());
}

// Global miners list
List<BitaxeDevice> minersList = [];

class BitaxeApp extends StatelessWidget {
  const BitaxeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bitaxe Dashboard',
      theme: ThemeData.dark(useMaterial3: true),
      home: const WelcomePage(),
    );
  }
}

// ------------------ WELCOME PAGE ------------------

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text('Get Started'),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MainApp()),
            );
          },
        ),
      ),
    );
  }
}

// ------------------ MAIN APP ------------------

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;

  late BitaxeUpdater _updater; // 🔥 ADD THIS

  late final List<Widget> _pages = [
    DashboardPage(miners: minersList),
    const MinersPage(),
    const TrendsPage(),
    const LogsPage(),
  ];

  final List<String> _titles = [
    'Dashboard',
    'Miners',
    'Trends',
    'Logs',
  ];

  @override
  void initState() {
    super.initState();

    // 🔥 CREATE UPDATER HERE
    _updater = BitaxeUpdater(
      devices: minersList,
      onUpdate: () {
        // 🔥 THIS IS THE MAGIC LINE
        setState(() {});
      },
    );

    _updater.start();
  }

  @override
  void dispose() {
    _updater.stop(); // 🔥 CLEAN SHUTDOWN
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        extendBodyBehindAppBar: true,

        appBar: AppBar(
          title: Text(_titles[_selectedIndex]),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),

        body: _pages[_selectedIndex],

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.white70,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard), label: 'Dashboard'),
            BottomNavigationBarItem(
                icon: Icon(Icons.memory), label: 'Miners'),
            BottomNavigationBarItem(
                icon: Icon(Icons.show_chart), label: 'Trends'),
            BottomNavigationBarItem(
                icon: Icon(Icons.list_alt), label: 'Logs'),
          ],
        ),
      ),
    );
  }
}
