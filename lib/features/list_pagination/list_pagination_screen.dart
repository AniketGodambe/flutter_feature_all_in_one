import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_feature_all_in_one/view_source_code.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ListPaginationAPI extends StatefulWidget {
  const ListPaginationAPI({super.key});

  @override
  State<ListPaginationAPI> createState() => _ListPaginationAPIState();
}

class _ListPaginationAPIState extends State<ListPaginationAPI> {
  List<Product> products = [];
  int currentPage = 0;
  int itemsPerpage = 20;
  int totalItems = 0;
  bool isLoadingMore = false;
  bool isLastpage = false;
  bool isListLoading = false;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    fetchProduct();
    scrollController.addListener(() {
      if (!isLastpage &&
          !isLoadingMore &&
          scrollController.position.pixels >=
              scrollController.position.maxScrollExtent) {
        fetchProduct(loadMore: true);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pagination Example"),
        actions: [
          ElevatedButton(
            onPressed: () {
              String filePath =
                  'lib/features/fetch_device_contacts/fetch_device_contacts_screen.dart';
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SourceCodeView(filePath: filePath),
                ),
              );
            },
            child: Text('Source Code'),
          ),
        ],
      ),
      body: isListLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                fetchProduct();
              },
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                controller: scrollController,
                shrinkWrap: true,
                itemCount: products.length + 2,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return SizedBox.shrink();
                  }

                  index -= 1;

                  if (index == products.length) {
                    if (isLastpage) {
                      return SizedBox(
                        height: 100,
                        child: Center(child: Text("No more items")),
                      );
                    }

                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (_, __) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 150,
                          color: Colors.white,
                          margin: EdgeInsets.symmetric(vertical: 5),
                        ),
                      ),

                      itemCount: 2,
                    );
                  }

                  return Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        margin: EdgeInsets.only(bottom: 20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,

                          boxShadow: [
                            BoxShadow(
                              offset: Offset(2, 2),
                              color: Colors.black.withAlpha(100),
                              blurRadius: 1,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 120,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: CachedNetworkImage(
                                    height: 120,
                                    imageUrl: products[index].images!.first,
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: Container(
                                            height: 80,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[400],
                                              border: Border.all(
                                                color: Colors.grey.shade200,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.image),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        products[index].title ?? "-",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        products[index].description ?? "-",
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "\$${products[index].price ?? "-"}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "Rating ${products[index].rating ?? "-"}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "Stock \$${products[index].stock ?? "-"}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color:
                                products[index].availabilityStatus ==
                                    "Out of Stock"
                                ? Colors.red
                                : Colors.orange,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              products[index].availabilityStatus ?? "",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
    );
  }

  Future<void> fetchProduct({loadMore = false}) async {
    try {
      if (loadMore) {
        isLoadingMore = true;
      } else {
        currentPage = 0;
        isLastpage = false;
        products.clear();
        isListLoading = true;
      }

      setState(() {});

      int skip = currentPage * itemsPerpage;

      final url = Uri.parse(
        'https://dummyjson.com/products?limit=$itemsPerpage&skip=$skip',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        var productsData = (data['products'] as List)
            .map((e) => Product.fromJson(e))
            .toList();

        if (loadMore) {
          products.addAll(productsData);
        } else {
          products = productsData;
        }

        totalItems = data['total'];

        if (loadMore && productsData.isNotEmpty) {
          currentPage += 1;
        } else if (!loadMore) {
          currentPage = 1;
        }

        if (products.length >= totalItems) {
          isLastpage = true;
        }
        isListLoading = false;
        isLoadingMore = false;

        setState(() {});
      } else {
        isListLoading = false;
        isLoadingMore = false;
        setState(() {});
        print('Failed to load product. Status code: ${response.statusCode}');
      }
    } catch (e, s) {
      isListLoading = false;
      isLoadingMore = false;
      setState(() {});
      print('Error fetching product: $e $s');
    }
  }
}

class ProductsDataModel {
  List<Product>? products;
  int? total;
  int? skip;
  int? limit;

  ProductsDataModel({this.products, this.total, this.skip, this.limit});

  factory ProductsDataModel.fromJson(Map<String, dynamic> json) {
    return ProductsDataModel(
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int?,
      skip: json['skip'] as int?,
      limit: json['limit'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'products': products?.map((e) => e.toJson()).toList(),
    'total': total,
    'skip': skip,
    'limit': limit,
  };
}

class Product {
  int? id;
  String? title;
  String? description;
  String? category;
  double? price;
  double? discountPercentage;
  double? rating;
  int? stock;
  List<dynamic>? tags;
  String? brand;
  String? sku;
  int? weight;
  Dimensions? dimensions;
  String? warrantyInformation;
  String? shippingInformation;
  String? availabilityStatus;
  List<Review>? reviews;
  String? returnPolicy;
  int? minimumOrderQuantity;
  Meta? meta;
  List<dynamic>? images;
  String? thumbnail;

  Product({
    this.id,
    this.title,
    this.description,
    this.category,
    this.price,
    this.discountPercentage,
    this.rating,
    this.stock,
    this.tags,
    this.brand,
    this.sku,
    this.weight,
    this.dimensions,
    this.warrantyInformation,
    this.shippingInformation,
    this.availabilityStatus,
    this.reviews,
    this.returnPolicy,
    this.minimumOrderQuantity,
    this.meta,
    this.images,
    this.thumbnail,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'] as int?,
    title: json['title'] as String?,
    description: json['description'] as String?,
    category: json['category'] as String?,
    price: (json['price'] as num?)?.toDouble(),
    discountPercentage: (json['discountPercentage'] as num?)?.toDouble(),
    rating: (json['rating'] as num?)?.toDouble(),
    stock: json['stock'] as int?,
    tags: json['tags'] as List<dynamic>?,
    brand: json['brand'] as String?,
    sku: json['sku'] as String?,
    weight: json['weight'] as int?,
    dimensions: json['dimensions'] == null
        ? null
        : Dimensions.fromJson(json['dimensions'] as Map<String, dynamic>),
    warrantyInformation: json['warrantyInformation'] as String?,
    shippingInformation: json['shippingInformation'] as String?,
    availabilityStatus: json['availabilityStatus'] as String?,
    reviews: (json['reviews'] as List<dynamic>?)
        ?.map((e) => Review.fromJson(e as Map<String, dynamic>))
        .toList(),
    returnPolicy: json['returnPolicy'] as String?,
    minimumOrderQuantity: json['minimumOrderQuantity'] as int?,
    meta: json['meta'] == null
        ? null
        : Meta.fromJson(json['meta'] as Map<String, dynamic>),
    images: json['images'] as List<dynamic>?,
    thumbnail: json['thumbnail'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category,
    'price': price,
    'discountPercentage': discountPercentage,
    'rating': rating,
    'stock': stock,
    'tags': tags,
    'brand': brand,
    'sku': sku,
    'weight': weight,
    'dimensions': dimensions?.toJson(),
    'warrantyInformation': warrantyInformation,
    'shippingInformation': shippingInformation,
    'availabilityStatus': availabilityStatus,
    'reviews': reviews?.map((e) => e.toJson()).toList(),
    'returnPolicy': returnPolicy,
    'minimumOrderQuantity': minimumOrderQuantity,
    'meta': meta?.toJson(),
    'images': images,
    'thumbnail': thumbnail,
  };
}

class Dimensions {
  double? width;
  double? height;
  double? depth;

  Dimensions({this.width, this.height, this.depth});

  factory Dimensions.fromJson(Map<String, dynamic> json) => Dimensions(
    width: (json['width'] as num?)?.toDouble(),
    height: (json['height'] as num?)?.toDouble(),
    depth: (json['depth'] as num?)?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'width': width,
    'height': height,
    'depth': depth,
  };
}

class Review {
  int? rating;
  String? comment;
  DateTime? date;
  String? reviewerName;
  String? reviewerEmail;

  Review({
    this.rating,
    this.comment,
    this.date,
    this.reviewerName,
    this.reviewerEmail,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    rating: json['rating'] as int?,
    comment: json['comment'] as String?,
    date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
    reviewerName: json['reviewerName'] as String?,
    reviewerEmail: json['reviewerEmail'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'rating': rating,
    'comment': comment,
    'date': date?.toIso8601String(),
    'reviewerName': reviewerName,
    'reviewerEmail': reviewerEmail,
  };
}

class Meta {
  DateTime? createdAt;
  DateTime? updatedAt;
  String? barcode;
  String? qrCode;

  Meta({this.createdAt, this.updatedAt, this.barcode, this.qrCode});

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    updatedAt: json['updatedAt'] == null
        ? null
        : DateTime.parse(json['updatedAt'] as String),
    barcode: json['barcode'] as String?,
    qrCode: json['qrCode'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'barcode': barcode,
    'qrCode': qrCode,
  };
}
