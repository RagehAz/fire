import 'package:basics/fire_helpers/models/b_fire/fire_comparison_enum.dart';
import 'package:basics/fire_helpers/models/b_fire/fire_finder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  group('FireFinder equality', () {

    const finder1 = FireFinder(
      field: 'field1',
      comparison: FireComparison.equalTo,
      value: 10,
    );

    const finder1Copy = FireFinder(
      field: 'field1',
      comparison: FireComparison.equalTo,
      value: 10,
    );

    const finder2 = FireFinder(
      field: 'field2',
      comparison: FireComparison.greaterThan,
      value: 'x',
    );

    test('identical field/comparison/value are equal', () {
      expect(finder1, equals(finder1Copy));
      expect(finder1.hashCode, equals(finder1Copy.hashCode));
    });

    test('differing finders are not equal', () {
      expect(finder1 == finder2, isFalse);
    });

    test('checkFindersAreIdentical treats both null as identical', () {
      expect(FireFinder.checkFindersAreIdentical(null, null), isTrue);
    });

    test('checkFindersAreIdentical treats one null as not identical', () {
      expect(FireFinder.checkFindersAreIdentical(finder1, null), isFalse);
      expect(FireFinder.checkFindersAreIdentical(null, finder2), isFalse);
    });

    test('checkFindersAreIdentical compares field values', () {
      expect(FireFinder.checkFindersAreIdentical(finder1, finder1Copy), isTrue);
      expect(FireFinder.checkFindersAreIdentical(finder1, finder2), isFalse);
    });

    test('checkFindersListsAreIdentical treats both null as identical', () {
      expect(FireFinder.checkFindersListsAreIdentical(null, null), isTrue);
    });

    test('checkFindersListsAreIdentical treats both empty as identical', () {
      expect(FireFinder.checkFindersListsAreIdentical(<FireFinder>[], <FireFinder>[]), isTrue);
    });

    test('checkFindersListsAreIdentical compares list contents in order', () {
      expect(
        FireFinder.checkFindersListsAreIdentical([finder1, finder2], [finder1Copy, finder2]),
        isTrue,
      );
      expect(
        FireFinder.checkFindersListsAreIdentical([finder1, finder2], [finder2, finder1]),
        isFalse,
      );
    });

    test('checkFindersListsAreIdentical detects differing lengths', () {
      expect(
        FireFinder.checkFindersListsAreIdentical([finder1], [finder1, finder2]),
        isFalse,
      );
    });

    test('toString includes field, comparison, and value', () {
      expect(finder1.toString(), 'FireFinder(field: field1, comparison: FireComparison.equalTo, value: 10)');
    });

  });

}