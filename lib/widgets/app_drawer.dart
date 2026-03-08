import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../services/auth_service.dart';
import '../screens/login/login_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/visitor_logs/visitor_logs_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/settings/settings_screen.dart';

/// Navigation Drawer
///
/// Lab 8 Step 2: Navigation Drawer with:
///   Home | Visitor Logs | Profile | Settings | Logout
///
/// Logout uses pushAndRemoveUntil to prevent returning to the app via back.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: Column(
        children: [
          // Drawer Header with user info from Firebase Auth
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF1E293B),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Color(0xFF1E293B), size: 30),
            ),
            accountName: Text(
              user?.displayName ?? 'Security Guard',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            accountEmail: Text(
              user?.email ?? 'guard@example.com',
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),

          // Home
          ListTile(
            leading: const Icon(Icons.home_outlined, color: Color(0xFF334155)),
            title: const Text('Home', style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.w500)),
            onTap: () {
              Navigator.pop(context); // Close drawer
              // Lab 8: Push-replace to keep navigation stack clean
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const DashboardScreen()),
                (route) => false,
              );
            },
          ),

          // Visitor Logs
          ListTile(
            leading: const Icon(Icons.list_alt_rounded, color: Color(0xFF334155)),
            title: const Text('Visitor Logs', style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.w500)),
            onTap: () {
              Navigator.pop(context);
              // Lab 8: Push navigation – user can go back to Dashboard
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VisitorLogsScreen()),
              );
            },
          ),

          // Profile
          ListTile(
            leading: const Icon(Icons.person_outline, color: Color(0xFF334155)),
            title: const Text('Profile', style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.w500)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),

          // Settings (NEW – Lab 8 requirement)
          ListTile(
            leading: const Icon(Icons.settings_outlined, color: Color(0xFF334155)),
            title: const Text('Settings', style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.w500)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),

          const Divider(),

          // Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
            onTap: () async {
              Navigator.pop(context);
              // Lab 8: Notify Provider to clear state before navigating
              final provider = context.read<AppStateProvider>();
              await AuthService().signOut();
              provider.onUserLoggedOut();
              if (context.mounted) {
                // Lab 8: pushAndRemoveUntil – back button will NOT return to Dashboard
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
