// class WalletDetails {
//   String earningWalletId;
//   int earningWalletAmount;
//   bool earningWalletState;
//   String mainWalletId;
//   int mainWalletAmount;
//   bool mainWalletState;

//   WalletDetails(
//       {this.earningWalletId,
//       this.earningWalletAmount,
//       this.earningWalletState,
//       this.mainWalletId,
//       this.mainWalletAmount,
//       this.mainWalletState});

//   Map toMap(WalletDetails walletDetails) {
//     var data = Map<String, dynamic>();
//     data['earningWalletId'] = walletDetails.earningWalletId;
//     data['earningWalletAmount'] = walletDetails.earningWalletAmount;
//     data['earningWalletState'] = walletDetails.earningWalletState;
//     data['mainWalletId'] = walletDetails.mainWalletId;
//     data['mainWalletAmount'] = walletDetails.mainWalletAmount;
//     data['mainWalletState'] = walletDetails.mainWalletState;
//     return data;
//   }

//   // Named constructor
//   WalletDetails.fromMap(Map<String, dynamic> mapData) {
//     this.earningWalletId = mapData['earningWalletId'];
//     this.earningWalletAmount = mapData['earningWalletAmount'];
//     this.earningWalletState = mapData['earningWalletState'];
//     this.mainWalletId = mapData['mainWalletId'];
//     this.mainWalletAmount = mapData['mainWalletAmount'];
//     this.mainWalletState = mapData['mainWalletState'];
//   }
// }
