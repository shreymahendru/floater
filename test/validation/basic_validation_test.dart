import "package:flutter_test/flutter_test.dart";
import 'package:floater/src/validation.dart';

class TestVal {
  String firstName;
  String lastName;
  int age;
  List<int> scores;
  dynamic address;
  bool active;
}

void main() {
  group("Basic validation", () {
    TestVal testVal;
    Validator<TestVal> validator;

    setUp(() {
      testVal = new TestVal();
      testVal.firstName = "Nivin";
      testVal.lastName = "Joseph";
      testVal.age = 31;
      testVal.scores = [200, 400, 800];
      testVal.address = {"street": "15 Benton rd", "province": "ON"};

      validator = new Validator<TestVal>();
      validator
          .prop("firstName", (t) => t.firstName)
          .isRequired()
          .ensure((t) => t.startsWith("N"))
          .withMessage(message: "should begin with 'N'");
      validator.prop("lastName", (t) => t.lastName).isOptional().ensure((t) => t.endsWith("h"));
      validator
          .prop("age", (t) => t.age)
          .isRequired()
          .ensure((t) => t >= 18)
          .withMessage(message: "should be greater than equal to 18");
    });

    test("should pass given a passing value", () {
      validator.validate(testVal);
      expect(validator.isValid, true);
    });

    test("should fail given a failing value", () {
      testVal.firstName = "Kevin";
      validator.validate(testVal);
      expect(validator.isValid, false);
    });
    test("should give the correct error message given a failing value", () {
      testVal.age = 17;

      validator.validate(testVal);

      expect(validator.errors.getError("age"), "should be greater than equal to 18");
    });
  });

  group("Validator", () {
    TestVal testVal;
    Validator<TestVal> validator;

    setUp(() {
      testVal = new TestVal();
      testVal.firstName = "Nivin";
      testVal.lastName = "Joseph";
      testVal.age = 31;
      testVal.scores = [200, 400, 800];
    });

    group("init", () {
      test("should init with no errors and with no property validators and should be valid", () {
        validator = new Validator<TestVal>();

        expect(validator.hasRules, false, reason: "Should have no rules");
        expect(validator.hasErrors, false, reason: "Should have no errors");
        expect(validator.isValid, true, reason: "Should be valid");
      });
    });

    group("prop", () {
      test("should create a validation rule for a given property", () {
        validator = new Validator<TestVal>();
        validator.prop("firstName", (t) => t.firstName);

        expect(validator.hasRules, true, reason: "Should have a rule");
        expect(validator.hasErrors, false, reason: "Should have no errors");
        expect(validator.isValid, true, reason: "Should be valid");
      });

      test("should throw an ArgumentNullException when given null", () {
        validator = new Validator<TestVal>();
        expect(() => validator.prop(null, null), throwsArgumentError);
      });

      test("should throw an ArgumentException when property given is an empty string", () {
        validator = new Validator<TestVal>();
        expect(() => validator.prop("", (t) => null), throwsArgumentError);
      });
    });

    group("validate", () {
      test("should create a validation rule for a given property in the object and should be valid",
          () {
        validator = new Validator<TestVal>();
        validator.prop("firstName", (t) => t.firstName).isRequired();

        validator.validate(testVal);

        expect(validator.isValid, true);
      });

      test("should create a validation rule for a property not in the object and should be invalid",
          () {
        validator = new Validator<TestVal>();
        validator.prop("no-name", (t) => null).isRequired();

        validator.validate(testVal);

        expect(validator.isValid, false);
      });

      test("should throw an ArgumentNullException when validating null object", () {
        validator = new Validator<TestVal>();
        validator.prop("firstName", (t) => t.firstName).isRequired();

        expect(() => validator.validate(null), throwsArgumentError);
      });
    });
  });

  group("PropertyValidator", () {
    TestVal testVal;
    Validator<TestVal> validator;

    setUp(() {
      testVal = new TestVal();
      testVal.firstName = "Nivin";
      testVal.lastName = "Joseph";
      testVal.age = 31;
      testVal.scores = [200, 400, 800];
      testVal.address = {"street": "15 Benton rd", "province": "ON"};
      testVal.active = true;
    });

    group("isRequired", () {
      test("should pass when the property is given in the object being validated", () {
        validator = new Validator<TestVal>();
        validator.prop("firstName", (t) => t.firstName).isRequired();

        validator.validate(testVal);

        expect(validator.isValid, true);
      });

      test("should fail when the property is set to null in the object being validated", () {
        validator = new Validator<TestVal>();
        testVal.firstName = null;
        validator.prop("firstName", (t) => t.firstName).isRequired();

        validator.validate(testVal);

        expect(validator.isValid, false);
      });

      test("should fail when the property is set to undefined in object being validated", () {
        validator = new Validator<TestVal>();
        testVal.firstName = null;
        validator.prop("firstName", (t) => t.firstName).isRequired();

        validator.validate(testVal);

        expect(validator.isValid, false);
      });

      test("should fail when the property is not given in the object being validated", () {
        validator = new Validator<TestVal>();
        validator.prop("no-name", (t) => null).isRequired();

        validator.validate(testVal);

        expect(validator.isValid, false);
      });
    });

    group("isOptional", () {
      test("should pass when the property is not given in the object being validated", () {
        validator = new Validator<TestVal>();
        validator.prop("no-name", (t) => null).isOptional();

        validator.validate(testVal);

        expect(validator.isValid, true);
      });

      test("should pass when the property is set to null in the object being validated", () {
        validator = new Validator<TestVal>();
        validator.prop("firstName", (t) => t.firstName).isOptional();
        testVal.firstName = null;

        validator.validate(testVal);

        expect(validator.isValid, true);
      });
      test("should pass when the property is given in the object being validated", () {
        validator = new Validator<TestVal>();
        validator.prop("firstName", (t) => t.firstName).isOptional();

        validator.validate(testVal);

        expect(validator.isValid, true);
      });
    });

    group("ensure", () {
      test(
          "should pass when the property(string) is given in the object being validated does satisfy the given predicate",
          () {
        validator = new Validator<TestVal>();
        validator.prop("firstName", (t) => t.firstName).ensure((t) => t.length >= 2);

        validator.validate(testVal);

        expect(validator.isValid, true);
      });

      test(
          "should fail when the property(string) is given in the object being validated doesn't satisfy the given predicate",
          () {
        validator = new Validator<TestVal>();
        validator.prop("firstName", (t) => t.firstName).ensure((t) => t.length <= 2);

        validator.validate(testVal);

        expect(validator.isValid, false);
      });

      test("should throw an exception when the property is not given in the object being validated",
          () {
        validator = new Validator<TestVal>();
        validator.prop<String>("no-name", (t) => null).ensure((t) => t.length <= 2);

        expect(() => validator.validate(testVal), throwsNoSuchMethodError);
      });

      test(
          "should throw and exception when the property is set to null in the object being validated",
          () {
        validator = new Validator<TestVal>();
        validator.prop("firstName", (t) => t.firstName).ensure((t) => t.length <= 2);
        testVal.firstName = null;

        expect(() => validator.validate(testVal), throwsNoSuchMethodError);
      });

      test(
          "should pass when the property(array) is given in the object being validated does satisfy the given predicate",
          () {
        bool checkArray(List<int> array) {
          var sum = 0;
          for (final a in array) {
            sum += a;
          }
          return sum > 100;
        }

        validator = new Validator<TestVal>();
        validator.prop("scores", (t) => t.scores).ensure((t) => checkArray(t));

        validator.validate(testVal);

        expect(validator.isValid, true);
      });

      test(
          "should fail when the value(array) given in the object being validated doesn't satisfy the given predicate",
          () {
        bool checkArray(List<int> array) {
          var sum = 0;
          for (final a in array) {
            sum += a;
          }
          return sum < 100;
        }

        validator = new Validator<TestVal>();
        validator.prop("scores", (t) => t.scores).ensure((t) => checkArray(t));

        validator.validate(testVal);

        expect(validator.isValid, false);
      });
    });

    group("ensureT", () {
      test(
          "should pass when the property(string) given in the object being validated does satisfy the given predicate",
          () {
        validator = new Validator<TestVal>();
        validator.prop("firstName", (t) => t.firstName).ensureT((t) => t.firstName.length >= 2);

        validator.validate(testVal);

        expect(validator.isValid, true);
      });

      test(
          "should fail when the property(string) given in the object being validated doesn't satisfy the given predicate",
          () {
        validator = new Validator<TestVal>();
        validator.prop("firstName", (t) => t.firstName).ensureT((t) => t.firstName.length <= 2);

        validator.validate(testVal);

        expect(validator.isValid, false);
      });

      test(
          "should pass when the property(array) given in the object being validated doesn't satisfy the given predicate",
          () {
        bool checkArray(List<int> array) {
          var sum = 0;
          for (final a in array) {
            sum += a;
          }
          return sum > 100;
        }

        validator = new Validator<TestVal>();
        validator.prop("scores", (t) => t.scores).ensureT((t) => checkArray(t.scores));

        validator.validate(testVal);

        expect(validator.isValid, true);
      });

      test(
          "should fail when the property(array) given in the object being validated doesn't satisfy the given predicate",
          () {
        bool checkArray(List<int> array) {
          var sum = 0;
          for (final a in array) {
            sum += a;
          }
          return sum < 100;
        }

        validator = new Validator<TestVal>();
        validator.prop("scores", (t) => t.scores).ensureT((t) => checkArray(t.scores));
        
        validator.validate(testVal);

        expect(validator.isValid, false);
      });
    });

    group("useValidationRule", () {
      test(
          "should pass when the property given in the object being validated does satisfy the given validation rule predicate",
          () {
        validator = new Validator<TestVal>();
        validator.prop("firstName", (t) => t.firstName).useValidationRule(
            new ValidationRule((t) => t[0] == "N", "firstName Does not start with N"));

        validator.validate(testVal);

        expect(validator.isValid, true, reason: "Should be valid");
        expect(validator.hasErrors, false, reason: "Should have no errors");
      });

      test(
          "should pass when the property given in the object being validated doesn't satisfy the given validation rule predicate",
          () {
        validator = new Validator<TestVal>();
        validator.prop("firstName", (t) => t.firstName).useValidationRule(
            new ValidationRule((t) => t[0] == "N", "firstName Does not start with N"));
        testVal.firstName = "John";

        validator.validate(testVal);

        expect(validator.isValid, false, reason: "Should be invalid");
        expect(validator.hasErrors, true, reason: "Should have errors");
        expect(validator.errors.getError("firstName"), "firstName Does not start with N",
            reason: "Should have the correct error message");
      });
    });

    group("useValidator", () {
      test("should pass validation given 2 validators", () {
        final secondaryValidator = new Validator<dynamic>();
        secondaryValidator.prop("province", (t) => t["province"]).ensure((t) => t == "ON");

        validator = new Validator<TestVal>();
        validator.prop("address", (t) => t.address).isRequired().useValidator(secondaryValidator);

        validator.validate(testVal);

        expect(validator.isValid, true);
      });

      test("should fail validation when secondary validator fails", () {
        final secondaryValidator = new Validator<dynamic>();
        secondaryValidator.prop("province", (t) => t["province"]).ensure((t) => t != "ON");

        validator = new Validator<TestVal>();
        validator
            .prop("address", (t) => t.address)
            .isRequired()
            .ensure((t) => t["street"] == "15 Benton rd")
            .useValidator(secondaryValidator);

        validator.validate(testVal);

        expect(validator.isValid, false, reason: "Should be invalid");
        expect(validator.errors.getError("address.province"), "Invalid value",
            reason: "Should have error message of the secondary validator");
      });

      test("should fail validation when third validator fails", () {
        final thirdValidator = new Validator<dynamic>();
        thirdValidator.prop("one", (value) => value["one"]).ensure((t) => t == "xyz");
        thirdValidator.prop("two", (value) => value["two"]).isRequired();

        final secondaryValidator = new Validator<dynamic>();
        secondaryValidator.prop("province", (t) => t["province"]).ensure((t) => t != "ON");
        secondaryValidator.prop("street", (value) => value["street"]).useValidator(thirdValidator);

        final val = TestVal();
        val.firstName = "Nivin";
        val.lastName = "Joseph";
        val.age = 31;
        val.scores = [200, 400, 800];
        val.address = {
          "province": "QC",
          "street": {"one": "abc", "two": null}
        };

        validator = new Validator<TestVal>();
        validator.prop("address", (t) => t.address).isRequired().useValidator(secondaryValidator);

        validator.validate(val);

        expect(validator.isValid, false, reason: "Should be invalid");
        expect(validator.errors.getError("address.street.one"), "Invalid value",
            reason: "Should have error message of the third validator");
        expect(validator.errors.getError("address.street.two"), "Required",
            reason: "Should have error message of the third validator");
      });

      test("should fail validation when primary validator fails", () {
        final secondaryValidator = new Validator<dynamic>();
        secondaryValidator.prop("province", (t) => t["province"]).ensure((t) => t == "ON");

        validator = new Validator<TestVal>();
        validator
            .prop("address", (t) => t.address)
            .isRequired()
            .ensure((t) => t["street"] == "16 Benton rd")
            .useValidator(secondaryValidator);

        validator.validate(testVal);

        expect(validator.isValid, false, reason: "Should be invalid");
        expect(validator.errors.getError("address"), "Invalid value",
            reason: "Should have error message of the primary validator");
      });

      test("should fail validation when both validators fails", () {
        final secondaryValidator = new Validator<dynamic>();
        secondaryValidator.prop("province", (t) => t["province"]).ensure((t) => t == "AB");

        validator = new Validator<TestVal>();
        validator
            .prop("address", (t) => t.address)
            .isRequired()
            .ensure((t) => t["street"] == "16 Benton rd")
            .useValidator(secondaryValidator);

        validator.validate(testVal);

        expect(validator.isValid, false, reason: "Should be invalid");
        expect(validator.errors.getError("address"), "Invalid value",
            reason: "Should have the error message of the primary validator");
      });
    });

    group("when", () {
      test(
          "should pass when the if condition is true and the object being validated does satisfy the given target validation rule",
          () {
        validator = new Validator<TestVal>();
        validator
            .prop("firstName", (t) => t.firstName)
            .ensure((t) => t == "Nivin")
            .when((t) => t.firstName.length > 2);

        validator.validate(testVal);

        expect(validator.isValid, true);
      });

      test(
          "should fail when the if condition is true and the object being validated doesn't satisfy the given target validation rule",
          () {
        validator = new Validator<TestVal>();
        validator
            .prop("firstName", (t) => t.firstName)
            .ensure((t) => t == "Shrey")
            .when((t) => t.firstName.length > 2);

        validator.validate(testVal);

        expect(validator.isValid, false);
      });

      test(
          "should pass when the if condition is false and the object being validated does satisfy the given target validation rule",
          () {
        validator = new Validator<TestVal>();
        validator
            .prop("firstName", (t) => t.firstName)
            .ensure((t) => t == "Nivin")
            .when((t) => t.firstName.length == 2);

        validator.validate(testVal);

        expect(validator.isValid, true);
      });

      test(
          "should pass when the if condition is false and the object being validated doesn't satisfy the given target validation rule",
          () {
        validator = new Validator<TestVal>();
        validator
            .prop("firstName", (t) => t.firstName)
            .ensure((t) => t == "Shrey")
            .when((t) => t.firstName.length == 2);

        validator.validate(testVal);

        expect(validator.isValid, true);
      });
    });

    group("chaining", () {
      test(
          "should pass when the object being validated does satisfy the predicates of 2 ensures chained together",
          () {
        validator = new Validator<TestVal>();
        validator
            .prop("firstName", (t) => t.firstName)
            .ensure((t) => t.length > 2)
            .ensure((t) => t == "Nivin");
        validator.validate(testVal);
        expect(validator.isValid, true);
      });

      test(
          "should fail when the object being validated does satisfy the predicate of the first ensure and doesn't satisfy the predicate of the second ensure",
          () {
        validator = new Validator<TestVal>();
        validator
            .prop("firstName", (t) => t.firstName)
            .ensure((t) => t.length > 2)
            .ensure((t) => t == "Shrey");

        validator.validate(testVal);

        expect(validator.isValid, false);
      });

      test(
          "should pass when 2 ensures that are true and false respectively are chained with a if(false) on the second",
          () {
        validator = new Validator<TestVal>();
        validator
            .prop("firstName", (t) => t.firstName)
            .ensure((t) => t.length > 2)
            .ensure((t) => t == "Shrey")
            .when((t) => t.lastName == "Mahendru");

        validator.validate(testVal);

        expect(validator.isValid, true);
      });

      test(
          "should pass when 2 ensures that are true and false respectively are chained with a if(true) on the second in the object being validated",
          () {
        validator = new Validator<TestVal>();
        validator
            .prop("firstName", (t) => t.firstName)
            .ensure((t) => t.length > 2)
            .ensure((t) => t == "Nivin")
            .when((t) => t.lastName == "Joseph");

        validator.validate(testVal);

        expect(validator.isValid, true);
      });

      test(
          "should pass when a given property is required and ensure is true in the object being validated",
          () {
        validator = new Validator<TestVal>();
        validator.prop("firstName", (t) => t.firstName).isRequired().ensure((t) => t == "Nivin");

        validator.validate(testVal);

        expect(validator.isValid, true);
      });

      test(
          "should fail when a given property is required and ensure is false in the object being validated",
          () {
        validator = new Validator<TestVal>();
        validator.prop("firstName", (t) => t.firstName).isRequired().ensure((t) => t == "Shrey");

        validator.validate(testVal);

        expect(validator.isValid, false);
      });

      test(
          "should pass when a property is optional and ensure is false and property is not given in the object being validated",
          () {
        validator = new Validator<TestVal>();
        validator
            .prop<dynamic>("middleName", (t) => null)
            .isOptional()
            .ensure((t) => t == "mid-name");

        validator.validate(testVal);

        expect(validator.isValid, true);
      });

      test(
          "should fail when a property is optional and ensure is false and property is given in the object being validated",
          () {
        validator = new Validator<TestVal>();
        validator.prop("firstName", (t) => t.firstName).isOptional().ensure((t) => t == "mid-name");

        validator.validate(testVal);

        expect(validator.isValid, false);
      });
    });

    group("withMessage", () {
      test(
          "should fail with correct message when target validation rule doesn't satisfy for the object being validated",
          () {
        validator = new Validator<TestVal>();
        validator
            .prop<dynamic>("middleName", (t) => null)
            .isRequired()
            .withMessage(message: "middle name is required");

        validator.validate(testVal);

        expect(validator.isValid, false, reason: "Should be invalid");
        expect(validator.hasErrors, true, reason: "Should have errors");
        expect(validator.errors.getError("middleName"), "middle name is required");
      });

      test(
          "should fail with correct message of the 1st validation rule when target validations are false, true, true respectively for the object being validated",
          () {
        validator = new Validator<TestVal>();
        validator
            .prop("firstName", (t) => t.firstName)
            .ensure((t) => t == "Shrey")
            .withMessage(message: "First name is wrong")
            .ensure((t) => t != "")
            .ensure((t) => t == "Name");

        validator.validate(testVal);

        expect(validator.isValid, false, reason: "Should be invalid");
        expect(validator.hasErrors, true, reason: "Should have errors");
        expect(validator.errors.getError("firstName"), "First name is wrong",
            reason: "Should have correct message");
      });

      test(
          "should fail with correct message of the 2nd validation rule when target validations are true, false, true respectively for the object being validated",
          () {
        validator = new Validator<TestVal>();
        validator
            .prop("firstName", (t) => t.firstName)
            .isRequired()
            .withMessage(message: "First name is required")
            .ensure((t) => t == "")
            .withMessage(message: "name can't be empty")
            .ensure((t) => t == "Nivin");

        validator.validate(testVal);

        expect(validator.isValid, false, reason: "Should be invalid");
        expect(validator.hasErrors, true, reason: "Should have errors");
        expect(validator.errors.getError("firstName"), "name can't be empty",
            reason: "Should have correct message");
      });

      test(
          "should fail with correct message of the 3rd rule when target validations are true, true, false respectively for the object being validated",
          () {
        validator = new Validator<TestVal>();
        validator
            .prop("firstName", (t) => t.firstName)
            .isRequired()
            .withMessage(message: "First name is required")
            .ensure((t) => t == "Nivin")
            .withMessage(message: "name is wrong")
            .ensure((t) => t.length == 6)
            .withMessage(message: "name has to be 6 letters");

        validator.validate(testVal);

        expect(validator.isValid, false, reason: "Should be invalid");
        expect(validator.hasErrors, true, reason: "Should have errors");
        expect(validator.errors.getError("firstName"), "name has to be 6 letters",
            reason: "Should have a correct message");
      });

      test(
          "should fail with correct message of the 1st rule when target validations are false, false, false respectively for the object being validated",
          () {
        validator = new Validator<TestVal>();
        validator
            .prop("firstName", (t) => t.firstName)
            .ensure((t) => t == "Shrey")
            .withMessage(message: "First name is not shrey")
            .ensure((t) => t.length > 5)
            .withMessage(message: "name not greater than 5")
            .ensure((t) => t[0] == "S")
            .withMessage(message: "name has to start with S");

        validator.validate(testVal);

        expect(validator.isValid, false, reason: "Should be invalid");
        expect(validator.hasErrors, true, reason: "Should have errors");
        expect(validator.errors.getError("firstName"), "First name is not shrey");
      });
    });
  });
}
