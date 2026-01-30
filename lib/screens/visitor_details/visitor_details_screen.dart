import 'package:flutter/material.dart';

class VisitorDetailsScreen extends StatelessWidget {
  final Map<String, dynamic>? visitorData;

  const VisitorDetailsScreen({super.key, this.visitorData});

  @override
  Widget build(BuildContext context) {
    // Mock data if none provided
    final data = visitorData ?? {
      'name': 'John Doe',
      'phone': '+91 98765 43210',
      'flat': '101',
      'purpose': 'Personal Visit',
      'checkIn': '10:30 AM, Jan 29, 2026',
      'checkOut': '02:00 PM, Jan 29, 2026',
      'approvedBy': 'Resident - Mr. Kumar',
      'notes': 'Family member visiting for lunch. Expected to stay for 3-4 hours.',
      'status': 'CHECKED IN',
    };

    final isCheckedIn = data['status'] == 'CHECKED IN' || data['status'] == 'IN';

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Visitor Details', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Section with Avatar
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color(0xFFE2E8F0),
                    child: const Icon(Icons.person, size: 48, color: Color(0xFF475569)),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    data['name'],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data['phone'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            
            // Details Card
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Row
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Current Status',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 14,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isCheckedIn ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0), // Navy or Grey
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            data['status'],
                            style: TextStyle(
                              color: isCheckedIn ? Colors.white : const Color(0xFF64748B),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildDetailItem('Flat Number', data['flat'], isBold: true),
                  _buildDivider(),
                  _buildDetailItem('Purpose of Visit', data['purpose'], isBold: true),
                  _buildDivider(),
                  _buildDetailItem('Check-In Time', data['checkIn'], isBold: true),
                  _buildDivider(),
                  _buildDetailItem('Expected Check-Out', data['checkOut'], isBold: true),
                  _buildDivider(),
                  _buildDetailItem('Approved By', data['approvedBy'], isBold: true),
                  _buildDivider(),
                   
                  const Text(
                    'Additional Notes',
                    style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                     data['notes'],
                     style: const TextStyle(
                       fontSize: 14,
                       color: Color(0xFF334155),
                       height: 1.5,
                     ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, {bool isBold = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: const Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      height: 1,
      color: const Color(0xFFE2E8F0),
    );
  }
}
