import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cz2006/models/Coupon.dart';

class CouponController {
  final CollectionReference couponCollection =
      Firestore().collection('coupons');

  List<Coupon> _couponFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Coupon(
        couponValue: doc.data['couponValue'],
        title: doc.data['title'],
        imageURL: doc.data['imageURL'],
      );
    }).toList();
  }

  Stream<List<Coupon>> get coupons {
    return couponCollection.snapshots().map(_couponFromSnapshot);
  }

  Future<void> deleteCoupon(String couponTitle) async {
    couponCollection.document(couponTitle).delete();
    print("deleted " + couponTitle);
  }

  Future<void> addCoupon(String title, int couponValue, String imageURL) async {
    couponCollection.document(title).setData(
        {'title': title, 'couponValue': couponValue, 'imageURL': imageURL});
    print("added coupon " + title);
  }
}
