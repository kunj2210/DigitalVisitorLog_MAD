import 'package:flutter/material.dart';
import '../dashboard/dashboard_screen.dart';
import '../visitor_logs/visitor_logs_screen.dart';
import '../login/login_screen.dart';
import 'personal_info_screen.dart';
import 'change_password_screen.dart';
import 'settings_screens.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 2; // 'Profile' is index 2

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Log Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showFeatureNotAvailable(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature feature coming soon!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
            color: const Color(0xFF1E293B), // Dark Navy
            child: Column(
              children: [
                 Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Profile & Settings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                 ),
                 const SizedBox(height: 32),
                 // Avatar
                 CircleAvatar(
                   radius: 40,
                   backgroundColor: Colors.white.withOpacity(0.2),
                   child: const Icon(Icons.person, size: 48, color: Colors.white),
                 ),
                 const SizedBox(height: 16),
                 const Text(
                   'Ramesh Kumar',
                   style: TextStyle(
                     color: Colors.white,
                     fontSize: 22,
                     fontWeight: FontWeight.bold,
                   ),
                 ),
                 const SizedBox(height: 4),
                 Text(
                   'Security Guard',
                   style: TextStyle(
                     color: Colors.white.withOpacity(0.7),
                     fontSize: 14,
                   ),
                 ),
                 const SizedBox(height: 4),
                 Text(
                   '+91 98765 43210',
                   style: TextStyle(
                     color: Colors.white.withOpacity(0.7),
                     fontSize: 14,
                   ),
                 ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildSettingsTile(
                  icon: Icons.assignment_ind,
                  title: 'Personal Information',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PersonalInfoScreen()),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildSettingsTile(
                  icon: Icons.lock,
                  title: 'Change Password',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildSettingsTile(
                  icon: Icons.notifications_active,
                  title: 'Notification Settings',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NotificationSettingsScreen()),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildSettingsTile(
                  icon: Icons.language,
                  title: 'Language',
                  subtitle: 'English',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LanguageSettingsScreen()),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildSettingsTile(
                  icon: Icons.help,
                  title: 'Help & Support',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildSettingsTile(
                  icon: Icons.info,
                  title: 'About App',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutAppScreen()),
                    );
                  },
                ),
                const SizedBox(height: 32),
                
                // Log Out Button
                _buildSettingsTile(
                  icon: Icons.logout,
                  title: 'Log Out',
                  textColor: Colors.red,
                  iconColor: Colors.red,
                  onTap: _handleLogout,
                  hideArrow: true,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
             if (index == 0) {
               Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const DashboardScreen()),
                  (route) => false,
               );
             } else if (index == 1) {
               Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const VisitorLogsScreen()),
               );
             }
          },
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF1E293B), // Dark Navy
          unselectedItemColor: const Color(0xFF94A3B8), // Slate 400
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home_filled), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.list_alt), activeIcon: Icon(Icons.list_alt_rounded), label: 'Logs'),
            BottomNavigationBarItem(icon: Icon(Icons.person), activeIcon: Icon(Icons.person_outline), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? textColor,
    Color? iconColor,
    VoidCallback? onTap,
    bool hideArrow = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), // ListTile handles internal padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (iconColor ?? const Color(0xFF64748B)).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor ?? const Color(0xFF64748B), size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: textColor ?? const Color(0xFF1E293B),
          ),
        ),
        subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)) : null,
        trailing: hideArrow ? null : const Icon(Icons.arrow_forward, size: 16, color: Color(0xFF94A3B8)),
        onTap: onTap,
      ),
    );
  }
}
