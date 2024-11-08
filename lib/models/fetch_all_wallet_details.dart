class AllWalletDetails {
  late String name;
  late String referralCode;
  late String accountVerif;
  late bool mainWalletState;
  late String mainWalletAmount;
  late String mainWalletCurrency;
  late bool earningWalletState;
  late String earningWalletAmount;
  late String earningWalletCurrency;
  late String validTill;
  late int referralCount;
  late List earningHistory;
  late List transactionHistory;

  AllWalletDetails({
    required this.name,
    required this.referralCode,
    required this.accountVerif,
    required this.mainWalletState,
    required this.mainWalletAmount,
    required this.mainWalletCurrency,
    required this.earningWalletState,
    required this.earningWalletAmount,
    required this.earningWalletCurrency,
    required this.validTill,
    required this.referralCount,
    required this.earningHistory,
    required this.transactionHistory,
  });

  Map toMap(AllWalletDetails allWalletDetails) {
    var data = <String, dynamic>{};
    data['name'] = allWalletDetails.name;
    data['referralCode'] = allWalletDetails.referralCode;
    data['accountVerif'] = allWalletDetails.accountVerif;
    data['mainWalletState'] = allWalletDetails.mainWalletState;
    data['mainWalletAmount'] = allWalletDetails.mainWalletAmount;
    data['mainWalletCurrency'] = allWalletDetails.mainWalletCurrency;
    data['earningWalletState'] = allWalletDetails.earningWalletState;
    data['earningWalletAmount'] = allWalletDetails.earningWalletAmount;
    data['earningWalletCurrency'] = allWalletDetails.earningWalletCurrency;
    data['validTill'] = allWalletDetails.validTill;
    data['referralCount'] = allWalletDetails.referralCount;
    data['earningHistory'] = allWalletDetails.earningHistory;
    data['transactionHistory'] = allWalletDetails.transactionHistory;
    return data;
  }

  AllWalletDetails.fromMap(Map<String, dynamic> mapData) {
    name = mapData['name'];
    referralCode = mapData['referralCode'];
    accountVerif = mapData['accountVerif'];
    mainWalletState = mapData['mainWalletState'];
    mainWalletAmount = mapData['mainWalletAmount'];
    mainWalletCurrency = mapData['mainWalletCurrency'];
    earningWalletState = mapData['earningWalletState'];
    earningWalletAmount = mapData['earningWalletAmount'];
    earningWalletCurrency = mapData['earningWalletCurrency'];
    validTill = mapData['validTill'];
    referralCount = mapData['referralCount'];
    earningHistory = mapData['earningHistory'];
    transactionHistory = mapData['transactionHistory'];
  }
}
