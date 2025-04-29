import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/email_verification_controller.dart'; // Import the controller

class EmailVerificationView extends GetView<EmailVerificationController> {
  final EmailVerificationController controller =
      Get.put(EmailVerificationController()); // Initialize controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () {
            // Go back action
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Center the items
            children: [
              SizedBox(height: 40),

              // OTP Title
              Text(
                'We just sent an Email',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'NextTrial', // Font "Next Trial"
                ),
              ),
              SizedBox(height: 10),

              // Instructions
              Obx(() => Text(
                    'Enter the OTP code we sent to ${controller.email.value}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontFamily: 'NextTrial', // Font "Next Trial"
                    ),
                    textAlign: TextAlign.center,
                  )),
              SizedBox(height: 40),

              // OTP Fields (6 TextFields)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    width: 50,
                    height: 50,
                    child: TextField(
                      onChanged: (value) {
                        if (value.length == 1) {
                          controller.otpCode.value =
                              controller.otpCode.value.substring(0, index) +
                                  value +
                                  controller.otpCode.value.substring(index + 1);
                          if (index < 5) {
                            FocusScope.of(context)
                                .nextFocus(); // Move to the next field
                          }
                        }
                      },
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        counterText: "",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey.shade200,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green.shade700),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 30),

              // Resend OTP Text with Timer
              GestureDetector(
                onTap: controller.isResendEnabled.value
                    ? () {
                        // Handle OTP resend
                        controller.resendOTP();
                      }
                    : null,
                child: Text(
                  'Didn’t get the code? Resend it',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: controller.isResendEnabled.value
                        ? Colors.green
                        : Colors.grey,
                    fontFamily: 'NextTrial', // Font "Next Trial"
                  ),
                ),
              ),
              SizedBox(height: 10),

              // Timer countdown
              Obx(() => Text(
                    '${controller.counter.value} s',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  )),
              SizedBox(height: 40),

              // Done Button
              ElevatedButton(
                onPressed: () {
                  controller.submitOTP();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0B5E4F), // Green background
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: Size(double.infinity, 48), // Full width
                ),
                child: Text(
                  'Done',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NextTrial', // Font "Next Trial"
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
