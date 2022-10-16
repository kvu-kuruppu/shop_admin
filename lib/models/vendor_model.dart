// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shop_admin/services/firebase_services.dart';
// import 'package:shop_app_vendor/services/firebase_services.dart';

// class VendorModel {
//   VendorModel({
//     this.shopImage,
//     this.logo,
//     this.businessName,
//     this.contactNo,
//     this.email,
//     this.taxStatus,
//     this.gstNo,
//     this.pinCode,
//     this.landmark,
//     this.countryValue,
//     this.stateValue,
//     this.cityValue,
//     this.uid,
//     this.time,
//     this.approved,
//   });

//   VendorModel.fromJson(Map<String, Object?> json)
//       : this(
//           shopImage: json['shopImage']! as String,
//           logo: json['logo']! as String,
//           businessName: json['businessName'] as String,
//           contactNo: json['contactNo']! as String,
//           email: json['email']! as String,
//           taxStatus: json['taxStatus']! as String,
//           gstNo: json['gstNo']! as String,
//           pinCode: json['pinCode']! as String,
//           landmark: json['landmark']! as String,
//           countryValue: json['countryValue']! as String,
//           stateValue: json['stateValue']! as String,
//           cityValue: json['cityValue']! as String,
//           uid: json['uid']! as String,
//           time: json['time']! as Timestamp,
//           approved: json['approved']! as bool,
//         );

//   final String? shopImage;
//   final String? logo;
//   final String? businessName;
//   final String? contactNo;
//   final String? email;
//   final String? taxStatus;
//   final String? gstNo;
//   final String? pinCode;
//   final String? landmark;
//   final String? countryValue;
//   final String? stateValue;
//   final String? cityValue;
//   final String? uid;
//   final Timestamp? time;
//   final bool? approved;

//   Map<String, Object?> toJson() {
//     return {
//       'shopImage': shopImage,
//       'logo': logo,
//       'businessName': businessName,
//       'contactNo': contactNo,
//       'email': email,
//       'taxStatus': taxStatus,
//       'gstNo': gstNo,
//       'pinCode': pinCode,
//       'landmark': landmark,
//       'countryValue': countryValue,
//       'stateValue': stateValue,
//       'cityValue': cityValue,
//       'uid': uid,
//       'time': time,
//       'approved': approved,
//     };
//   }
// }