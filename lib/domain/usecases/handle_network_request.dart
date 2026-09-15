import 'dart:async';

class HandleNetworkRequest {
  Future<bool> execute({
    required bool Function() isConnected,
  }) async {
    for (int i = 0; i < 5; i++) {
      await Future.delayed(
        const Duration(seconds: 1),
      );

      if (!isConnected()) {
        return false;
      }
    }

    return true;
  }

  Future<bool> resume({
    required bool Function() isConnected,
  }) async {
    await Future.delayed(
      const Duration(seconds: 2),
    );

    return isConnected();
  }
}