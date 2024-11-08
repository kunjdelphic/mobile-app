// import 'bill_payment_amounts.dart';

// class BillPaymentProducts {
//   int? status;
//   String? message;
//   List<BillPaymentProduct>? products;

//   BillPaymentProducts({this.status, this.message, this.products});

//   BillPaymentProducts.fromJson(Map<String, dynamic> json) {
//     status = json["status"];
//     message = json["message"];
//     products = json["products"] == null
//         ? null
//         : (json["products"] as List)
//             .map((e) => BillPaymentProduct.fromJson(e))
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

// class BillPaymentProduct {
//   String? id;
//   String? productId;
//   String? name;
//   dynamic order;
//   String? type;
//   List<ServiceProviders>? serviceProviders;
//   String? serviceId;
//   String? categoryId;
//   String? amountType;

//   String? country;
//   String? currency;
//   String? helpText;
//   List<FieldsRequired>? fieldsRequired;
//   bool? hasOutstandingAmount;
//   bool? state;
//   dynamic v;
//   String? logo;
//   List<Amounts>? amounts;
//   dynamic maximumAmount;
//   dynamic minimumAmount;

//   BillPaymentProduct({
//     this.id,
//     this.productId,
//     this.name,
//     this.order,
//     this.type,
//     this.serviceProviders,
//     this.serviceId,
//     this.categoryId,
//     this.country,
//     this.currency,
//     this.helpText,
//     this.fieldsRequired,
//     this.hasOutstandingAmount,
//     this.state,
//     this.v,
//     this.logo,
//     this.amountType,
//     this.amounts,
//     this.maximumAmount,
//     this.minimumAmount,
//   });

//   BillPaymentProduct.fromJson(Map<String, dynamic> json) {
//     id = json["_id"];
//     productId = json["product_id"];
//     name = json["name"];
//     order = json["order"];
//     type = json["type"];
//     serviceProviders = json["service_providers"] == null
//         ? null
//         : (json["service_providers"] as List)
//             .map((e) => ServiceProviders.fromJson(e))
//             .toList();
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
//     state = json["state"];
//     v = json["__v"];
//     logo = json["logo"];
//     amountType = json["amount_type"];
//     amounts = json["amounts"] == null
//         ? null
//         : (json["amounts"] as List).map((e) => Amounts.fromJson(e)).toList();
//     maximumAmount = json["maximum_amount"];
//     minimumAmount = json["minimum_amount"];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data["_id"] = id;
//     data["product_id"] = productId;
//     data["name"] = name;
//     data["order"] = order;
//     data["type"] = type;
//     if (serviceProviders != null) {
//       data["service_providers"] =
//           serviceProviders?.map((e) => e.toJson()).toList();
//     }
//     data["service_id"] = serviceId;
//     data["category_id"] = categoryId;
//     data["country"] = country;
//     data["currency"] = currency;
//     data["help_text"] = helpText;
//     if (fieldsRequired != null) {
//       data["fields_required"] = fieldsRequired?.map((e) => e.toJson()).toList();
//     }
//     data["has_outstanding_amount"] = hasOutstandingAmount;
//     data["amount_type"] = amountType;
//     data["state"] = state;
//     data["__v"] = v;
//     data["logo"] = logo;
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

// class ServiceProviders {
//   String? serviceProviderId;
//   String? commissionType;
//   dynamic commission;
//   String? product;
//   bool? state;

//   ServiceProviders(
//       {this.serviceProviderId,
//       this.commissionType,
//       this.commission,
//       this.product,
//       this.state});

//   ServiceProviders.fromJson(Map<String, dynamic> json) {
//     serviceProviderId = json["service_provider_id"];
//     commissionType = json["commission_type"];
//     commission = json["commission"];
//     product = json["product"];
//     state = json["state"];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data["service_provider_id"] = serviceProviderId;
//     data["commission_type"] = commissionType;
//     data["commission"] = commission;
//     data["product"] = product;
//     data["state"] = state;
//     return data;
//   }
// }
