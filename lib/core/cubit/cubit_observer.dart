import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CubitObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    if(kDebugMode) {
      debugPrint('onCreate: (${bloc.runtimeType}, $bloc)');
    }
    super.onCreate(bloc);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    if(kDebugMode) {
      debugPrint('onChange: (${bloc.runtimeType}, $change)');
    }
    super.onChange(bloc, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    if(kDebugMode) {
      debugPrint('onTransition: (${bloc.runtimeType}, $transition)');
    }
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    if(kDebugMode) {
      debugPrint('onError: (${bloc.runtimeType}, $error, $stackTrace)');
    }
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    if(kDebugMode) {
      debugPrint('onClose: (${bloc.runtimeType} )');
    }
    super.onClose(bloc);
  }
}