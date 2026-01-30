import 'package:flutter/material.dart';
import '../dashboard/dashboard_screen.dart';
import '../visitor_logs/visitor_logs_screen.dart';
import '../login/login_screen.dart';
import 'personal_info_screen.dart';
import 'change_password_screen.dart';
import 'settings_screens.dart';
import 'security_guard_info_screen.dart';
import '../../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

// ... (existing imports, but make sure to not duplicate)

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 2; // 'Profile' is index 2
  Map<String, dynamic>? _userData;
  User? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    setState(() => _currentUser = user);

    if (user != null) {
      try {
        final data = await AuthService().getCurrentUserData();
        if (mounted) {
          setState(() {
            _userData = data;
            _isLoading = false;
          });
        }
      } catch (e) {
        debugPrint('Error fetching profile: $e');
        if (mounted) setState(() => _isLoading = false);
      }
    } else {
       if (mounted) setState(() => _isLoading = false);
    }
  }

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
    // Logic to determine display name
    // Prefer Firestore 'name', then Auth 'displayName', then 'User'
    final displayName = _userData?['name'] ?? _currentUser?.displayName ?? 'User';
    final displayEmail = _userData?['email'] ?? _currentUser?.email ?? 'No Email';
    // Role from firestore, default to 'Security Guard' if not present or just 'User'
    // Since we save 'role': 'user' in signup, checking that. 
    // If it is 'user', let's display 'Staff Member' or 'Resident' to look better than just 'user'.
    String displayRole = _userData?['role'] == 'user' ? 'Staff Member' : 'Security Guard';
    
    // Check if we have dynamic role
    if (_userData != null && _userData!.containsKey('role')) {
       final r = _userData!['role'].toString();
       if (r.toLowerCase() == 'admin') displayRole = 'Administrator';
       else if (r.toLowerCase() == 'guard') displayRole = 'Security Guard';
    }

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
                   radius: 50,
                   backgroundColor: Colors.white.withOpacity(0.2),
                   child: Text(
                     displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U',
                     style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                   ),
                 ),
                 const SizedBox(height: 16),
              ],
            ),
          ),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildSettingsTile(
                  icon: Icons.assignment_ind,
                  title: 'Personal Information', // Restored
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PersonalInfoScreen()),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildSettingsTile(
                  icon: Icons.security,
                  title: 'Security Guard Info',
                  onTap: () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SecurityGuardInfoScreen()),
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
