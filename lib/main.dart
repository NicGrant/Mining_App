import 'package:flutter/material.dart';
import 'pages/dashboard.dart';
import 'pages/miners.dart';
import 'pages/trends.dart';
import 'pages/logs.dart';
import 'pages/scanner_page.dart';
import 'models/bitaxe_device.dart';
import 'widgets/app_background.dart';
import 'services/bitaxe_updater.dart';

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
  late BitaxeUpdater _updater;

  @override
  void initState() {
    super.initState();

    _updater = BitaxeUpdater(
      devices: minersList,
      onUpdate: () {
        setState(() {}); // refresh UI when stats update
      },
    );

    _updater.start();
  }

  @override
  void dispose() {
    _updater.stop();
    super.dispose();
  }

  Future<void> _openScanner() async {
    final BitaxeDevice? device = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ScannerPage(),
      ),
    );

    if (device == null) return;

    final exists = minersList.any((m) => m.ip == device.ip);
    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Miner already added')),
      );
      return;
    }

    setState(() {
      minersList.add(device);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardPage(miners: minersList),
      MinersPage(miners: minersList),
      const TrendsPage(),
      const LogsPage(),
    ];

    final titles = [
      'Dashboard',
      'Miners',
      'Vendors',
      'Logs',
    ];

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        extendBodyBehindAppBar: true,

        appBar: AppBar(
          title: Text(titles[_selectedIndex]),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),

        body: pages[_selectedIndex],

        floatingActionButton: _selectedIndex == 1
            ? FloatingActionButton(
                onPressed: _openScanner,
                child: const Icon(Icons.add),
              )
            : null,

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
                icon: Icon(Icons.show_chart), label: 'Vendors'),
            BottomNavigationBarItem(
                icon: Icon(Icons.list_alt), label: 'Logs'),
          ],
        ),
      ),
    );
  }
}
