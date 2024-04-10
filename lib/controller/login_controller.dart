import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_client/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otp_text_field_v2/otp_field_v2.dart';

import '../models/user/user.dart';

class LoginController extends GetxController{

  GetStorage box = GetStorage();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference userCollection;

  TextEditingController registerNameCtrl = TextEditingController();
  TextEditingController registerMobileCtrl = TextEditingController();

  TextEditingController loginNumberCtrl = TextEditingController();

  OtpFieldControllerV2 otpController = OtpFieldControllerV2();
  bool otpFieldShown = false;
  int? otpSend;
  int? otpEnatered;

  User? loginUser;

  @override
  void onReady() {
    Map<String, dynamic>? user = box.read('loginUser');
    if(user != null) {
      loginUser = User.fromJson(user);
      Get.to(const HomePage());
    }
    super.onReady();
  }

  @override
  void onInit() {
    userCollection = firestore.collection('users');
    super.onInit();
  }

  addUser() {
    try {
      if(otpSend == otpEnatered){
        DocumentReference doc = userCollection.doc();
        User user = User(
          id: doc.id,
          name: registerNameCtrl.text,
          number: int.parse(registerMobileCtrl.text),
        );
        final userJson = user.toJson();
        doc.set(userJson);
        Get.snackbar('Success', 'User added successfully', colorText: Colors.green);
        registerNameCtrl.clear();
        registerMobileCtrl.clear();
        otpController.clear();
      } else {
        Get.snackbar('Error', 'OTP is incorrect',colorText: Colors.red);
      }
     } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
       print(e);
    }
  }

  sendOtp() async {
    try {
      if(registerNameCtrl.text.isEmpty || registerMobileCtrl.text.isEmpty){
        Get.snackbar('Error', 'Please fill the field',colorText: Colors.red);
        // to stop the code
        return;
      }
      final random = Random();
      int otp = 1000 + random.nextInt(9000);
      String mobileNumber = registerMobileCtrl.text;
      String url = // Your Fast2SMS SMS sending link ;
      Response response = await GetConnect().get(url);
      print(otp);
      if(response.body['message'][0] == 'SMS sent successfully.'){
            otpFieldShown = true;
            otpSend = otp;
            Get.snackbar('Success', 'OTP sent successfully',colorText: Colors.green);
          } else {
             Get.snackbar('Error', 'OTP not send !!',colorText: Colors.red);
          }
    } catch (e) {
      print(e);
    } finally {
      update();
    }
  }

  Future<void> loginWithPhone() async {
    String phoneNumber = loginNumberCtrl.text;
    try {
      if(phoneNumber.isNotEmpty){
            var querySnapshot = await userCollection.where('number', isEqualTo: int.tryParse(phoneNumber)).limit(1).get();
            if(querySnapshot.docs.isNotEmpty){
              var UserDoc = querySnapshot.docs.first;
              var userData = UserDoc.data() as Map<String, dynamic>;
              box.write('loginUser', userData);
              loginNumberCtrl.clear();
              Get.to(const HomePage());
              Get.snackbar('Success', 'Login Successful',colorText: Colors.green);
            } else {
              Get.snackbar('Error', 'User not found, please register',colorText: Colors.red);
            }
          } else {
            Get.snackbar('Error', 'Please enter a phone number',colorText: Colors.red);
          }
    } catch (error) {
      print("Failed to login: $error");
      Get.snackbar('Error', 'Failed to login',colorText: Colors.red);
    }
  }

 }
