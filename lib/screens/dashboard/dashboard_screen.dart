import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/action_card.dart';
import '../../widgets/app_drawer.dart';
import '../../models/visitor_model.dart';
import '../add_visitor/add_visitor_screen.dart';
import '../visitor_logs/visitor_logs_screen.dart';
import '../profile/profile_screen.dart';
import '../notifications/notifications_screen.dart';
import '../visitor_details/visitor_details_screen.dart';
import '../api_data/api_data_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Lab 8: Consumer rebuilds this widget automatically when AppStateProvider
    // calls notifyListeners() (e.g. when a visitor is added/edited/deleted)
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        final user = FirebaseAuth.instance.currentUser;
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: const Color(0xFFF1F5F9),
          drawer: const AppDrawer(),
          body: Column(
            children: [
              // ── Header ──────────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
                color: const Color(0xFF1E293B),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white),
                          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Dashboard',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Lab 8: Live user name from Firebase Auth / Provider
                            Text(
                              'Welcome, ${user?.displayName ?? 'Security Guard'}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                      ),
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.notifications_outlined, color: Colors.amber, size: 24),
                          ),
                          const Positioned(
                            right: 12,
                            top: 10,
                            child: CircleAvatar(radius: 4, backgroundColor: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── Content ─────────────────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Quick Actions',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF334155),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Row 1: Add Visitor & QR Scan
                      Row(
                        children: [
                          Expanded(
                            child: ActionCard(
                              icon: Icons.add,
                              label: 'Add Visitor',
                              onTap: () {
                                // Lab 8: Pass data – no data needed here (new visitor)
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const AddVisitorScreen()),
                                );
                              },
                              isPrimary: false,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ActionCard(
                              icon: Icons.cloud_download_outlined,
                              label: 'API Data',
                              onTap: () {
                                Navigator.pushNamed(context, '/api-data');
                              },
                              isPrimary: false,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Row 2: View All Logs (Wide)
                      SizedBox(
                        width: double.infinity,
                        child: Material(
                          color: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Color(0xFFE2E8F0)),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: InkWell(
                            onTap: () {
                              // Lab 8: Push navigation to Visitor Logs screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const VisitorLogsScreen()),
                              );
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEFF6FF),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.assignment_outlined, color: Color(0xFF3B82F6)),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'View All Logs',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // Lab 8: Live total count from Provider
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1E293B),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${appState.totalVisitors}',
                                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── Today's Summary (Live from Provider) ─────────────
                      const Text(
                        "Today's Summary",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF334155),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: appState.isLoading
                            ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  // Lab 8: Live stats from AppStateProvider (notifyListeners drives this)
                                  _buildStatItem('${appState.todayTotal}', 'Total Visitors'),
                                  Container(width: 1, height: 40, color: const Color(0xFFE2E8F0)),
                                  _buildStatItem('${appState.todayCheckIns}', 'Check-ins'),
                                  Container(width: 1, height: 40, color: const Color(0xFFE2E8F0)),
                                  _buildStatItem('${appState.todayCheckOuts}', 'Check-outs'),
                                ],
                              ),
                      ),

                      const SizedBox(height: 24),

                      // ── Recent Visitors (Live from Provider) ─────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Recent Visitors',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF334155),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const VisitorLogsScreen()),
                            ),
                            child: const Text('View All', style: TextStyle(color: Color(0xFF64748B))),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Lab 8: Live recent visitors – updates via Provider stream
                      if (appState.isLoading)
                        const Center(child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ))
                      else if (appState.recentVisitors.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: const Center(
                            child: Text(
                              'No visitors yet.\nTap "Add Visitor" to get started!',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Color(0xFF64748B)),
                            ),
                          ),
                        )
                      else
                        ...appState.recentVisitors.map(
                          (visitor) => _buildVisitorCard(context, visitor),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── Bottom Navigation Bar ────────────────────────────────────────
          // Lab 8: Bottom Navigation with 3 tabs
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (index) {
                if (index == 1) {
                  // Lab 8: Push navigation (user can come back)
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const VisitorLogsScreen()),
                  );
                } else if (index == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                } else {
                  setState(() => _selectedIndex = index);
                }
              },
              backgroundColor: Colors.white,
              selectedItemColor: const Color(0xFF1E293B),
              unselectedItemColor: const Color(0xFF94A3B8),
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.list_alt_rounded), label: 'Logs'),
                BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
        ),
      ],
    );
  }

  /// Lab 8: Tapping a visitor card navigates to VisitorDetailsScreen and passes the Visitor object.
  Widget _buildVisitorCard(BuildContext context, Visitor visitor) {
    return GestureDetector(
      onTap: () {
        // Lab 8: Pass data between screens – Visitor object passed to Detail screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VisitorDetailsScreen(visitor: visitor),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Color(0xFFF1F5F9),
              radius: 24,
              child: Icon(Icons.person, color: Color(0xFF94A3B8)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    visitor.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Flat ${visitor.flatNumber} • ${visitor.checkInTime}',
                    style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: visitor.status == 'IN'
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                visitor.status,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: visitor.status == 'IN' ? Colors.white : const Color(0xFF64748B),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
