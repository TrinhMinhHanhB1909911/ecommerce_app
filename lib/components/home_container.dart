import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/components/banner.dart';
import 'package:ecommerce_app/components/products_catalog.dart';
import 'package:ecommerce_app/components/products_widget.dart';
import 'package:ecommerce_app/model/banner_model.dart';
import 'package:ecommerce_app/services/banner_service.dart';
import 'package:ecommerce_app/services/firebase_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../model/product_model.dart';
import 'banner.dart';
import 'header_row.dart';

class HomeContainer extends StatefulWidget {
  const HomeContainer({Key? key}) : super(key: key);

  @override
  State<HomeContainer> createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {
  Future<List<ProductModel>> getAllProducts() async {
    final docs = await FirebaseFirestore.instance.collection('products').get();
    return docs.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
      final data = doc.data();
      return ProductModel(
        name: data['name'],
        imageURL: data['imageURL'],
        price: data['price'],
        grade: data['grade'],
        //isFavorite: data['isFavorite'],
        sold: data['sold'],
      );
    }).toList();
  }

  Future<List<String>> getBanners() async {
    List<String> urls = [];
    ListResult results =
        await FirebaseStorage.instance.ref().child('banner').listAll();
    for (int i = 0; i < results.items.length; i++) {
      String url = await results.items[i].getDownloadURL();
      urls.add(url);
    }
    return urls;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          FutureBuilder<BannerModel>(
            future: BannerService(database: FirebaseFirestore.instance)
                .getBanners(),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                return HeaderBanner(
                  model: snapshot.data!,
                );
              }
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  height: 115,
                  width: MediaQuery.of(context).size.width,
                  child: const Icon(Icons.image),
                ),
              );
            },
          ),
          const HeaderRow(
            title: 'Danh mục',
            hasMore: true,
          ),
          const ProductsCatalog(),
          const HeaderRow(
            title: 'Sản phẩm gợi ý',
            hasMore: true,
          ),
          //buildProducts(products),
          FutureBuilder<List<ProductModel>?>(
            future: ProductServiceIml(database: FirebaseFirestore.instance)
                .getAllProducts(),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                return ProductsWidget(products: snapshot.data!);
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
