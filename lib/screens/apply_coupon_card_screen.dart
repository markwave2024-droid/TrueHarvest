import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_new/controllers/coupon_card_controller.dart';
import 'package:task_new/utils/app_colors.dart';
import 'package:task_new/utils/coupon_success_dialog.dart'; // ← IMPORT

class ApplyCouponCard extends ConsumerStatefulWidget {
  final double totalAmount;

  const ApplyCouponCard({super.key, required this.totalAmount});

  @override
  ConsumerState<ApplyCouponCard> createState() => _ApplyCouponCardState();
}

class _ApplyCouponCardState extends ConsumerState<ApplyCouponCard> {
  final TextEditingController couponController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final coupon = ref.watch(couponProvider);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: coupon.appliedCoupon.isNotEmpty
                      ? Colors.green[100]
                      : AppColors.darkGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.local_offer,
                  color: coupon.appliedCoupon.isNotEmpty
                      ? Colors.green[800]
                      : AppColors.darkGreen,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                coupon.appliedCoupon.isNotEmpty
                    ? 'Coupon Applied!'
                    : 'Have a coupon?',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: coupon.appliedCoupon.isNotEmpty
                          ? Colors.green[800]
                          : Colors.black87,
                    ),
              ),
              const Spacer(),

              if (coupon.appliedCoupon.isNotEmpty)
                TextButton(
                  onPressed: () {
                    ref.read(couponProvider.notifier).removeCoupon();
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text("Remove"),
                ),
            ],
          ),

          const SizedBox(height: 12),

          // INPUT + BUTTON
          if (coupon.appliedCoupon.isEmpty) ...[
            TextField(
              controller: couponController,
              decoration: InputDecoration(
                hintText: "Enter coupon code",
                filled: true,
                fillColor: AppColors.lightBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkGreen,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  final code = couponController.text.trim();
                  final prev = coupon.appliedCoupon;

                  ref.read(couponProvider.notifier).applyCoupon(code, widget.totalAmount);

                  final updated = ref.read(couponProvider);

                  if (prev.isEmpty && updated.appliedCoupon.isNotEmpty) {
                    showCouponSuccessDialog(
                      context,
                      updated.appliedCoupon,
                      updated.discount,
                    );
                  }
                },
                child: const Text("Apply Coupon"),
              ),
            ),
          ],

          // SUCCESS BOX
          if (coupon.appliedCoupon.isNotEmpty) ...[
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green[700], size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Coupon ${coupon.appliedCoupon} applied! Saving ₹${coupon.discount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // ERROR MESSAGE
          if (coupon.errorMessage != null &&
              coupon.appliedCoupon.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                coupon.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}
