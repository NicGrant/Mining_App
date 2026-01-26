import 'package:flutter/material.dart';
import 'pages/dashboard.dart';
import 'pages/miners.dart';
import 'pages/trends.dart';
import 'pages/logs.dart';
import 'models/bitaxe_device.dart';
void main() {
  runApp(const BitaxeApp());
}
List<BitaxeDevice> minersList = [];

class BitaxeApp extends StatelessWidget {
  const BitaxeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bitaxe Dashboard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const WelcomePage(),
    );
  }
}

// Welcome Page
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.memory, size: 120, color: Colors.orange),
            const SizedBox(height: 24),
            const Text(
              'Welcome to Bitaxe Dashboard',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Monitor your Bitaxe miners, track trends, check logs, '
              'and manage devices all in one place.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MainApp()),
                );
              },
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}

// Main App with Bottom Navigation
class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;

  // Pages (body content only)
  final List<Widget> _pages = [
    const DashboardPage(),
    const MinersPage(),
    const TrendsPage(),
    const LogsPage(),
  ];

  // Titles for AppBar
  final List<String> _titles = [
    'Dashboard',
    'Miners',
    'Trends',
    'Logs',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_selectedIndex])),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
  currentIndex: _selectedIndex,
  onTap: (index) => setState(() => _selectedIndex = index),
  backgroundColor: const Color.fromARGB(255, 12, 12, 12),  // Dark grey bar
  selectedItemColor: Colors.orange,    // Active icon color
  unselectedItemColor: const Color.fromARGB(179, 34, 34, 34), // Inactive icon color
  items: const [
    BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
    BottomNavigationBarItem(icon: Icon(Icons.memory), label: 'Miners'),
    BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Trends'),
    BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Logs'),
  ],
      ),
    );
  }
}
