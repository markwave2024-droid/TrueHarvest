import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

Future<void> showCouponSuccessDialog(
  BuildContext context,
  String coupon,
  double discount,
) async {
  final confetti = ConfettiController(duration: const Duration(seconds: 2));
  confetti.play();

  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.4),
    builder: (_) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // MAIN DIALOG
              Container(
                width: 290,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),

                    const Icon(Icons.check_circle,
                        color: Colors.white, size: 60),

                    const SizedBox(height: 12),

                    const Text(
                      "Coupon Applied!",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Coupon $coupon applied successfully.\nYou saved ₹${discount.toStringAsFixed(2)} 🎉",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 15,color: Colors.white),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),

              // CONFETTI OVERLAY
              ConfettiWidget(
                confettiController: confetti,
                blastDirectionality: BlastDirectionality.explosive,
                numberOfParticles: 35,
                maxBlastForce: 30,
                minBlastForce: 5,
                gravity: 0.4,
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.orange,
                  Colors.purple,
                ],
              ),
            ],
          ),
        ),
      );
    },
  );

  // AUTO CLOSE AFTER 2 SEC
  await Future.delayed(const Duration(seconds: 3));
  if (context.mounted) Navigator.pop(context);
  
}
