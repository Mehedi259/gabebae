import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../widgets/custom_bottons/custom_button/button.dart';

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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: CustomButton(
          text: l10n.verify,
          onTap: () {
            if (isOtpComplete) {
              context.go(RoutePath.profileSetup1.addBasePath);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.pleaseEnterCode)),
              );
            }
          },
        ),
      ),
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.go(RoutePath.enterEmail.addBasePath),
          icon: Assets.icons.back.svg(width: 24, height: 24),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            Text(
              l10n.enterVerificationCode,
              style: const TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Colors.black,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.codeSentToEmail,
              style: const TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Color(0xFF292929),
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 40),
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
            RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(text: l10n.didntReceiveCode),
                  TextSpan(
                    text: l10n.resend,
                    style: const TextStyle(
                      color: Color(0xFF6DAEDB),
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}