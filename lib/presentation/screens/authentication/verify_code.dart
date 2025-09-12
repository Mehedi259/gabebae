import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:gabebae/core/routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../widgets/custom_bottons/custom_button/button.dart';

/// ==========================
/// OTP Verification Screen
/// ==========================
class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpController = TextEditingController();
  bool isOtpComplete = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// ---------------- APP BAR ----------------
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Assets.icons.back.svg(
            width: 24,
            height: 24,
          ),
        ),
      ),

      /// ---------------- BODY ----------------
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),

            /// ---------------- TITLE ----------------
            const Text(
              "Enter Verification Code",
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Colors.black,
              ),
              textAlign: TextAlign.left,
            ),

            const SizedBox(height: 12),

            /// ---------------- SUBTITLE ----------------
            const Text(
              "Enter the code that was sent to your email.",
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Color(0xFF292929),
              ),
              textAlign: TextAlign.left,
            ),

            const SizedBox(height: 40),

            /// ---------------- OTP INPUT ----------------
            PinCodeTextField(
              appContext: context,
              length: 4,
              controller: otpController,
              keyboardType: TextInputType.number,
              animationType: AnimationType.fade,
              autoDisposeControllers: false,
              cursorColor: AppColors.primaryColor,
              textStyle: const TextStyle(
                fontFamily: "Poppins",
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(12),
                fieldHeight: 55,
                fieldWidth: 55,
                borderWidth: 2,
                activeColor: AppColors.primaryColor,
                selectedColor: AppColors.primaryColor,
                inactiveColor: const Color(0xFFB0B3B8),
                activeFillColor: Colors.transparent,
                selectedFillColor: Colors.transparent,
                inactiveFillColor: Colors.transparent,
              ),
              animationDuration: const Duration(milliseconds: 300),
              enableActiveFill: false,
              onChanged: (value) {
                setState(() {
                  isOtpComplete = value.length == 4;
                });
              },
            ),

            const SizedBox(height: 28),

            /// ---------------- RESEND LINK ----------------
            RichText(
              textAlign: TextAlign.left, // left align
              text: TextSpan(
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.black, // normal text color
                ),
                children: [
                  const TextSpan(
                    text: "Didn’t receive the code? ",
                  ),
                  TextSpan(
                    text: "Resend",
                    style: const TextStyle(
                      color: Color(0xFF6DAEDB), // clickable color
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {

                      },
                  ),
                ],
              ),
            ),


            const SizedBox(height: 60),

            /// ---------------- VERIFY BUTTON ----------------
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: "Verify",
                onTap: () {
                  if (isOtpComplete) {
                    context.go(RoutePath.onBoarding2.addBasePath);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter 4 digit code"),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
