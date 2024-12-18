import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import GoogleFonts package

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: const SettingsPage(),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedCurrency = "USD";
  String _selectedLanguage = "English";

  void _openCurrencyPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CurrencyPage(selectedCurrency: _selectedCurrency),
      ),
    );
    if (result != null) {
      setState(() {
        _selectedCurrency = result;
      });
    }
  }

  void _openLanguagePage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LanguagePage(selectedLanguage: _selectedLanguage),
      ),
    );
    if (result != null) {
      setState(() {
        _selectedLanguage = result;
      });
    }
  }

  Widget buildListTile(String title, String? subtitle, VoidCallback onTap) {
    return ListTile(
      title: Text(
        title,
        style: GoogleFonts.quicksand(fontSize: 16), // Apply Quicksand font
      ),
      trailing: subtitle != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  subtitle,
                  style: GoogleFonts.quicksand(color: Colors.grey), // Apply Quicksand font
                ),
                const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              ],
            )
          : const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          
          style: GoogleFonts.quicksand(fontSize: 22,fontWeight: FontWeight.w600), // Apply Quicksand font
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView(
        children: [
          buildListTile("Currency", _selectedCurrency, _openCurrencyPage),
          buildListTile("Language", _selectedLanguage, _openLanguagePage),
          buildListTile("Security", "Fingerprint", () {
            // Handle security action
          }),
          buildListTile("Notification", null, () {
            // Handle notification action
          }),
          buildListTile("About", null, () {
            // Handle about action
          }),
          buildListTile("Help", null, () {
            // Handle help action
          }),
        ],
      ),
    );
  }
}

class CurrencyPage extends StatelessWidget {
  final String selectedCurrency;

  const CurrencyPage({super.key, required this.selectedCurrency});

  @override
  Widget build(BuildContext context) {
    final currencies = ["USD", "EUR", "GBP", "INR", "JPY", "AUD", "CAD"];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select Currency",
          style: GoogleFonts.quicksand(), // Apply Quicksand font
        ),
      ),
      body: ListView.builder(
        itemCount: currencies.length,
        itemBuilder: (context, index) {
          final currency = currencies[index];
          return ListTile(
            title: Text(
              currency,
              style: GoogleFonts.quicksand(), // Apply Quicksand font
            ),
            trailing: selectedCurrency == currency
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              Navigator.pop(context, currency); // Pass selected currency back
            },
          );
        },
      ),
    );
  }
}

class LanguagePage extends StatelessWidget {
  final String selectedLanguage;

  const LanguagePage({super.key, required this.selectedLanguage});

  @override
  Widget build(BuildContext context) {
    final languages = ["English", "Spanish", "French", "German", "Chinese", "Hindi", "Japanese"];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select Language",
          style: GoogleFonts.quicksand(), // Apply Quicksand font
        ),
      ),
      body: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, index) {
          final language = languages[index];
          return ListTile(
            title: Text(
              language,
              style: GoogleFonts.quicksand(), // Apply Quicksand font
            ),
            trailing: selectedLanguage == language
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              Navigator.pop(context, language); // Pass selected language back
            },
          );
        },
      ),
    );
  }
}
