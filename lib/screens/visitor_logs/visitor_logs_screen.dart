import 'package:flutter/material.dart';
import '../dashboard/dashboard_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../visitor_details/visitor_details_screen.dart';
import '../profile/profile_screen.dart';

class VisitorLogsScreen extends StatefulWidget {
  const VisitorLogsScreen({super.key});

  @override
  State<VisitorLogsScreen> createState() => _VisitorLogsScreenState();
}

class _VisitorLogsScreenState extends State<VisitorLogsScreen> {
  int _selectedIndex = 1; // 'Logs' is index 1
  String _selectedFilter = 'All';
  String _sortOrder = 'Newest First';
  DateTime _selectedDate = DateTime.now();

  List<Map<String, dynamic>> _logs = [
    {'name': 'John Doe', 'flat': '101', 'time': '10:30 AM', 'status': 'IN'},
    {'name': 'Jane Smith', 'flat': '205', 'time': '09:45 AM', 'status': 'OUT'},
    {'name': 'Mike Johnson', 'flat': '302', 'time': '11:15 AM', 'status': 'IN'},
    {'name': 'Sarah Williams', 'flat': '108', 'time': '08:30 AM', 'status': 'OUT'},
    {'name': 'David Brown', 'flat': '410', 'time': '12:00 PM', 'status': 'IN'},
    {'name': 'Emily Davis', 'flat': '156', 'time': '01:45 PM', 'status': 'IN'},
  ];

  String _formatDate(DateTime date) {
    // Simple formatter to avoid intl dependency
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2025),
      lastDate: DateTime(2027),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1E293B),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E293B),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showSettingsModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Log Settings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Sort By',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 12),
              _buildSortOption('Newest First'),
              _buildSortOption('Oldest First'),
              _buildSortOption('Name (A-Z)'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortOption(String title) {
    final isSelected = _sortOrder == title;
    return InkWell(
      onTap: () {
        setState(() {
          _sortOrder = title;
          if (title == 'Name (A-Z)') {
             _logs.sort((a, b) => (a['name'] as String).compareTo(b['name'] as String));
          } else {
             // For mock data, just reverse to toggle between Newest/Oldest
             // assuming initial state is Newest.
             // Ideally we parse time, but this suffices for demo.
             _logs = _logs.reversed.toList();
          }
        });
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? const Color(0xFF1E293B) : const Color(0xFF94A3B8),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? const Color(0xFF1E293B) : const Color(0xFF334155),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // Light bg
      body: Column(
        children: [
          // Custom Header
          Container(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
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
                      'Visitor Logs',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.search, color: Colors.blueAccent, size: 20),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: _showSettingsModal,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.settings, color: Colors.white70, size: 20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Search Bar
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'search by name, flat, phone...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 20),
                // Filters
                Row(
                  children: [
                    _buildFilterTab('All'),
                    const SizedBox(width: 12),
                    _buildFilterTab('Check-In'),
                    const SizedBox(width: 12),
                    _buildFilterTab('Check-Out'),
                  ],
                ),
              ],
            ),
          ),
          
          // Date Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today - ${_formatDate(_selectedDate)}', // Use dynamic date
                  style: const TextStyle(
                    color: Color(0xFF475569),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: const Text(
                        'Change',
                        style: TextStyle(
                          color: Color(0xFF334155),
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                         color: const Color(0xFF1E293B),
                         borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: const [
                           Icon(Icons.download, color: Colors.white, size: 14),
                           SizedBox(width: 4),
                           Text('Export', style: TextStyle(color: Colors.white, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // List List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _logs.length,
              itemBuilder: (context, index) {
                final log = _logs[index];
                if (_selectedFilter != 'All' && 
                    ((_selectedFilter == 'Check-In' && log['status'] != 'IN') ||
                     (_selectedFilter == 'Check-Out' && log['status'] != 'OUT'))) {
                  return const SizedBox.shrink();
                }
                
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VisitorDetailsScreen(visitorData: log),
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
                      CircleAvatar(
                        backgroundColor: const Color(0xFFF1F5F9),
                        radius: 24,
                        child: const Icon(Icons.person, color: Color(0xFF94A3B8)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              log['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Flat ${log['flat']} • ${log['time']}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: log['status'] == 'IN' ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          log['status'],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: log['status'] == 'IN' ? Colors.white : const Color(0xFF1E293B),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ),
                );
              },
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
             } else if (index == 2) {
               Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
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
            BottomNavigationBarItem(icon: Icon(Icons.list_alt_rounded), label: 'Logs'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTab(String title) {
    bool isSelected = _selectedFilter == title;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? const Color(0xFF1E293B) : Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
