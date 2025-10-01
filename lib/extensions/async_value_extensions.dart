import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../app/shared/util/toast_service.dart';

extension AsyncValueUI<T> on AsyncValue<T> {
  void showToastOnError() {
    if (!isLoading && hasError) {
      ToastService.showErrorToast(error.toString());
    }
  }
}