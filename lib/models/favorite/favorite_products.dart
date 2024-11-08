// class FavoriteProducts {
//   int? status;
//   String? message;
//   List<FavoriteProduct>? products;

//   FavoriteProducts({this.status, this.message, this.products});

//   FavoriteProducts.fromJson(Map<String, dynamic> json) {
//     status = json["status"];
//     message = json["message"];
//     products = json["products"] == null
//         ? null
//         : (json["products"] as List)
//             .map((e) => FavoriteProduct.fromJson(e))
//             .toList();
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data["status"] = status;
//     data["message"] = message;
//     if (products != null) {
//       data["products"] = products?.map((e) => e.toJson()).toList();
//     }
//     return data;
//   }
// }

// class FavoriteProduct {
//   String? productId;
//   String? name;
//   String? logo;
//   dynamic order;
//   String? type;
//   String? serviceId;
//   String? categoryId;
//   String? country;
//   String? currency;
//   String? helpText;
//   List<FieldsRequired>? fieldsRequired;
//   bool? hasOutstandingAmount;

//   FavoriteProduct(
//       {this.productId,
//       this.name,
//       this.logo,
//       this.order,
//       this.type,
//       this.serviceId,
//       this.categoryId,
//       this.country,
//       this.currency,
//       this.helpText,
//       this.fieldsRequired,
//       this.hasOutstandingAmount});

//   FavoriteProduct.fromJson(Map<String, dynamic> json) {
//     productId = json["product_id"];
//     name = json["name"];
//     logo = json["logo"];
//     order = json["order"];
//     type = json["type"];
//     serviceId = json["service_id"];
//     categoryId = json["category_id"];
//     country = json["country"];
//     currency = json["currency"];
//     helpText = json["help_text"];
//     fieldsRequired = json["fields_required"] == null
//         ? null
//         : (json["fields_required"] as List)
//             .map((e) => FieldsRequired.fromJson(e))
//             .toList();
//     hasOutstandingAmount = json["has_outstanding_amount"];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data["product_id"] = productId;
//     data["name"] = name;
//     data["logo"] = logo;
//     data["order"] = order;
//     data["type"] = type;
//     data["service_id"] = serviceId;
//     data["category_id"] = categoryId;
//     data["country"] = country;
//     data["currency"] = currency;
//     data["help_text"] = helpText;
//     if (fieldsRequired != null) {
//       data["fields_required"] = fieldsRequired?.map((e) => e.toJson()).toList();
//     }
//     data["has_outstanding_amount"] = hasOutstandingAmount;
//     return data;
//   }
// }

// class FieldsRequired {
//   String? type;
//   dynamic minLength;

//   FieldsRequired({this.type, this.minLength});

//   FieldsRequired.fromJson(Map<String, dynamic> json) {
//     type = json["type"];
//     minLength = json["min_length"];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data["type"] = type;
//     data["min_length"] = minLength;
//     return data;
//   }
// }
