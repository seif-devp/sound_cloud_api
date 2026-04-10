import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:sound_cloud_api/cubit_controller/login%20cubit/login_screen_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    const spinkit = SpinKitPianoWave(color: Colors.black, size: 20.0);
    return BlocProvider<LoginScreenCubit>(
      create: (context) => LoginScreenCubit(),
      child: Scaffold(
        body: Stack(
          children: [
            Stack(
              children: [
                Positioned.fill(
                  child: Transform.scale(
                    scale: 1.6,
                    child: Lottie.asset(
                      'assets/icons/Landscape.json',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    child: Column(
                      children: [
                        // Top Logo / Brand Name
                        const Text(
                          'Sundown Sound',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const Spacer(),

                        // Main Headline
                        const Text(
                          'Your music,\nyour vibe,\neverywhere.',
                          style: TextStyle(
                            color: Color(0xFFFDE8FF), // لون بينك فاتح جداً
                            fontSize: 52,
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                            letterSpacing: -1.5,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Subtitle
                        const Text(
                          'Experience high-fidelity soundscapes\ncurated for your late-night rhythm and\nmorning energy.',
                          style: TextStyle(
                            color: Color(0xFFAAA0C2), // لون رمادي/بنفسجي باهت
                            fontSize: 16,
                            height: 1.5,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        // Get Started Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: BlocConsumer<LoginScreenCubit, LoginScreenState>(
                            listener: (context, state) {
                              if (state is LoginScreenSuccess) {
                                context.pushReplacement('/home');
                              }
                              if (state is LoginScreenFailure) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(state.errorMessage),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            builder: (context, state) {
                              return ElevatedButton(
                                onPressed: () {
                                  // TODO: ضيف الراوتينج بتاعك هنا
                                  context.read<LoginScreenCubit>().login();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(
                                    0xFFD09BFF,
                                  ), // لون الزرار البنفسجي الفاتح
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 0,
                                ),
                                child: (state is LoginScreenLoading)
                                    ? spinkit
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Get Started',
                                            style: TextStyle(
                                              color: Color(
                                                0xFF28005A,
                                              ), // لون النص الغامق جوا الزرار
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Icon(
                                            Icons.arrow_forward,
                                            color: Color(0xFF28005A),
                                          ),
                                        ],
                                      ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Social Login Buttons Row
                        Row(
                          children: [
                            Expanded(
                              child:
                                  BlocBuilder<
                                    LoginScreenCubit,
                                    LoginScreenState
                                  >(
                                    builder: (context, state) {
                                      if (state is GoogleLoginLoading) {
                                        return spinkit;
                                      } else if (state is LoginScreenFailure) {
                                        return Text(
                                          state.errorMessage,
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 14,
                                          ),
                                          textAlign: TextAlign.center,
                                        );
                                      }
                                      return _SocialButton(
                                        label: '',
                                        icon: Lottie.asset(
                                          'assets/icons/google_icon.json',
                                          width: 60,
                                          height: 60,
                                        ),
                                        onTap: () {
                                          // TODO: جوجل لوجين لوجيك
                                          context
                                              .read<LoginScreenCubit>()
                                              .loginfailure();
                                        },
                                      );
                                    },
                                  ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _SocialButton(
                                label: 'Apple',
                                icon: const Icon(
                                  Icons.apple,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                onTap: () {
                                  // TODO: أبل لوجين لوجيك
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),

                        // Bottom Login Link
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              // TODO: راوتينج صفحة اللوجين
                            },
                            child: RichText(
                              text: const TextSpan(
                                text: 'Already have an account? ',
                                style: TextStyle(
                                  color: Color(0xFFAAA0C2),
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Log In',
                                    style: TextStyle(
                                      color: Color(
                                        0xFF00D2B4,
                                      ), // اللون الأخضر/التركواز
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ويدجت منفصلة لزراير السوشيال عشان الكود يكون Clean
class _SocialButton extends StatelessWidget {
  final String label;
  final Widget icon;
  final VoidCallback onTap;

  const _SocialButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: const Color(
            0xFF211636,
          ), // لون خلفية زراير السوشيال المائل للبنفسجي الغامق
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
