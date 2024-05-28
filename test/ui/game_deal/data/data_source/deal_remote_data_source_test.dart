import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:games/core/error/exception.dart';
import 'package:games/core/network/network_client.dart';
import 'package:games/core/network/network_constants.dart';
import 'package:games/ui/game_deals/data/data_source/deal_remote_data_source.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/reader.dart';

class MockNetworkClient extends Mock implements NetworkClient {}

void main() {
  late DealRemoteDataSource dealRemoteDataSource;
  late MockNetworkClient mockNetworkClient;

  setUpAll(() {
    // Registering fallback value for RequestType
    registerFallbackValue(RequestType.get);
  });

  setUp(() {
    mockNetworkClient = MockNetworkClient();
    dealRemoteDataSource = DealRemoteDataSource(
      networkClient: mockNetworkClient,
    );
  });

  group('get Deals', () {
    test('Constructor', () {
      expect(dealRemoteDataSource, isNotNull);
    });

    test('should return data when the response status code is 200', () async {
      final responsePayload = jsonDecode(fixture('success_response.json'));

      final response = Response(
        requestOptions: RequestOptions(),
        statusCode: 200,
        data: responsePayload,
      );

      when(() => mockNetworkClient.invoke(
            any(),
            any(),
          )).thenAnswer(
        (_) async => response,
      );

      // Act
      final result = await dealRemoteDataSource.getDeals();

      expect(result, responsePayload);

      verify(() => mockNetworkClient.invoke(kGameDeals, RequestType.get))
          .called(1);
    });

    test('should thrown ServerException when response status code is not 200 ',
        () async {
      final response = Response(
        requestOptions: RequestOptions(),
        statusCode: 500,
      );

      when(() => mockNetworkClient.invoke(any(), any()))
          .thenAnswer((_) async => response);

      // Act & Assert
      expect(
        () async => await dealRemoteDataSource.getDeals(),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
