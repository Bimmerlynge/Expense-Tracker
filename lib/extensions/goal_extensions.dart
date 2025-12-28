import 'package:expense_tracker/domain/goal.dart';

extension GoalExtensions on Goal {
  double get savedPercentage {
    return (currentAmount / goalAmount).clamp(0.0, 1.0) * 100;
  }

  double get remaining {
    return goalAmount - currentAmount;
  }
}
