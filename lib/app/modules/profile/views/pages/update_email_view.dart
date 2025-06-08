import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/modules/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class UpdateEmailView extends StatefulWidget {
  const UpdateEmailView({super.key});

  @override
  State<UpdateEmailView> createState() => _UpdateEmailViewState();
}

class _UpdateEmailViewState extends State<UpdateEmailView> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.find<ProfileController>();

  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final FocusNode otpFocusNode = FocusNode();

  bool _isSubmitting = false;

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      final success = await controller.updateSelfEmail(
        email: emailController.text.trim(),
        code: otpController.text.trim(),
      );

      setState(() => _isSubmitting = false);

      if (success) {
        emailController.clear();
        otpController.clear();
      }
    }
  }

  Future<void> _sendOtp() async {
    final email = emailController.text.trim();
    if (email.isEmpty || !email.contains("@")) {
      Get.snackbar("Error", "Please enter a valid email");
      return;
    }

    final sent = await controller.sendOtpToEmail(email);
    if (sent) {
      FocusScope.of(context).requestFocus(otpFocusNode);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    otpController.dispose();
    otpFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: Container(
                height: 180,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/bg-appbar.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: const Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            "Change Email",
                            style: GoogleFonts.poppins(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Enter your new email and the OTP sent to it",
                      style: GoogleFonts.newsreader(
                        fontSize: 17,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "New Email",
                  suffixIcon: Obx(
                    () => TextButton(
                      onPressed: controller.canResendOtp ? _sendOtp : null,
                      child: Text(
                        controller.canResendOtp
                            ? "Send OTP"
                            : "Resend in ${controller.resendSecondsRemaining.value}s",
                        style: TextStyle(
                          color:
                              controller.canResendOtp
                                  ? AppColors.primaryGreen
                                  : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
                validator: (value) {
                  if (value == null || !value.contains("@")) {
                    return "Enter a valid email";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: otpController,
                focusNode: otpFocusNode,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "OTP Code",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter the OTP";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _submit,
                icon: const Icon(
                  Icons.email_outlined,
                  size: 20,
                  color: Colors.white,
                ),
                label: Text(
                  _isSubmitting ? "Updating..." : "Update Email",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  backgroundColor: AppColors.primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
