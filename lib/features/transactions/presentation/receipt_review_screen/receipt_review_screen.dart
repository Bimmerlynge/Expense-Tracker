import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/app/config/theme/text_theme.dart';
import 'package:expense_tracker/app/shared/components/actions_row.dart';
import 'package:expense_tracker/app/shared/util/toast_service.dart';
import 'package:expense_tracker/app/shared/widgets/app_bar_gradiant.dart';
import 'package:expense_tracker/app/shared/widgets/blue_gradient_background.dart';
import 'package:expense_tracker/app/shared/widgets/premium_blue.dart';
import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/features/transactions/domain/line_item.dart';
import 'package:expense_tracker/features/transactions/presentation/receipt_review_screen/receipt_review_screen_controller.dart';
import 'package:expense_tracker/features/transactions/presentation/widgets/line_item_tile.dart';
import 'package:expense_tracker/features/transactions/presentation/widgets/receipt_widget.dart';
import 'package:expense_tracker/features/transactions/providers/receipt_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReceiptReviewScreen extends ConsumerStatefulWidget {
  const ReceiptReviewScreen({super.key});

  @override
  ConsumerState<ReceiptReviewScreen> createState() => _ReceiptReviewScreenState();
}

class _ReceiptReviewScreenState extends ConsumerState<ReceiptReviewScreen> {
  bool _isSending = false;

  @override
  Widget build(BuildContext context) {
    final receipt = ref.watch(receiptReviewScreenControllerProvider);
    return Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: AppBar(
        title: Text('Scannet Kvittering', style: TextStyle(color: AppColors.white)),
        flexibleSpace: AppBarGradiant()
      ),
      body: Stack(
        children: [
          if (_isSending) ...{
            Center(
              child: CircularProgressIndicator(),
            )
          },
          Opacity(
            opacity: _isSending ? 0.5 : 1,
            child: Column(
                children: [
                  SizedBox(height: 12),
                  _headerButtons(),
                  SizedBox(height: 12),
                  Expanded(child: ReceiptWidget(receipt: receipt))
                ]
            ),
          ),
        ]
      )
    );
  }

  Widget _headerButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Expanded(
            child: PremiumBlueButton(
              linearBegin: Alignment.bottomLeft,
              linearEnd: Alignment.topRight,
              radialCenter: Alignment.topRight,
              icon: Icons.camera_alt,
              text: "Tag nyt billede",
              onTap: () {},
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: PremiumBlueButton(
              linearBegin: Alignment.bottomRight,
              linearEnd: Alignment.topLeft,
              radialCenter: Alignment.topLeft,
              icon: Icons.post_add,
              text: "Send kvittering",
              onTap: _onSend,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onSend() async {
    if (_isSending == true) return;

    setState(() {
      _isSending = true;
    });

    try {
      await ref.read(receiptReviewScreenControllerProvider.notifier).send();
      ToastService.showSuccessToast("Kvittering behandlet!");
    } catch (e) {
      ToastService.showErrorToast("Fejl ved behandling af kvittering 😢");
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }
}