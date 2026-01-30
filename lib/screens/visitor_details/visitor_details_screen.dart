import 'package:flutter/material.dart';
import '../../models/visitor_model.dart';
import '../../services/database_service.dart';
import '../add_visitor/add_visitor_screen.dart';

class VisitorDetailsScreen extends StatelessWidget {
  final Visitor visitor;

  const VisitorDetailsScreen({super.key, required this.visitor});

  void _deleteVisitor(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Visitor?'),
        content: const Text('Are you sure you want to delete this visitor log? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      try {
        await DatabaseService().deleteVisitor(visitor.id!);
        if (context.mounted) {
          Navigator.pop(context); // Go back to logs
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Visitor deleted successfully')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting visitor: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCheckedIn = visitor.status == 'IN';

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Visitor Details', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
               // Navigate to Edit Screen (reusing AddVisitorScreen)
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => AddVisitorScreen(visitor: visitor)),
               );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteVisitor(context),
          ),
        ],
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
                    visitor.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    visitor.phone,
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
                            visitor.status,
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

                  _buildDetailItem('Flat Number', visitor.flatNumber, isBold: true),
                  _buildDivider(),
                  _buildDetailItem('Purpose of Visit', visitor.purpose, isBold: true),
                  _buildDivider(),
                  _buildDetailItem('Check-In Time', visitor.checkInTime, isBold: true),
                  _buildDivider(),
                  if (visitor.checkOutTime != null) ...[
                    _buildDetailItem('Check-Out Time', visitor.checkOutTime!, isBold: true),
                    _buildDivider(),
                  ],
                  // _buildDetailItem('Approved By', data['approvedBy'], isBold: true), // Removed as not in model yet
                  // _buildDivider(),
                   
                  if (visitor.notes != null && visitor.notes!.isNotEmpty) ...[
                    const Text(
                      'Additional Notes',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                       visitor.notes!,
                       style: const TextStyle(
                         fontSize: 14,
                         color: Color(0xFF334155),
                         height: 1.5,
                       ),
                    ),
                  ],
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
