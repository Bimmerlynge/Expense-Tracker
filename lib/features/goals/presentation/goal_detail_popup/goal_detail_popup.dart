import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/app/shared/components/image_widget.dart';
import 'package:expense_tracker/app/shared/components/toggle.dart';
import 'package:expense_tracker/app/shared/util/toast_service.dart';
import 'package:expense_tracker/domain/goal.dart';
import 'package:expense_tracker/extensions/goal_extensions.dart';
import 'package:expense_tracker/features/common/widget/popup_widget.dart';
import 'package:expense_tracker/features/goals/presentation/goal_detail_popup/goal_detail_popup_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoalDetailPopup extends ConsumerStatefulWidget {
  final Goal goal;

  const GoalDetailPopup({super.key, required this.goal});

  @override
  ConsumerState<GoalDetailPopup> createState() => _EditSavingGoalPopupState();
}

class _EditSavingGoalPopupState extends ConsumerState<GoalDetailPopup> {
  late final TextEditingController _amountController;
  late String _currentUri;
  late bool _isSharedGoal;
  double _currentAddAmount = 0;
  String _inputUri = "";

  @override
  void initState() {
    super.initState();
    _currentUri = widget.goal.uri ?? '';
    _isSharedGoal = widget.goal.isShared;
    _amountController =
        TextEditingController(text: _currentAddAmount.toString());
  }

  @override
  Widget build(BuildContext context) {
    return PopupWidget(
        bodyContent: _buildBodyContent(),
        onConfirm: () => _handleConfirm(),
        confirmText: "Gem",
        headerTitle: widget.goal.title,
    );
  }

  Widget _buildBodyContent() {
    return Column(
      children: [
        _image(),
        Divider(thickness: 1, color: AppColors.primaryText, height: 1),
        _amountSection(),
        Divider(thickness: 1, color: AppColors.primaryText, height: 1),
        _updateAmountSection(),
        Divider(thickness: 1, color: AppColors.primaryText, height: 1),
        _setSharedRow(),
        Divider(thickness: 1, color: AppColors.primaryText, height: 1),
      ],
    );
  }

  Widget _image() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              ImageWidget(
                uri: _currentUri,
                height: 80,
                width: 80,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Billed url', style: Theme.of(context).primaryTextTheme.labelSmall,),
                    SizedBox(height: 8),
                    _urlInput(),
                    SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: _previewImage,
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3)
                          ),
                          backgroundColor: AppColors.onPrimary,
                          padding: EdgeInsets.symmetric(vertical: 0),
                          minimumSize: Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          alignment: Alignment.center,
                        ),
                        child: Text(
                          'Upload billed',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24),
      ],
    );
  }

  Future<void> _previewImage() async {
    setState(() {
      _currentUri = _inputUri;
    });
  }

  Widget _urlInput() {
    return TextFormField(
      initialValue: _currentUri,
      style: TextStyle(color: AppColors.primaryText, fontSize: 12),
      textAlign: TextAlign.start,
      onChanged: (val) {
        _inputUri = val;
      },
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(3),
          borderSide: BorderSide(color: Colors.pink.shade200, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryText)
        ),
        isDense: true,
        filled: true,
        fillColor: AppColors.secondary,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
    );
  }

  Widget _amountSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12.0),
      child: Column(
        spacing: 12,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _savedRow(),
          _progressRow(),
          _summaryRow(),
        ],
      ),
    );
  }

  Widget _savedRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('${widget.goal.currentAmount.toStringAsFixed(0)} opsparet'),
        Text('${widget.goal.savedPercentage.toStringAsFixed(0)}% opsparet')
      ],
    );
  }

  Widget _progressRow() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(
        value: widget.goal.savedPercentage / 100,
        minHeight: 8,
        backgroundColor: Colors.grey.shade300,
        color: Colors.green.shade400,
      ),
    );
  }
  Widget _summaryRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('${widget.goal.remaining.toStringAsFixed(0)} tilbage'),
        Text('${widget.goal.goalAmount.toStringAsFixed(0)} i alt')
      ],
    );
  }

  Widget _updateAmountSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _addAmountTitle(),
          SizedBox(height: 12),
          _addAmountInput(),
        ]
      ),
    );
  }

  Widget _addAmountTitle() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          'Tilføj beløb til opsparing',
          style: TextStyle(color: AppColors.primaryText, fontSize: 14),
        ),
    );
  }

  Widget _setSharedRow() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Del opsaringsmål'),
                Toggle(
                  initState: _isSharedGoal,
                  onToggled: (val) {
                    setState(() {
                      _isSharedGoal = val;
                    });
                  },
                )
              ],
            ),
          ],
        ),
    );
  }

  Widget _addAmountInput() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.onPrimary, // dark blue
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
            child: Text(
              'kr',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'^-?\d*\.?\d*$'),
                ),
              ],
              style: TextStyle(color: AppColors.primaryText, fontSize: 12),
              textAlign: TextAlign.center,
              onChanged: (val) {
                setState(() {
                  _currentAddAmount = double.parse(val);
                });
              },
              decoration: InputDecoration(
                contentPadding:
                EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                isDense: true,
                filled: true,
                fillColor: AppColors.secondary,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                  ),
                  borderSide: BorderSide(color: AppColors.onPrimary, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                  ),
                  borderSide:
                  BorderSide(color: Colors.pink.shade200, width: 1),
                ),
              ),
            ),
          ),
          Material(
            child: InkWell(
              onTap: _onAdd100,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.onPrimary,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Text(
                  '+100',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onAdd100() {
    setState(() {
      _currentAddAmount += 100;
      _amountController.text = _currentAddAmount.toString();
    });
  }

  Future<void> _handleConfirm() async {
    final updatedGoal = widget.goal.copyWith(
      uri: _currentUri,
      currentAmount: widget.goal.currentAmount += _currentAddAmount,
      isShared: _isSharedGoal
    );

    final success = await ref.read(goalDetailPopupControllerProvider.notifier).updateGoal(updatedGoal);

    if (success) {
      ToastService.showSuccessToast('Opsparingsmål opdateret!');
    } else {
      ToastService.showErrorToast('Kunne ikke opdatere opsparingsmålet');
    }
  }
}
