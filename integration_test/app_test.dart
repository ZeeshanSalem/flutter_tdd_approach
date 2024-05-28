import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:games/core/error/models/error_response_model.dart';
import 'package:games/ui/game_deals/presentaion/ui/deal_main_view.dart';
import 'package:integration_test/integration_test.dart';
import 'package:games/ui/game_deals/presentaion/cubit/game_deal_cubit.dart';
import 'package:games/ui/game_deals/presentaion/cubit/game_deal_state.dart';
import 'package:mocktail/mocktail.dart';

import '../test/ui/game_deal/data/model/deal_data.dart';

class MockGameDealCubit extends MockCubit<GameDealState>
    implements GameDealCubit {}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;


  group('end-to-end Test', () {
    late MockGameDealCubit mockGameDealCubit;

    setUp(() {
      mockGameDealCubit = MockGameDealCubit();
    });

    Widget homeWidget() {
      return MaterialApp(
        home: BlocProvider<GameDealCubit>(
          create: (context) => mockGameDealCubit,
          child: const DealMainView(),
        ),
      );
    }

    testWidgets('should display CircularProgressIndicator when loading',
            (WidgetTester tester) async {
          when(() => mockGameDealCubit.state)
              .thenReturn(const GameDealState(status: GameDealStatus.loading));
          
          await binding.traceAction(() async {
            await tester.pumpWidget(
              homeWidget(),
            );

            expect(find.byType(CircularProgressIndicator), findsOneWidget);
          }, reportKey: 'loading_state');


        }, tags: ['no-ci']);

    testWidgets(
        'should display FailureWidget and retry when there is a failure',
            (WidgetTester tester) async {
          when(() => mockGameDealCubit.state).thenReturn(
            const GameDealState(
              status: GameDealStatus.failure,
            ),
          );

          await tester.pumpWidget(homeWidget());
          expect(find.text('Try Again'), findsOneWidget);
          // Simulate a button tap
          await tester.tap(find.text('Try Again'));
          await tester.pump();
          verify(() => mockGameDealCubit.getDeals()).called(1);
        });

    testWidgets('should display NoDataFound when there are no deals', (
        WidgetTester tester) async {
      when(() => mockGameDealCubit.state).thenReturn(
          const GameDealState(status: GameDealStatus.success, deals: []));

      await tester.pumpWidget(homeWidget());
      expect(find.text('No Data Found.'), findsOneWidget);
      await tester.tap(find.text('Refresh'),);
      await tester.pump();
      verify(() => mockGameDealCubit.getDeals()).called(1);
    });


    testWidgets('should display ListView when there are deals', (
        WidgetTester tester) async {
      when(() => mockGameDealCubit.state).thenReturn(
        GameDealState(status: GameDealStatus.success, deals: [dealData],),);

      await tester.pumpWidget(homeWidget());

      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Farming Simulator 22'), findsOneWidget);


    },
    );
  });
}



// final listFinder = find.byType(ListView);
// await binding.traceAction(() async {
// await tester.fling(listFinder, const Offset(0, -500), 10000);
// await tester.pumpAndSettle();
//
// await tester.fling(listFinder, const Offset(0, 500), 10000);
// await tester.pumpAndSettle();
//
// }, reportKey: 'offer_scrolling');