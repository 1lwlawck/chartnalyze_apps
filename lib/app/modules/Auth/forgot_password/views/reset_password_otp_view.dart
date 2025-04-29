import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chartnalyze_apps/app/modules/Auth/forgot_password/controllers/reset_password_otp_controller.dart';

class ResetPasswordOtpView extends GetView<ResetPasswordOtpController> {
  const ResetPasswordOtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.black,
            size: 32,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
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
              Obx(() => Text(
                    'Enter the OTP code we sent to\n${controller.email.value}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontFamily: 'NextTrial',
                    ),
                    textAlign: TextAlign.center,
                  )),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: 48,
                    height: 58,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.green.shade700,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: TextField(
                        controller: controller.otpControllers[index],
                        focusNode: controller.focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLength: 1,
                        decoration: const InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            if (index < 5) {
                              Future.delayed(const Duration(milliseconds: 50),
                                  () {
                                controller.focusNodes[index + 1].requestFocus();
                              });
                            }
                          } else {
                            if (index > 0) {
                              Future.delayed(const Duration(milliseconds: 50),
                                  () {
                                controller.focusNodes[index - 1].requestFocus();
                              });
                            }
                          }

                          String code = '';
                          for (var c in controller.otpControllers) {
                            code += c.text;
                          }
                          controller.otpCode.value = code;
                        },
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: controller.isResendEnabled.value
                    ? () => controller.resendOTP()
                    : null,
                child: Obx(() => Text(
                      'Didn’t get the code? Resend it',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: controller.isResendEnabled.value
                            ? Colors.green
                            : Colors.grey,
                        fontFamily: 'NextTrial',
                      ),
                    )),
              ),
              const SizedBox(height: 10),
              Obx(() => Text(
                    '${controller.counter.value} s',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  )),
              const SizedBox(height: 40),
              Obx(() => ElevatedButton(
                    onPressed: controller.otpCode.value.length == 6
                        ? controller.submitOTP
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.otpCode.value.length == 6
                          ? const Color(0xFF0B5E4F)
                          : const Color(0xFFB0CEC8),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(double.infinity, 48),
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
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
