import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:register_project/constants/enum.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  final Connectivity connectivity;
  StreamSubscription? connectivityStreamSubscription;
  InternetCubit({
    required this.connectivity,
  }) : super(InternetLoading()) {
    connectivityStreamSubscription =
        connectivity.onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult == ConnectivityResult.wifi) {
        emit(InternetConnected(connectionType: ConnectionType.wifi));
      } else if (connectivityResult == ConnectivityResult.mobile) {
        emit(InternetConnected(connectionType: ConnectionType.mobile));
      } else if (connectivityResult == ConnectivityResult.none) {
        emit(InternetDisconnected());
      }
    });
  }

  @override
  Future<void> close() {
    connectivityStreamSubscription!.cancel();
    return super.close();
  }

  void emitInternetConnected(ConnectionType connectionType) {
    emit(InternetConnected(connectionType: connectionType));
  }

  void emitInternetDisconnected() {
    emit(InternetDisconnected());
  }
}
