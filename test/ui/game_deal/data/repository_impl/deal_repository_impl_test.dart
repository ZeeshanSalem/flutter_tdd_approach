import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:games/core/error/exception.dart';
import 'package:games/core/network/network_info.dart';
import 'package:games/ui/game_deals/data/data_source/deal_remote_data_source.dart';
import 'package:games/ui/game_deals/data/model/response/deal_response.dart';
import 'package:games/ui/game_deals/data/respository_impl/deal_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../model/deal_data.dart';

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockDealRemoteDataSource extends Mock implements DealRemoteDataSourceImpl {}

void main() {
  late MockNetworkInfo mockNetworkInfo;
  late MockDealRemoteDataSource mockDealRemoteDataSource;
  late DealRepositoryImpl dealRepositoryImpl;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockDealRemoteDataSource = MockDealRemoteDataSource();
    dealRepositoryImpl = DealRepositoryImpl(
      networkInfo: mockNetworkInfo,
      dealRemoteDataSource: mockDealRemoteDataSource,
    );
  });

  group('GetDeals Repository Test', () {
    final dealList = [
      dealData,
    ];

    test('should check internet connection', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenReturn(true);
      // Stub
      when(() => mockDealRemoteDataSource.getDeals()).thenAnswer(
        (_) async => [],
      );
      // Act
      dealRepositoryImpl.getAllDeals();

      // Verify that networkInfo.isConnected was accessed
      verify(() => mockNetworkInfo.isConnected);
    });

    test(
        'When the network is connected and the server responds with a valid List.',
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenReturn(true);
      //Stub
      when(() => mockDealRemoteDataSource.getDeals())
          .thenAnswer((_) async => dealList.map((e) => e.toJson()).toList());

      final result = await dealRepositoryImpl.getAllDeals();

      // Assert
      expect(result.fold((l) => null, (r) => r), dealList);

      // Verify
      verify(() => mockNetworkInfo.isConnected).called(1);
      verify(() => mockDealRemoteDataSource.getDeals()).called(1);
    });

    test(
        'when the network is connected and the server responds with ServerException',
        () async {
      when(() => mockNetworkInfo.isConnected).thenReturn(true);
      when(() => mockDealRemoteDataSource.getDeals()).thenThrow(
        ServerException(
          dioError: DioException(
            requestOptions: RequestOptions(),
          ),
        ),
      );

      final result = await dealRepositoryImpl.getAllDeals();

      expect(
        result.fold(
            (l) => ServerException(
                  dioError: DioException(
                    requestOptions: RequestOptions(path: ''),
                  ),
                ),
            (r) => null),
        isA<ServerException>(),
      );

      // Verify
      verify(() => mockNetworkInfo.isConnected).called(1);
      verify(() => mockDealRemoteDataSource.getDeals()).called(1);
    });

    test('should return NoInternetException when the device is offline',
        () async {
      when(() => mockNetworkInfo.isConnected).thenReturn(false);

      when(() => mockDealRemoteDataSource.getDeals()).thenThrow(
        NoInternetException(message: 'No Internet Connection'),
      );

      final result = await dealRepositoryImpl.getAllDeals();

      expect(
        result.fold(
            (l) => NoInternetException(message: 'No Internet Connection'),
            (r) => null),
        isA<NoInternetException>(),
      );

      // Verify
      verify(() => mockNetworkInfo.isConnected).called(1);
      verifyNever(() => mockDealRemoteDataSource.getDeals());
    });
  });
}
