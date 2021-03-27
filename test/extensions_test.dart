import 'dart:convert';
import "package:flutter_test/flutter_test.dart";
import 'package:floater/src/extensions.dart';

class _ItemValuePair {
  String item;
  int value;

  _ItemValuePair({required this.item, required this.value});
}

void main() {
  group("MapStringDynamicExt", () {
    group("getValue", () {
      Map<String, dynamic>? targetCountry;
      Map<String, dynamic>? targetAddress;
      Map<String, dynamic>? target;

      setUp(() {
        targetCountry = {"name": "Canada", "code": "CA"};

        targetAddress = {"street": "711 Kennedy rd", "city": "Toronto", "country": targetCountry};

        target = {"firstName": "John", "lastName": "Smith", "address": targetAddress};
      });

      tearDown(() {
        targetCountry = null;
        targetAddress = null;
        target = null;
      });

      // test("should return null if the key is null", () {
      //   late String key;
      //   final value = target!.getValue(key);
      //   expect(value, null);
      // });

      test("should return null if the key is an empty string", () {
        final key = "";
        final value = target!.getValue(key);
        expect(value, null);
      });

      test("should return null if the key is a string with just whitespace", () {
        final key = "  ";
        final value = target!.getValue(key);
        expect(value, null);
      });

      test("should return null if the key does not exist on the target object", () {
        final key = "something";
        final value = target!.getValue(key);
        expect(value, null);
      });

      test("should return value if the key exists on the target object", () {
        final key = "firstName";
        final value = target!.getValue(key);
        expect(value, "John");
      });

      test("should return value if the multi level key exists on the target object", () {
        final key = "address.country";
        final value = target!.getValue(key);
        expect(value, targetCountry);
      });

      test("should return value if the multi level (3 levels) key exists on the target object", () {
        final key = "address.country.code";
        final value = target!.getValue(key);
        expect(value, "CA");
      });

      test(
          "should return null if the top level of a multi level key does not exist on the target object",
          () {
        final key = "something.country";
        final value = target!.getValue(key);
        expect(value, null);
      });

      test(
          "should return null if the middle level of a multi level key does not exist on the target object",
          () {
        final key = "address.something.code";
        final value = target!.getValue(key);
        expect(value, null);
      });

      test(
          "should return null if the bottom level of a multi level key does not exist on the target object",
          () {
        final key = "address.country.something";
        final value = target!.getValue(key);
        expect(value, null);
      });
    });

    group("setValue", () {
      Map<String, dynamic>? targetCountry;
      Map<String, dynamic>? targetAddress;
      Map<String, dynamic>? target;
      String? targetString;

      final getCurrentTargetString = () => jsonEncode(target);

      setUp(() {
        targetCountry = {"name": "Canada", "code": "CA"};

        targetAddress = {"street": "711 Kennedy rd", "city": "Toronto", "country": targetCountry};

        target = {"firstName": "John", "lastName": "Smith", "address": targetAddress};

        targetString = jsonEncode(target);
      });

      tearDown(() {
        targetCountry = null;
        targetAddress = null;
        target = null;
        targetString = null;
      });

      // test("should not do anything if the key is null", () {
      //   late String key;
      //   target!.setValue(key, "some val");
      //   expect(getCurrentTargetString(), targetString);
      // });

      test("should not do anything if the key is an empty string", () {
        final key = "";
        target!.setValue(key, "some val");
        expect(getCurrentTargetString(), targetString);
      });

      test("should not do anything if the key is a string with just whitespace", () {
        final key = "  ";
        target!.setValue(key, "some val");
        expect(getCurrentTargetString(), targetString);
      });

      test("should set value given a key that is a single level key", () {
        final key = "firstName";
        final value = "Kevin";
        target!.setValue(key, value);
        expect(target![key], value);
      });

      test("should set value given a multi level key", () {
        final key = "address.country.code";
        final value = "us";
        target!.setValue(key, value);
        expect(target!["address"]["country"]["code"], value);
      });

      test(
          "should set value given a single level key even if key does not already exist on the object",
          () {
        final key = "nickName";
        final value = "Johnny";
        target!.setValue(key, value);
        expect(target!["nickName"], value);
      });

      test(
          "should set value given a multi level key even if the bottom level key does not already exist on the object",
          () {
        final key = "address.country.language";
        final value = "en-ca";
        target!.setValue(key, value);
        expect(target!["address"]["country"]["language"], value);
      });

      test(
          "should set value given a multi level key even if the middle level key does not already exist on the object",
          () {
        final key = "address.province.name";
        final value = "Ontario";
        target!.setValue(key, value);
        expect(target!["address"]["province"]["name"], value);
      });

      test(
          "should set value given a multi level key even of none of the key levels already exist on the object",
          () {
        final key = "shippingAddress.province.name";
        final value = "Quebec";
        target!.setValue(key, value);
        expect(target!["shippingAddress"]["province"]["name"], value);
      });
    });
  });

  group("ListExt", () {
    late List<int> numbers;
    late List<String> strings;
    late List<String> empty;
    late List<int> single;

    late List<_ItemValuePair> objects;
    final first = new _ItemValuePair(item: "item1", value: 1);
    final second = new _ItemValuePair(item: "item2", value: 2);
    final third = new _ItemValuePair(item: "item3", value: 3);
    final fourth = new _ItemValuePair(item: "item4", value: 4);

    setUp(() {
      numbers = [2, 3, 1, 7];
      strings = ["charlie", "alpha", "india", "bravo"];
      empty = [];
      single = [1];

      objects = [fourth, first, third, second];
    });

    final arrayEqual = (List<dynamic> actual, List<dynamic> expected) {
      if (actual == expected) return true;

      // if (actual == null || expected == null) return false;

      if (!(actual is List) || !(expected is List)) return false;

      if (actual.length != expected.length) return false;

      for (var i = 0; i < actual.length; i++) {
        if (actual[i] == expected[i]) continue;

        return false;
      }

      return true;
    };

    group("find", () {
      test("should return a int value when the int is present in a list of int", () {
        final value = numbers.find((element) => element == 2);
        expect(value, 2);
      });

      test("should return null when the value is not present in a list of int", () {
        final value = numbers.find((element) => element == 122);
        expect(value, null);
      });

      test("should return the string value when the int is present in a list of strings", () {
        final value = strings.find((element) => element == "india");
        expect(value, "india");
      });

      test("should return null value when the string is not present in a list of strings", () {
        final value = strings.find((element) => element == "india a");
        expect(value, null);
      });

      test(
          "should return the object when the object with the property is present in a list of object",
          () {
        final value = objects.find((element) => element.value == 4);
        expect(value, fourth);
      });

      test(
          "should return the null when the object with the property is not present in a list of object",
          () {
        final value = objects.find((element) => element.value == 4123);
        expect(value, null);
      });
    });

    group("orderBy", () {
      test("should return a new empty array object when target is an empty array", () {
        final ordered = empty.orderBy();
        expect(ordered.length, 0);
        expect(ordered != empty, true);
      });

      test(
          "should return a new array object of the same length as the target when target is a single element array",
          () {
        final ordered = single.orderBy();
        expect(ordered.length, 1);
        expect(ordered != single, true);
      });

      test(
          "should return a new array object of the same length as the target when target is a n element array",
          () {
        final ordered = numbers.orderBy();
        expect(ordered.length, numbers.length);
        expect(ordered != numbers, true);
      });

      test("should return array of numbers in ascending order", () {
        final ordered = numbers.orderBy();
        expect(arrayEqual(ordered, [1, 2, 3, 7]), true);
      });

      test("should return array of strings in ascending order", () {
        final ordered = strings.orderBy();
        expect(arrayEqual(ordered, ["alpha", "bravo", "charlie", "india"]), true);
      });

      test("should return array of objects in ascending order", () {
        final ordered = objects.orderBy((t) => t.item);
        expect(arrayEqual(ordered, [first, second, third, fourth]), true);
      });
    });

    group("orderByDesc", () {
      test("should return a new empty array object when target is an empty array", () {
        final ordered = empty.orderByDesc();
        expect(ordered.length, empty.length);
        expect(ordered != empty, true);
      });

      test(
          "should return a new array object of the same length as the target when target is a single element array",
          () {
        final ordered = single.orderByDesc();
        expect(ordered.length, single.length);
        expect(ordered != single, true);
      });

      test(
          "should return a new array object of the same length as the target when target is a n element array",
          () {
        final ordered = numbers.orderByDesc();
        expect(ordered.length, numbers.length);
        expect(ordered != numbers, true);
      });

      test("should return array of numbers in descending order", () {
        final ordered = numbers.orderByDesc();
        expect(arrayEqual(ordered, [7, 3, 2, 1]), true);
      });

      test("should return array of strings in descending order", () {
        final ordered = strings.orderByDesc();
        expect(arrayEqual(ordered, ["india", "charlie", "bravo", "alpha"]), true);
      });

      test("should return array of objects in descending order", () {
        final ordered = objects.orderByDesc((t) => t.value);
        expect(arrayEqual(ordered, [fourth, third, second, first]), true);
      });
    });
  });
}
