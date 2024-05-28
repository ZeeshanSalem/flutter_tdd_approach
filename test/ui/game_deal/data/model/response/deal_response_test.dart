import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:games/ui/game_deals/data/model/response/deal_response.dart';

import '../../../../../fixtures/reader.dart';
import '../deal_data.dart';

void main() {
  group('Model Test', () {



    test('FromJson', () {
      final Map<String, dynamic> json = jsonDecode(fixture('deal_data.json'));
      
      final deal = DealData.fromJson(json);
      
      expect(deal, dealData);
    });


    test('toJson', () {

      final deal = dealData.toJson();

      final Map<String, dynamic> json = jsonDecode(fixture('deal_data.json'));


      expect(deal, json);
    });
  });
}
