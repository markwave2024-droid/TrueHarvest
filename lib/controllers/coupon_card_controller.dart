import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';

final couponProvider = ChangeNotifierProvider<CouponProvider>((ref) => CouponProvider());

class CouponProvider extends ChangeNotifier {
  String appliedCoupon = "";
  double discount = 0.0;
  String? errorMessage;
bool get hasCouponApplied=>appliedCoupon.isNotEmpty;
double get discountAmount=>discount;
void applyCoupon(String code, double totalAmount) {
  code = code.trim().toUpperCase();
  errorMessage = null;

  Map<String, double> couponPercents = {
    "FIRST10": 0.10,
    "FIRST20": 0.20,
    "FIRST30": 0.30,
  };

  if (!couponPercents.containsKey(code)) {
    errorMessage = "Invalid coupon";
    appliedCoupon = "";
    discount = 0;
  } else {
    appliedCoupon = code;
    discount = totalAmount * couponPercents[code]!;
  }

  notifyListeners();
}
  void removeCoupon(){
    appliedCoupon="";
    discount=0.0;
    errorMessage=null;
    notifyListeners();
  }
}
