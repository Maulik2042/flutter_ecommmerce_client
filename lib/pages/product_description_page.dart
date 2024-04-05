import 'package:ecommerce_client/controller/purchase_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/product/product.dart';

class ProductDescription extends StatelessWidget {
  const ProductDescription({super.key});

  @override
  Widget build(BuildContext context) {
    Product product = Get.arguments['data'];
    return GetBuilder<PurchaseController>(builder: (ctrl) {
      return Scaffold(
        appBar: AppBar(
          title: Center(
              child: const Text(
            'Product Details',
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  product.image ?? '',
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: 200,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                product.name ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                product.description ?? '',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Rs : ${product.price ?? ''}',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: ctrl.addressController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelText: 'Enter Your Billing Address',
                  hintText: 'Your Address',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Colors.indigoAccent),
                    onPressed: () {
                      ctrl.submitOrder(
                        price: product.price ?? 0,
                        item: product.name ?? '',
                        description: product.description ?? '',
                      );
                    },
                    child: Text(
                      'Buy Now',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    )),
              )
            ],
          ),
        ),
      );
    });
  }
}
