import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';
import '../../services/auth_service.dart';
import '../../services/notification_service.dart';
import '../login/login_screen.dart';

/// Settings Screen
///
/// Lab 8: Navigation Drawer requirement – Home, Profile, Settings, Logout.
/// Demonstrates setState() for local UI state (dark mode toggle)
/// and Provider access for global app state.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Local UI state managed with setState()
  bool _darkModeEnabled = false;
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
            color: const Color(0xFF1E293B),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Account Card ---
                  _buildSectionLabel('Account'),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFFE2E8F0),
                            child: const Icon(Icons.person, color: Color(0xFF475569)),
                          ),
                          title: Text(
                            user?.displayName ?? 'Security Guard',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          subtitle: Text(
                            user?.email ?? 'N/A',
                            style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
                          ),
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        _buildInfoTile('User ID', user?.uid != null
                            ? '${user!.uid.substring(0, 8)}...'
                            : 'N/A', Icons.fingerprint_outlined),
                        _buildInfoTile('Account Type', 'Security Guard', Icons.badge_outlined),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --- App Preferences ---
                  _buildSectionLabel('Preferences'),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        // Dark Mode Toggle (setState - local state)
                        SwitchListTile(
                          secondary: const Icon(Icons.dark_mode_outlined, color: Color(0xFF475569)),
                          title: const Text('Dark Mode',
                              style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.w500)),
                          subtitle: const Text('Toggle app theme', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                          value: _darkModeEnabled,
                          activeThumbColor: const Color(0xFF1E293B),
                          onChanged: (val) {
                            // Lab 8: setState() for local state management
                            setState(() => _darkModeEnabled = val);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(val ? 'Dark mode enabled' : 'Light mode enabled'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        // Notifications Toggle
                        SwitchListTile(
                          secondary: const Icon(Icons.notifications_outlined, color: Color(0xFF475569)),
                          title: const Text('Notifications',
                              style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.w500)),
                          subtitle: const Text('Visitor alerts', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                          value: _notificationsEnabled,
                          activeThumbColor: const Color(0xFF1E293B),
                          onChanged: (val) => setState(() => _notificationsEnabled = val),
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        // Biometric Toggle
                        SwitchListTile(
                          secondary: const Icon(Icons.lock_outline, color: Color(0xFF475569)),
                          title: const Text('Biometric Login',
                              style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.w500)),
                          subtitle: const Text('Use fingerprint to login', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                          value: _biometricEnabled,
                          activeThumbColor: const Color(0xFF1E293B),
                          onChanged: (val) => setState(() => _biometricEnabled = val),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --- Notifications Lab Testing ---
                  _buildSectionLabel('Notifications Lab Testing'),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.notifications_active, color: Color(0xFF475569)),
                          title: const Text('Test Local Notification', style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF1E293B))),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            NotificationService().showInstantNotification(
                              'Lab 10 Local Alert', 
                              'This is your instant notification message!',
                              payload: '/dashboard'
                            );
                          },
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        ListTile(
                          leading: const Icon(Icons.schedule, color: Color(0xFF475569)),
                          title: const Text('Test Scheduled Notification', style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF1E293B))),
                          subtitle: const Text('Triggers in 5 seconds', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            NotificationService().scheduleNotification(
                              1, 
                              'Scheduled Reminder', 
                              'Your task is due now!', 
                              DateTime.now().add(const Duration(seconds: 5)),
                              payload: '/logs'
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Notification scheduled in 5 seconds')),
                            );
                          },
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        ListTile(
                          leading: const Icon(Icons.token, color: Color(0xFF475569)),
                          title: const Text('Show FCM Token', style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF1E293B))),
                          trailing: const Icon(Icons.copy),
                          onTap: () async {
                            final token = await NotificationService().getFCMToken();
                            debugPrint('FCM Token: $token');
                            if (context.mounted) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('FCM Token'),
                                  content: SelectableText(token ?? 'Failed to get token'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Close'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --- About ---
                  _buildSectionLabel('About'),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        _buildInfoTile('App Version', '1.0.0+1', Icons.info_outline),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        _buildInfoTile('Build', 'Release', Icons.build_outlined),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        _buildInfoTile('Platform', 'Flutter / Firebase', Icons.phonelink_outlined),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        // Lab 8: Logout clears global state via Provider
                        final provider = context.read<AppStateProvider>();
                        await AuthService().signOut();
                        provider.onUserLoggedOut();
                        if (context.mounted) {
                          // Lab 8: pushAndRemoveUntil – prevent back navigation to app after logout
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                            (route) => false,
                          );
                        }
                      },
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: const Text('Logout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF64748B),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF475569)),
      title: Text(label, style: const TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.w500)),
      trailing: Text(value, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
    );
  }
}
