import 'package:ecommerce_client/controller/login_controller.dart';
import 'package:ecommerce_client/pages/login_page.dart';
import 'package:ecommerce_client/widgets/otp_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(builder: (ctrl) {
      return Scaffold(
        body: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blueGrey[50],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Create Your Account!',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: ctrl.registerNameCtrl,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.account_circle),
                    labelText: 'Your Name',
                    hintText: 'Enter your name'),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: ctrl.registerMobileCtrl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.phone_android),
                    labelText: 'Mobile Number',
                    hintText: 'Enter your mobile number'),
              ),
              const SizedBox(height: 20),
              OtpTextField(
                otpController: ctrl.otpController,
                visible: ctrl.otpFieldShown,
                onComplete: (otp) {
                  ctrl.otpEnatered = int.tryParse(otp ?? '0000');
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    if (ctrl.otpFieldShown) {
                      ctrl.addUser();
                    } else {
                      ctrl.sendOtp();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.deepPurple),
                  child: Text(ctrl.otpFieldShown ? 'Register' : 'Send OTP')),
              const SizedBox(
                height: 20,
              ),
              TextButton(onPressed: () {
                Get.to(LoginPage());
              }, child: Text('Login'))
            ],
          ),
        ),
      );
    });
  }
}
