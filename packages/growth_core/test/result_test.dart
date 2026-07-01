import 'package:flutter_test/flutter_test.dart';
import 'package:growth_core/growth_core.dart';

void main() {
  group('Result', () {
    test('Ok folds to success branch', () {
      const Result<int> r = Ok(5);
      expect(r.isOk, isTrue);
      expect(r.valueOrNull, 5);
      expect(r.failureOrNull, isNull);
      expect(r.fold((v) => v * 2, (_) => -1), 10);
    });

    test('Err folds to failure branch', () {
      const Result<int> r = Err(ServerFailure('boom'));
      expect(r.isErr, isTrue);
      expect(r.valueOrNull, isNull);
      expect(r.failureOrNull, const ServerFailure('boom'));
      expect(r.fold((v) => 'ok', (f) => f.message), 'boom');
    });

    test('map transforms Ok, passes through Err', () {
      expect(const Ok(2).map((v) => v + 1), const Ok(3));
      expect(
        const Err<int>(NetworkFailure('x')).map((v) => v + 1),
        const Err<int>(NetworkFailure('x')),
      );
    });
  });

  group('Failure equality', () {
    test('same type and message are equal', () {
      expect(const ServerFailure('a'), const ServerFailure('a'));
      expect(const ServerFailure('a'), isNot(const CacheFailure('a')));
    });
  });
}
