import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/storage_service.dart';
import '../../widgets/custom_text_field.dart';
import '../../models/visitor_model.dart';
import '../../services/database_service.dart';

class AddVisitorScreen extends StatefulWidget {
  final Visitor? visitor;

  const AddVisitorScreen({super.key, this.visitor});

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
  final _vehicleNoController = TextEditingController();
  bool _hasVehicle = false;
  bool _agreedToTerms = false;
  String? _selectedPurpose;
  
  // Photo Upload related
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  String? _existingImageUrl;

  final List<String> _visitPurposes = [
    'Delivery',
    'Personal',
    'Service',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.visitor != null) {
      _nameController.text = widget.visitor!.name;
      _phoneController.text = widget.visitor!.phone;
      _flatController.text = widget.visitor!.flatNumber;
      _checkInController.text = widget.visitor!.checkInTime;
      _existingImageUrl = widget.visitor!.imageUrl;
      if (widget.visitor!.checkOutTime != null) {
        _checkOutController.text = widget.visitor!.checkOutTime!;
      }
      if (widget.visitor!.notes != null) {
        _notesController.text = widget.visitor!.notes!;
      }
      if (_visitPurposes.contains(widget.visitor!.purpose)) {
        _selectedPurpose = widget.visitor!.purpose;
      } else {
        _selectedPurpose = 'Other'; 
      }
      _hasVehicle = widget.visitor!.hasVehicle;
      if (widget.visitor!.vehicleNumber != null) {
        _vehicleNoController.text = widget.visitor!.vehicleNumber!;
      }
    } else {
      _checkInController.text = _formatTime(TimeOfDay.now());
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _flatController.dispose();
    _checkInController.dispose();
    _checkOutController.dispose();
    _notesController.dispose();
    _vehicleNoController.dispose();
    super.dispose();
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
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

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleSubmit() async {
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please verify the details and check the box.')),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isUploading = true;
      });

      String? imageUrl = _existingImageUrl;

      try {
        if (_imageFile != null) {
          final String tempId = DateTime.now().millisecondsSinceEpoch.toString();
          imageUrl = await StorageService().uploadVisitorPhoto(_imageFile!, tempId);
        if (!mounted) return;
        }

        final visitorData = Visitor(
          id: widget.visitor?.id,
          name: _nameController.text,
          phone: _phoneController.text,
          flatNumber: _flatController.text,
          purpose: _selectedPurpose!,
          checkInTime: _checkInController.text,
          checkOutTime: _checkOutController.text.isNotEmpty ? _checkOutController.text : null,
          notes: _notesController.text.isNotEmpty ? _notesController.text : null,
          status: widget.visitor?.status ?? 'IN',
          createdAt: widget.visitor?.createdAt ?? DateTime.now(),
          hasVehicle: _hasVehicle,
          vehicleNumber: _hasVehicle ? _vehicleNoController.text : null,
          imageUrl: imageUrl,
        );

        if (!mounted) return;
        final messenger = ScaffoldMessenger.of(context);
        final navigator = Navigator.of(context);

        if (widget.visitor == null) {
          await DatabaseService().addVisitor(visitorData);
          messenger.showSnackBar(
            const SnackBar(content: Text('Visitor Added Successfully!')),
          );
        } else {
          await DatabaseService().updateVisitor(visitorData);
          messenger.showSnackBar(
            const SnackBar(content: Text('Visitor Updated Successfully!')),
          );
        }
        
        navigator.pop();
      } catch (e) {
        if (mounted) {
          setState(() {
            _isUploading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.visitor == null ? 'Add Visitor' : 'Edit Visitor',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1E293B),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: _isUploading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
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
              const Text(
                'Purpose of Visit *',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _selectedPurpose,
                items: _visitPurposes.map((purpose) {
                  return DropdownMenuItem(value: purpose, child: Text(purpose));
                }).toList(),
                onChanged: (val) => setState(() => _selectedPurpose = val),
                 decoration: InputDecoration(
                  hintText: 'Select purpose',
                  hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                  filled: true,
                  fillColor: const Color(0xFFF1F5F9),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
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
              const Text(
                'Additional Notes',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
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
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Has Vehicle?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
                value: _hasVehicle,
                onChanged: (bool value) => setState(() => _hasVehicle = value),
                // ignore: deprecated_member_use
                activeColor: const Color(0xFF1E293B),
              ),
              if (_hasVehicle) ...[
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _vehicleNoController,
                  label: 'Vehicle Number',
                  hintText: 'e.g. GJ-01-AB-1234',
                  validator: (val) => _hasVehicle && (val == null || val.isEmpty) ? 'Required' : null,
                ),
              ],
              const SizedBox(height: 16),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text('I verify that the above information is correct and the ID proof has been checked.', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                value: _agreedToTerms,
                onChanged: (bool? value) => setState(() => _agreedToTerms = value ?? false),
                // ignore: deprecated_member_use
                activeColor: const Color(0xFF1E293B),
              ),
              const SizedBox(height: 16),
              const Text('Visitor Photo (Optional)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _showImageSourceActionSheet(context),
                child: Container(
                  width: double.infinity,
                  height: 160,
                  decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE2E8F0))),
                  child: _imageFile != null
                      ? ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(_imageFile!, fit: BoxFit.cover))
                      : (_existingImageUrl != null
                          ? ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(_existingImageUrl!, fit: BoxFit.cover))
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.camera_alt_outlined, color: Color(0xFF94A3B8), size: 32),
                                SizedBox(height: 8),
                                Text('Tap to take photo', style: TextStyle(color: Color(0xFF64748B))),
                              ],
                            )),
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
                  child: Text(widget.visitor == null ? 'ADD VISITOR' : 'UPDATE VISITOR', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
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
