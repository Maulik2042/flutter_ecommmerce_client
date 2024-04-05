import 'package:ecommerce_client/controller/home_controller.dart';
import 'package:ecommerce_client/pages/login_page.dart';
import 'package:ecommerce_client/pages/product_description_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../widgets/drop_down_btn.dart';
import '../widgets/multi_select_drop_down.dart';
import '../widgets/product_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (ctrl) {
      return RefreshIndicator(
        onRefresh: () async {
          ctrl.fetchProducts();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Product Store',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [IconButton(onPressed: () {
              GetStorage box = GetStorage();
              box.erase();
              Get.offAll(LoginPage());
            }, icon: Icon(Icons.logout))
            ],
          ),
          body: Column(
            children: [
              SizedBox(
                height: 50,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: (){
                        ctrl.filterByCategory(ctrl.productCategories[index].name ?? '');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Chip(label: Text(ctrl.productCategories[index].name ?? 'No')),
                      ),
                    );
                  },
                  itemCount: ctrl.productCategories.length,
                  scrollDirection: Axis.horizontal,
                ),
              ),
              Row(
                children: [
                  Flexible(
                      child: MultiSelectDropDown(
                        items: ['Nike', 'Gucci', 'Chanel','Tanishq','LG'],
                        onSelectionChanged: (selectedItems) {
                          ctrl.filterByBrand(selectedItems);
                        },
                      )),
                  Flexible(
                    child: DropDownBtn(
                      items: ['Rs: Low to High', 'Rs: High to Low'],
                      selectedItemText: 'Sort items',
                      onSelected: (selected) {
                        print(selected);
                        ctrl.sortByPrice(ascending: selected == 'Rs: Low to High'? true : false);
                      },
                    ),
                  ),
                ],
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8),
                  itemCount: ctrl.productShowInUi.length,
                  itemBuilder: (context, index) {
                    try {
                      return ProductCard(
                                          name: ctrl.productShowInUi[index].name ?? 'No name',
                                          imageUrl: ctrl.productShowInUi[index].image ?? 'url',
                                          price: ctrl.productShowInUi[index].price ?? 00,
                                          offerTeg: '10 % off',
                                          onTap: () {
                                            Get.to(const ProductDescription(),arguments: {'data':ctrl.productShowInUi[index]});
                                          },
                                        );
                    } catch (e) {
                      print(e);
                    }
                  },
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
