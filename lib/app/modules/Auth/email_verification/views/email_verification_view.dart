import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/constants/fonts.dart';
import 'package:chartnalyze_apps/app/constants/strings.dart';
import '../controllers/email_verification_controller.dart';

class EmailVerificationView extends GetView<EmailVerificationController> {
  const EmailVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final focusNodes = List.generate(6, (_) => FocusNode());
    final textControllers = List.generate(6, (_) => TextEditingController());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
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
              Text(
                'Enter the OTP code sent to ${controller.email}',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.primaryGreen,
                  fontFamily: AppFonts.circularStd,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 48,
                      height: 58,
                      child: TextField(
                        controller: textControllers[index],
                        focusNode: focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(
                                color: AppColors.primaryGreen, width: 1.5),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 5) {
                            focusNodes[index + 1].requestFocus();
                          }
                          _updateOtpCode(textControllers, controller);
                        },
                        onSubmitted: (_) =>
                            _updateOtpCode(textControllers, controller),
                        onEditingComplete: () =>
                            _updateOtpCode(textControllers, controller),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: controller.isResendEnabled.value
                    ? controller.resendOTP
                    : null,
                child: Obx(() => Text(
                      AppStrings.resendOtp,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: controller.isResendEnabled.value
                            ? AppColors.primaryGreen
                            : AppColors.grey,
                        fontFamily: AppFonts.nextTrial,
                      ),
                    )),
              ),
              const SizedBox(height: 10),
              Obx(() => Text(
                    '${controller.counter.value}s',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.grey,
                    ),
                  )),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: controller.submitOTP,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
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
                    fontFamily: AppFonts.nextTrial,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateOtpCode(List<TextEditingController> controllers,
      EmailVerificationController ctrl) {
    ctrl.otpCode.value = controllers.map((c) => c.text).join();
  }
}
