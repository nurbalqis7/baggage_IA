import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const MyApp());

// Main Application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Baggage Fee Calculator',

      // Dark blue and black theme
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B1220),

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          brightness: Brightness.dark,
        ),

        // Application font
        textTheme: GoogleFonts.nunitoTextTheme(ThemeData.dark().textTheme),

        // AppBar style
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF111827),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),

        // Input field style
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF263449),
          hintStyle: const TextStyle(color: Color(0xFF9CAFC4)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),

        // Card style
        cardTheme: CardThemeData(
          color: const Color(0xFF17243B),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),

      home: const HomePage(),
    );
  }
}

// HOME PAGE
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Input controllers
  final TextEditingController _weightController = TextEditingController();

  final TextEditingController _rateController = TextEditingController();

  // Selected ticket class
  String _ticketClass = 'Economy';

  // Calculation results
  double _excessWeight = 0;
  double _excessCharge = 0;
  double _totalPayable = 0;

  bool _calculated = false;

  // Calculate baggage fee
  void _calculateFee() {
    double? weight = double.tryParse(_weightController.text.trim());

    double? rate = double.tryParse(_rateController.text.trim());

    // Check input values
    if (weight == null || rate == null || weight < 0 || rate < 0) {
      _showMessage('Please enter valid numbers.');
      return;
    }

    // Determine baggage allowance
    double allowance = 20;

    if (_ticketClass == 'Business') {
      allowance = 40;
    }

    // Calculate excess baggage weight
    double excess = weight - allowance;

    if (excess < 0) {
      excess = 0;
    }

    // Calculate excess baggage charge
    double charge = excess * rate;

    // Calculate 8% service tax
    double tax = charge * 0.08;

    // Calculate total amount payable
    double total = charge + tax;

    setState(() {
      _excessWeight = excess;
      _excessCharge = charge;
      _totalPayable = total;
      _calculated = true;
    });
  }

  // Reset calculator
  void _resetCalculator() {
    setState(() {
      _weightController.clear();
      _rateController.clear();

      _ticketClass = 'Economy';

      _excessWeight = 0;
      _excessCharge = 0;
      _totalPayable = 0;

      _calculated = false;
    });
  }

  // Display error message
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF2563EB),
      ),
    );
  }

  @override
  void dispose() {
    _weightController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  // Home Page Design
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),

      // Application title bar
      appBar: AppBar(
        title: const Text(
          'Baggage Fee Calculator',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu),
            onSelected: (String value) {
              if (value == 'About') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutPage()),
                );
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'Home', child: Text('Home')),
              PopupMenuItem(value: 'About', child: Text('About')),
            ],
          ),
        ],
      ),

      // Main Content
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),

            // Application icon
            const Icon(Icons.luggage, size: 75, color: Color(0xFF60A5FA)),

            const SizedBox(height: 10),

            // Application heading
            const Text(
              'Excess Baggage Calculator',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Calculate your excess baggage fee easily!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF9CAFC4), fontSize: 14),
            ),

            const SizedBox(height: 25),

            // Baggage Information Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Baggage Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Input 1: Baggage Weight
                    const Text(
                      'Baggage Weight (kg)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: _weightController,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Enter baggage weight',
                        prefixIcon: Icon(Icons.scale, color: Color(0xFF60A5FA)),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Input 2: Ticket Class
                    const Text(
                      'Ticket Class',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 8),

                    DropdownButtonFormField<String>(
                      initialValue: _ticketClass,
                      dropdownColor: const Color(0xFF17243B),
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.airplane_ticket,
                          color: Color(0xFF60A5FA),
                        ),
                      ),

                      items: const [
                        DropdownMenuItem(
                          value: 'Economy',
                          child: Text('Economy (20 kg)'),
                        ),
                        DropdownMenuItem(
                          value: 'Business',
                          child: Text('Business (40 kg)'),
                        ),
                      ],

                      onChanged: (String? value) {
                        setState(() {
                          _ticketClass = value!;
                          _calculated = false;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    // Input 3: Excess Baggage Rate
                    const Text(
                      'Excess Baggage Rate (RM/kg)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: _rateController,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Enter rate per kg',
                        prefixIcon: Icon(
                          Icons.payments,
                          color: Color(0xFF60A5FA),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Calculate Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: _calculateFee,
                        icon: const Icon(Icons.calculate),
                        label: const Text(
                          'Calculate Fee',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Reset Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: _resetCalculator,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reset'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF60A5FA),
                          side: const BorderSide(color: Color(0xFF3B82F6)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Calculation Results
            if (_calculated) ...[
              const SizedBox(height: 25),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),

                  child: Column(
                    children: [
                      const Text(
                        'Calculation Results',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 20),

                      _resultRow(
                        'Excess Baggage Weight',
                        '${_excessWeight.toStringAsFixed(2)} kg',
                      ),

                      _resultRow(
                        'Excess Baggage Charge',
                        'RM ${_excessCharge.toStringAsFixed(2)}',
                      ),

                      _resultRow(
                        'Service Tax (8%)',
                        'RM ${(_excessCharge * 0.08).toStringAsFixed(2)}',
                      ),

                      const SizedBox(height: 15),

                      // Total Payable
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFF263B5A),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'TOTAL AMOUNT PAYABLE',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF93C5FD),
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              'RM ${_totalPayable.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  // Display calculation results
  Widget _resultRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Color(0xFFD1D5DB)),
            ),
          ),

          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// ABOUT PAGE
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  // Open GitHub Repository
  Future<void> _openGitHub() async {
    final Uri url = Uri.parse('https://github.com/nurbalqis7/baggage_IA');

    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),

      // About Page AppBar
      appBar: AppBar(
        title: const Text(
          'About Application',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu),
            onSelected: (String value) {
              if (value == 'Home') {
                Navigator.pop(context);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'Home', child: Text('Home')),
              PopupMenuItem(value: 'About', child: Text('About')),
            ],
          ),
        ],
      ),

      // About Page Content
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),

        child: Column(
          children: [
            const SizedBox(height: 20),

            // Application Icon
            Container(
              height: 125,
              width: 125,
              decoration: BoxDecoration(
                color: const Color(0xFF17243B),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.luggage,
                size: 80,
                color: Color(0xFF60A5FA),
              ),
            ),

            const SizedBox(height: 20),

            // Application Name
            const Text(
              'Excess Baggage Fee Calculator',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Calculate your excess baggage fee easily '
              'before travelling.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF9CAFC4), fontSize: 14),
            ),

            const SizedBox(height: 35),

            // Author Information
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Author Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Student Name
            _infoCard(Icons.person, 'Name', 'NUR BALQIS BINTI AZLY SHAM'),

            // Matric Number
            _infoCard(Icons.badge, 'Matric Number', '2024229506'),

            // Course
            _infoCard(Icons.school, 'Course', 'CDCS251'),

            const SizedBox(height: 25),

            const Text(
              'Source Code',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 12),

            // GitHub Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _openGitHub,
                icon: const Icon(Icons.code),
                label: const Text(
                  'View GitHub Repository',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Divider(color: Color(0xFF374151)),

            const SizedBox(height: 12),

            // Copyright Notice
            const Text(
              '© 2026 Excess Baggage Fee Calculator. '
              'All Rights Reserved.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Color(0xFF9CAFC4)),
            ),

            const SizedBox(height: 10),

            const Text(
              'Developed for Mobile Technology Assignment.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Color(0xFF9CAFC4)),
            ),

            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  // Display author information
  static Widget _infoCard(IconData icon, String title, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF60A5FA), size: 28),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Text(value, style: const TextStyle(color: Color(0xFF9CAFC4))),
      ),
    );
  }
}
