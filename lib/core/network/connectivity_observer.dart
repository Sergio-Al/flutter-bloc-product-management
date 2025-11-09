// Observador de cambios en la conectividad
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityObserver {
  final Connectivity _connectivity;
  StreamSubscription<ConnectivityResult>? _subscription;
  final _controller = StreamController<bool>.broadcast();

  ConnectivityObserver(this._connectivity);

  Stream<bool> get onConnectivityChanged => _controller.stream;

  void startObserving() {
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      final isConnected = _isConnectionAvailable([result]);
      _controller.add(isConnected);
    });
  }

  void stopObserving() {
    _subscription?.cancel();
  }

  Future<bool> checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    return _isConnectionAvailable([result]);
  }

  bool _isConnectionAvailable(List<ConnectivityResult> results) {
    return results.any((result) =>
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet);
  }

  void dispose() {
    stopObserving();
    _controller.close();
  }
}
