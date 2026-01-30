import 'package:flutter/material.dart';

// --- Notification Settings ---
class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _emailNotif = true;
  bool _pushNotif = true;
  bool _smsNotif = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Email Notifications'),
            subtitle: const Text('Receive visitor details via email'),
            value: _emailNotif,
            onChanged: (val) => setState(() => _emailNotif = val),
          ),
          SwitchListTile(
            title: const Text('Push Notifications'),
            subtitle: const Text('Receive app alerts for new visitors'),
            value: _pushNotif,
            onChanged: (val) => setState(() => _pushNotif = val),
          ),
          SwitchListTile(
            title: const Text('SMS Notifications'),
            subtitle: const Text('Receive SMS for critical alerts'),
            value: _smsNotif,
            onChanged: (val) => setState(() => _smsNotif = val),
          ),
        ],
      ),
    );
  }
}

// --- Language Settings ---
class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({super.key});

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  String _selectedLanguage = 'English';
  final List<String> _languages = ['English', 'Hindi', 'Gujarati', 'Spanish', 'French'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Language')),
      body: ListView.builder(
        itemCount: _languages.length,
        itemBuilder: (context, index) {
          final lang = _languages[index];
          return RadioListTile<String>(
            title: Text(lang),
            value: lang,
            groupValue: _selectedLanguage,
            onChanged: (val) {
              setState(() => _selectedLanguage = val!);
            },
          );
        },
      ),
    );
  }
}

// --- Help & Support ---
class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'How can we help you?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ExpansionTile(
              title: const Text('How to add a visitor?'),
              children: const [Padding(padding: EdgeInsets.all(16), child: Text('Go to Dashboard > Add Visitor, fill key details, and save.'))],
            ),
            ExpansionTile(
              title: const Text('How to change password?'),
              children: const [Padding(padding: EdgeInsets.all(16), child: Text('Go to Profile > Change Password.'))],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Contact Support'),
            ),
          ],
        ),
      ),
    );
  }
}

// --- About App ---
class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About App')),
      body: Center(
        child: Padding(
           padding: const EdgeInsets.all(32),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: const [
               Icon(Icons.security, size: 64, color: Color(0xFF1E293B)),
               SizedBox(height: 24),
               Text('Digital Visitor Log', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
               SizedBox(height: 8),
               Text('Version 1.0.0', style: TextStyle(color: Colors.grey)),
               SizedBox(height: 32),
               Text('© 2026 Security Apps Inc. All rights reserved.'),
             ],
           ),
        ),
      ),
    );
  }
}
