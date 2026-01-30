import 'package:flutter/material.dart';
import '../../widgets/custom_text_field.dart';

class AddVisitorScreen extends StatefulWidget {
  const AddVisitorScreen({super.key});

  @override
  State<AddVisitorScreen> createState() => _AddVisitorScreenState();
}

class _AddVisitorScreenState extends State<AddVisitorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _flatController = TextEditingController();
  final _checkInController = TextEditingController();
  final _checkOutController = TextEditingController();
  final _notesController = TextEditingController();
  String? _selectedPurpose;

  final List<String> _visitPurposes = [
    'Delivery',
    'Personal',
    'Service',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    // Set default check-in time to now
    _checkInController.text = _formatTime(TimeOfDay.now());
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    // Simple manual formatting to avoid intl dependency for now
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  Future<void> _selectTime(TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1E293B), // Dark Navy
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E293B),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        controller.text = _formatTime(picked);
      });
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      // Create visitor logic here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Visitor Added Successfully!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Add Visitor',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1E293B), // Dark Navy
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: _nameController,
                label: 'Visitor Name *',
                hintText: 'Enter visitor name',
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: _phoneController,
                label: 'Phone Number *',
                hintText: 'Enter phone number',
                keyboardType: TextInputType.phone,
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              
              // Custom Dropdown for Purpose
              const Text(
                'Purpose of Visit *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF334155),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedPurpose,
                items: _visitPurposes.map((purpose) {
                  return DropdownMenuItem(value: purpose, child: Text(purpose));
                }).toList(),
                onChanged: (val) => setState(() => _selectedPurpose = val),
                 decoration: InputDecoration(
                  hintText: 'Select purpose',
                  hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                  filled: true,
                  fillColor: const Color(0xFFF1F5F9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                validator: (val) => val == null ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _flatController,
                label: 'Flat Number *',
                hintText: 'e.g. 101',
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _checkInController,
                label: 'Check-In Time *',
                hintText: 'Select time',
                readOnly: true,
                suffixIcon: const Icon(Icons.access_time, color: Color(0xFF64748B)),
                onTap: () => _selectTime(_checkInController),
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _checkOutController,
                label: 'Expected Check-Out Time',
                hintText: 'Select time (Optional)',
                readOnly: true,
                suffixIcon: const Icon(Icons.access_time, color: Color(0xFF64748B)),
                onTap: () => _selectTime(_checkOutController),
              ),
              const SizedBox(height: 16),

               // Additional Notes (TextArea)
               // Reusing CustomTextField but we need maxLines support. 
               // Since CustomTextField doesn't have maxLines yet, I'll update it or just standard TextForm here.
               // Let's use standard TextFormField for now for the TextArea to allow multiline.
              const Text(
                'Additional Notes',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF334155),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Enter any additional details...',
                  hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                  filled: true,
                  fillColor: const Color(0xFFF1F5F9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
              const SizedBox(height: 16),

              // Visitor Photo (Optional)
              const Text(
                'Visitor Photo (Optional)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF334155),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E8F0)), // Default is solid
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                     Icon(Icons.camera_alt_outlined, color: Color(0xFF94A3B8), size: 32),
                     SizedBox(height: 8),
                     Text('Tap to take photo', style: TextStyle(color: Color(0xFF64748B))),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E293B),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('ADD VISITOR', style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
