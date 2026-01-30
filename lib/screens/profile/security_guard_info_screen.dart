import 'package:flutter/material.dart';
import '../../widgets/custom_text_field.dart';

class SecurityGuardInfoScreen extends StatelessWidget {
  const SecurityGuardInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
     // Hardcoded data as requested
    final nameController = TextEditingController(text: 'Ramesh Kumar');
    final roleController = TextEditingController(text: 'Senior Security Guard');
    final idController = TextEditingController(text: 'SG-2024-001');
    final shiftController = TextEditingController(text: 'Day Shift (8:00 AM - 8:00 PM)');
    final gateController = TextEditingController(text: 'Main Gate A');

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Security Guard Info', style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Center(
            //   child: CircleAvatar(
            //     radius: 50,
            //     backgroundColor: const Color(0xFF1E293B).withOpacity(0.1),
            //     child: const Text('R', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            //   ),
            // ),
            // const SizedBox(height: 32),
            CustomTextField(
              controller: nameController,
              label: 'Full Name',
              hintText: '',
              prefixIcon: Icons.badge,
              readOnly: true,
            ),
            const SizedBox(height: 16),
             CustomTextField(
              controller: roleController,
              label: 'Designation',
              hintText: '',
              prefixIcon: Icons.work,
              readOnly: true,
            ),
            const SizedBox(height: 16),
             CustomTextField(
              controller: idController,
              label: 'Employee ID',
              hintText: '',
              prefixIcon: Icons.numbers,
              readOnly: true,
            ),
            const SizedBox(height: 16),
             CustomTextField(
              controller: shiftController,
              label: 'Shift Timing',
              hintText: '',
              prefixIcon: Icons.access_time,
              readOnly: true,
            ),
            const SizedBox(height: 16),
             CustomTextField(
              controller: gateController,
              label: 'Assigned Gate',
              hintText: '',
              prefixIcon: Icons.meeting_room,
              readOnly: true,
            ),
          ],
        ),
      ),
    );
  }
}
