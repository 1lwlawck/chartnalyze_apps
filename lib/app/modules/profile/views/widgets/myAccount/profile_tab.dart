import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chartnalyze_apps/app/data/models/users/UserModel.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileTab extends StatefulWidget {
  final UserModel user;
  final TextEditingController emailController;
  final TextEditingController nameController;
  final TextEditingController usernameController;
  final TextEditingController birthController;
  final VoidCallback onUpdatePressed;
  final VoidCallback onLogoutPressed;
  final Future<void> Function() onRefresh;

  const ProfileTab({
    super.key,
    required this.user,
    required this.emailController,
    required this.nameController,
    required this.usernameController,
    required this.birthController,
    required this.onUpdatePressed,
    required this.onLogoutPressed,
    required this.onRefresh,
  });

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("User ID"),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    initial: widget.user.id,
                    readOnly: true,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, size: 20),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: widget.user.id));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Copied to clipboard")),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildLabel("Email"),
            _buildTextField(controller: widget.emailController, readOnly: true),
            const SizedBox(height: 16),
            _buildLabel("Name"),
            _buildTextField(controller: widget.nameController),
            const SizedBox(height: 16),
            _buildLabel("Username"),
            _buildTextField(controller: widget.usernameController),
            const SizedBox(height: 16),
            _buildLabel("Birthdate"),
            _buildTextField(
              controller: widget.birthController,
              hintText: "YYYY-MM-DD",
              isDateField: true,
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate:
                      DateTime.tryParse(widget.birthController.text) ??
                      DateTime(2000),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (selectedDate != null) {
                  widget.birthController.text =
                      selectedDate.toIso8601String().split(
                        'T',
                      )[0]; // Format: YYYY-MM-DD
                }
              },
            ),

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: widget.onUpdatePressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Update Profile",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton.icon(
                key: const Key('logoutButton'),
                onPressed: () => widget.onLogoutPressed(),
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildTextField({
    TextEditingController? controller,
    String? initial,
    bool readOnly = false,
    String? hintText,
    bool isDateField = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initial : null,
      readOnly: readOnly || isDateField,
      onTap: isDateField ? onTap : null,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon:
            isDateField ? const Icon(Icons.calendar_today, size: 20) : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        filled: true,
        fillColor:
            readOnly || isDateField ? Colors.grey.shade200 : Colors.white,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFDADADA)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      style: GoogleFonts.aBeeZee(fontSize: 14),
    );
  }
}
