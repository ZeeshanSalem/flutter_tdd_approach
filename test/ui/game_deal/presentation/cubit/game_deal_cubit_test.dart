import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:games/core/error/exception.dart';
import 'package:games/core/error/models/error_response_model.dart';
import 'package:games/core/logger/app_logger.dart';
import 'package:games/core/utils/preferences_util.dart';
import 'package:games/ui/game_deals/domain/repository/deal_repository.dart';
import 'package:games/ui/game_deals/presentaion/cubit/game_deal_cubit.dart';
import 'package:games/ui/game_deals/presentaion/cubit/game_deal_state.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/model/deal_data.dart';

class MockAppLogger extends Mock implements AppLogger {}

class MockDealRepository extends Mock implements DealRepository {}

class MockPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockDealRepository mockDealRepository;
  late MockAppLogger appLogger;
  late GameDealCubit cubit;
  late MockPreferences mockPreferences;
  late PreferencesUtil preferencesUtil;

  setUp(() {
    mockDealRepository = MockDealRepository();
    appLogger = MockAppLogger();
    mockPreferences = MockPreferences();
    preferencesUtil =
        PreferencesUtil(preferences: mockPreferences, logger: appLogger);

    final getIt = GetIt.instance;
    getIt.registerSingleton<DealRepository>(mockDealRepository);
    getIt.registerSingleton<AppLogger>(appLogger);
    getIt.registerSingleton<PreferencesUtil>(preferencesUtil);

    cubit = GameDealCubit(
      dealRepository: mockDealRepository,
    );
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  final dealList = [dealData];

  group('GameDealCubit', () {
    blocTest<GameDealCubit, GameDealState>(
      'emits [loading, success] when data is fetched successfully',
      build: () {
        when(() => mockDealRepository.getAllDeals())
            .thenAnswer((_) async => Right(
                  dealList,
                ));
        return cubit;
      },
      act: (cubit) {
        cubit.getDeals();
      },
      expect: () => [
        const GameDealState(status: GameDealStatus.loading),
        GameDealState(
          status: GameDealStatus.success,
          deals: dealList,
        ),
      ],
    );

    blocTest<GameDealCubit, GameDealState>(
      'emits [loading, failure] when fetching data fails',
      build: () {
        when(() => mockDealRepository.getAllDeals())
            .thenAnswer((_) async => Left(
                  ServerException(
                    dioError: DioException(
                      requestOptions: RequestOptions(),
                    ),
                  ),
                ));
        return cubit;
      },
      act: (cubit) => cubit.getDeals(),
      expect: () => [
        const GameDealState(status: GameDealStatus.loading),
        GameDealState(
          status: GameDealStatus.failure,
          errorModel: ErrorModel(message: 'Failed to connect with server'),
        ),
      ],
    );

    blocTest<GameDealCubit, GameDealState>(
        'emits [loading, failure] when no internet',
        build: () {
          when(() => mockDealRepository.getAllDeals()).thenAnswer(
            (_) async => Left(
              NoInternetException(message: 'No internet connection available'),
            ),
          );
          return cubit;
        },
        act: (cubit) => cubit.getDeals(),
        expect: () => [
              const GameDealState(status: GameDealStatus.loading),
              GameDealState(
                status: GameDealStatus.failure,
                errorModel:
                    ErrorModel(message: 'No internet connection available'),
              ),
            ]);
  });
}
