import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/custom_text_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  Future<void> _changePassword() async {
    if (_formKey.currentState!.validate()) {
      if (_newPasswordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('New passwords do not match')),
        );
        return;
      }

      setState(() => _isLoading = true);
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null && user.email != null) {
          // Re-authenticate user
          final credential = EmailAuthProvider.credential(
            email: user.email!,
            password: _currentPasswordController.text,
          );
          
          await user.reauthenticateWithCredential(credential);
          
          // Update password
          await user.updatePassword(_newPasswordController.text);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Password changed successfully')),
            );
            Navigator.pop(context);
          }
        }
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          String message = 'Error changing password';
          if (e.code == 'wrong-password') {
            message = 'Incorrect current password';
          } else if (e.code == 'weak-password') {
             message = 'New password is too weak';
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      } catch (e) {
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Change Password', style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _currentPasswordController,
                label: 'Current Password',
                hintText: 'Enter current password',
                prefixIcon: Icons.lock_outline,
                obscureText: _obscureCurrent,
                suffixIcon: IconButton(
                  icon: Icon(_obscureCurrent ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _obscureCurrent = !_obscureCurrent),
                ),
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: _newPasswordController,
                label: 'New Password',
                hintText: 'Enter new password',
                prefixIcon: Icons.lock_outline,
                obscureText: _obscureNew,
                suffixIcon: IconButton(
                  icon: Icon(_obscureNew ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _obscureNew = !_obscureNew),
                ),
                validator: (val) => val!.length < 6 ? 'Min 6 chars' : null,
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: _confirmPasswordController,
                label: 'Confirm New Password',
                hintText: 'Re-enter new password',
                prefixIcon: Icons.lock_outline,
                obscureText: _obscureConfirm,
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirm ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                ),
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              
              const SizedBox(height: 32),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _changePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E293B),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: _isLoading 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('UPDATE PASSWORD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
