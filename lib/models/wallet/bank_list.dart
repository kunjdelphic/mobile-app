class BankList {
  BankList({
    this.status,
    this.message,
    this.banks,
  });
  int? status;
  String? message;
  List<Bank>? banks;

  BankList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    banks = List.from(json['banks']).map((e) => Bank.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['banks'] = banks!.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Bank {
  Bank({
    required this.fpxBankId,
    required this.name,
    required this.logo,
    required this.bgColor,
    required this.fontColor,
    required this.order,
    required this.currency,
    required this.helpText,
    required this.minimumReloadAmount,
  });
  String? fpxBankId;
  String? name;
  String? logo;
  String? bgColor;
  String? fontColor;
  int? order;
  String? currency;
  String? helpText;
  var minimumReloadAmount;

  Bank.fromJson(Map<String, dynamic> json) {
    fpxBankId = json['fpx_bank_id'];
    name = json['name'];
    logo = json['logo'];
    bgColor = json['bg_color'];
    fontColor = json['font_color'];
    order = json['order'];
    currency = json['currency'];
    helpText = json['help_text'];
    minimumReloadAmount = json['minimum_reload_amount'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['fpx_bank_id'] = fpxBankId;
    _data['name'] = name;
    _data['logo'] = logo;
    _data['bg_color'] = bgColor;
    _data['font_color'] = fontColor;
    _data['order'] = order;
    _data['currency'] = currency;
    _data['help_text'] = helpText;
    _data['minimum_reload_amount'] = minimumReloadAmount;

    return _data;
  }
}
