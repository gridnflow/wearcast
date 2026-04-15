import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:wearcast/features/location/domain/entities/coordinates.dart';
import 'package:wearcast/features/location/domain/location_service.dart';
import 'package:wearcast/features/location/presentation/providers/location_providers.dart';
import 'package:wearcast/features/home/presentation/screens/home_screen.dart';

class _MockLocationService extends Mock implements LocationService {}

void main() {
  testWidgets('HomeScreen shows loading while fetching location',
      (WidgetTester tester) async {
    final mockService = _MockLocationService();
    when(() => mockService.getCurrentCoordinates()).thenAnswer(
      (_) async => const Coordinates(latitude: 37.5, longitude: 127.0),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          locationServiceProvider.overrideWithValue(mockService),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    // On first frame, location is loading.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
