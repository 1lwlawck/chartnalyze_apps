import 'package:chartnalyze_apps/app/modules/Auth/forgot_password/controllers/forgot_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/constants/fonts.dart';
import 'package:chartnalyze_apps/app/constants/strings.dart';

class ResetPasswordOtpView extends GetView<ForgotPasswordController> {
  const ResetPasswordOtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: AppColors.primaryGreen,
            size: 40,
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
                AppStrings.otpTitle,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                  fontFamily: AppFonts.nextTrial,
                ),
              ),
              const SizedBox(height: 10),
              Obx(
                () => Text(
                  'Enter the OTP code we sent to\n${controller.email.value}',
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.primaryGreen,
                    fontFamily: AppFonts.circularStd,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
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
                        color: AppColors.primaryGreen,
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
                          controller.handleOtpInput(value, index);
                        },
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),
              Obx(
                () => GestureDetector(
                  onTap:
                      controller.isResendEnabled.value
                          ? controller.resendOTP
                          : null,
                  child: Text(
                    AppStrings.resendOtp,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color:
                          controller.isResendEnabled.value
                              ? AppColors.primaryGreen
                              : AppColors.grey,
                      fontFamily: AppFonts.nextTrial,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Obx(
                () => Text(
                  '${controller.counter.value} s',
                  style: const TextStyle(fontSize: 14, color: AppColors.grey),
                ),
              ),
              const SizedBox(height: 40),
              Obx(
                () => ElevatedButton(
                  onPressed:
                      controller.otpCode.value.length == 6
                          ? controller.verifyOTPAndProceed
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        controller.otpCode.value.length == 6
                            ? AppColors.primaryGreen
                            : AppColors.primaryGreen.withOpacity(0.4),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text(
                    AppStrings.continueText,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.nextTrial,
                    ),
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
