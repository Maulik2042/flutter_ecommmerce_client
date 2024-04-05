import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_client/controller/login_controller.dart';
import 'package:ecommerce_client/pages/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../models/user/user.dart';

class PurchaseController extends GetxController {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference orderCollection;

  TextEditingController addressController = TextEditingController();

  double orderPrice = 0;
  String itemName = '';
  String orderAddress = '';

  @override
  void onInit(){
    orderCollection = firestore.collection('orders');
    super.onInit();


  }

  submitOrder(
      {required double price,
      required String item,
      required String description
      }) {
        orderPrice = price;
        itemName = item;
        orderAddress = addressController.text;

        Razorpay razorpay = Razorpay();
        var options = {
          'key': 'rzp_test_3eyOBmr2eNUOYZ',
          'amount': price * 100,
          'name': item,
          'description': description,
        };

        razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
        razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
        razorpay.open(options);
  }


  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    orderSuccess(transactionId: response.paymentId);
    Get.snackbar('Success', 'Payment is successful',colorText: Colors.green);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar('Error', '${response.message}',colorText: Colors.red);
  }

  Future<void> orderSuccess({required String? transactionId}) async {
    User? loginUse = Get.find<LoginController>().loginUser;
    try{
      if(transactionId != null){
        DocumentReference docRef = await orderCollection.add({
          'customer' : loginUse?.name ?? '',
          'phone' : loginUse?.number ?? '',
          'item' : itemName,
          'price' : orderPrice,
          'address' : orderAddress,
          'transactionId' : transactionId,
          'dateTime' : DateTime.now().toString(),
        });
        print("Order created successfully: ${docRef.id}");
        showOrderSuccessDialog(docRef.id);
        Get.snackbar('Success', 'Order created Successfully',colorText: Colors.green);
      } else {
        Get.snackbar('Error', 'Please fill all fields',colorText: Colors.red);
      }
    } catch(error) {
      print("Failed to register user: $error");
      Get.snackbar('Error', 'Failed to create order',colorText: Colors.red);
    }
  }

  void showOrderSuccessDialog(String orderId) {
    Get.defaultDialog(
      title: "Order Success",
      content: Text('Your orderId is $orderId'),
      confirm: ElevatedButton(
          onPressed: (){
            Get.off(const HomePage());
          },
          child: const Text('Close'))
    );
  }

}
