import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/reset_password_otp_controller.dart';

class ResetPasswordOtpView extends GetView<ResetPasswordOtpController> {
  final ResetPasswordOtpController controller =
      Get.put(ResetPasswordOtpController());

  @override
  Widget build(BuildContext context) {
    final ctrl = controller;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Judul
              const Text(
                'We just sent an Email',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'NextTrial',
                ),
              ),
              const SizedBox(height: 10),

              // Instruksi dengan email
              Obx(() => Text(
                    'Enter the OTP code we sent to ${ctrl.email.value}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontFamily: 'NextTrial',
                    ),
                  )),
              const SizedBox(height: 40),

              // Row OTP (6 kotak)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (i) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: 50,
                    height: 50,
                    child: TextField(
                      controller: ctrl.fields[i],
                      focusNode: ctrl.focusNodes[i],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.green.shade700),
                        ),
                      ),
                      onChanged: (val) {
                        if (val.length == 1 && i < 5) {
                          ctrl.focusNodes[i + 1].requestFocus();
                        }
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),

              // Resend OTP + timer
              Obx(() => GestureDetector(
                    onTap: ctrl.isResendEnabled.value ? ctrl.resendCode : null,
                    child: Text(
                      "Didn't get the code? Resend it",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: ctrl.isResendEnabled.value
                            ? Colors.green.shade700
                            : Colors.grey,
                        fontFamily: 'NextTrial',
                      ),
                    ),
                  )),
              const SizedBox(height: 8),
              Obx(() => Text(
                    '${ctrl.counter.value}s',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  )),
              const SizedBox(height: 40),

              // Tombol Done
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: ctrl.submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B5E4F),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'NextTrial',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
