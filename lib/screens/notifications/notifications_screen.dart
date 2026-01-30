import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _notifications = [
    {
      'type': 'alert',
      'title': 'Visitor Arrived',
      'body': 'John Doe arrived for Flat 101',
      'time': '2 min ago',
      'isUnread': true,
      'icon': Icons.waving_hand,
      'iconColor': Colors.amber,
    },
    {
      'type': 'action',
      'title': 'Approval Pending',
      'body': 'Visitor waiting for approval at Flat 205',
      'time': '15 min ago',
      'isUnread': true,
      'icon': Icons.access_alarm,
      'iconColor': Colors.redAccent,
    },
    {
      'type': 'alert',
      'title': 'Visitor Checked Out',
      'body': 'Jane Smith checked out from Flat 302',
      'time': '1 hour ago',
      'isUnread': false,
      'icon': Icons.check_circle,
      'iconColor': Colors.green, // Greyed in mockup but green usually good for check out, stick to mockup style -> grey circle
    },
    {
      'type': 'action',
      'title': 'Approval Required',
      'body': 'Delivery person waiting at Flat 108',
      'time': '2 hours ago',
      'isUnread': true,
      'icon': Icons.access_alarm,
      'iconColor': Colors.redAccent,
    },
    {
      'type': 'alert',
      'title': 'Visitor Arrived',
      'body': 'Sarah Williams arrived for Flat 410',
      'time': '3 hours ago',
      'isUnread': false,
      'icon': Icons.waving_hand,
      'iconColor': Colors.amber,
    },
  ];

  void _markAllRead() {
    setState(() {
      for (var notification in _notifications) {
        notification['isUnread'] = false;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications marked as read')),
    );
  }

  void _approveVisitor(int index) {
    setState(() {
      _notifications[index]['type'] = 'alert'; // Change from action to alert
      _notifications[index]['body'] += ' (Approved)';
      _notifications[index]['icon'] = Icons.check_circle;
      _notifications[index]['iconColor'] = Colors.green;
      _notifications[index]['isUnread'] = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Visitor Approved successfully')),
    );
  }

  void _rejectVisitor(int index) {
    setState(() {
      _notifications[index]['type'] = 'alert'; // Change from action to alert
      _notifications[index]['body'] += ' (Rejected)';
      _notifications[index]['icon'] = Icons.cancel;
      _notifications[index]['iconColor'] = Colors.red;
       _notifications[index]['isUnread'] = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(content: Text('Visitor Rejected')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Notifications', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B), // Dark Navy
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: GestureDetector(
                onTap: _markAllRead,
                child: const Text('Mark All Read', style: TextStyle(color: Colors.white, decoration: TextDecoration.underline)),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Tabs (Custom)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            color: Colors.white,
            child: Row(
              children: [
                _buildFilterButton('All (${_notifications.length})', 'All'),
                const SizedBox(width: 12),
                _buildFilterButton('Unread (${_notifications.where((n) => n['isUnread']).length})', 'Unread'),
              ],
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notif = _notifications[index];
                if (_selectedFilter == 'Unread' && !notif['isUnread']) {
                  return const SizedBox.shrink();
                }
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(notif['icon'], color: notif['iconColor'], size: 20),
                      ),
                      const SizedBox(width: 16),
                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  notif['title'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                                if (notif['isUnread'])
                                  Container(
                                    width: 8, 
                                    height: 8, 
                                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              notif['body'],
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF475569),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              notif['time'],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                            
                            // Action Buttons
                            if (notif['type'] == 'action') ...[
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () => _approveVisitor(index),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF1E293B),
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                    ),
                                    child: const Text('APPROVE', style: TextStyle(fontSize: 12, color: Colors.white)),
                                  ),
                                  const SizedBox(width: 12),
                                  OutlinedButton(
                                    onPressed: () => _rejectVisitor(index),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                                    ),
                                    child: const Text('REJECT', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label, String value) {
    bool isSelected = _selectedFilter == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF64748B),
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
