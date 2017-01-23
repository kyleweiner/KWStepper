//
//  KWStepperTests.swift
//  Created by Kyle Weiner on 7/11/15.
//

import XCTest
import KWStepper

class KWStepperTests: XCTestCase {
    var stepper: KWStepper!

    // MARK: - Lifecycle

    override func setUp() {
        super.setUp()

        stepper = KWStepper(
            decrementButton: UIButton(),
            incrementButton: UIButton()
        )
    }

    // MARK: - Incrementing

    /// Tests that `value` is equal to `value + incrementStepValue` when incrementing.
    func testIncrementValue() {
        XCTAssertEqual(stepper.value, 0)
        XCTAssertEqual(stepper.incrementValue().value, stepper.incrementStepValue)
    }

    /// Tests that `value` wraps from `maximumValue` to `minimumValue`.
    func testIncrementValueWithWraps() {
        stepper.wraps(true).value(stepper.maximumValue).incrementValue()
        XCTAssertEqual(stepper.value, stepper.minimumValue)
    }

    /// Tests that `value` is clamped when incrementing above `maximumValue`.
    func testIncrementValueWithClamping() {
        stepper.value(stepper.maximumValue).incrementValue()
        XCTAssertEqual(stepper.value, stepper.maximumValue)
    }

    // MARK: - Decrementing

    /// Tests that `value` is equal to `value - decrementStepValue` when decrementing.
    func testDecrementValue() {
        stepper.value(stepper.maximumValue).decrementValue()
        XCTAssertEqual(stepper.value, stepper.maximumValue - stepper.decrementStepValue)
    }

    /// Tests that `value` wraps from `minimumValue` to `maximumValue`.
    func testDecrementValueWithWraps() {
        XCTAssertEqual(stepper.value, stepper.minimumValue)
        stepper.wraps(true).decrementValue()
        XCTAssertEqual(stepper.value, stepper.maximumValue)
    }

    /// Tests that `value` is clamped when decrementing below `minimumValue`.
    func testDecrementValueWithClamping() {
        XCTAssertEqual(stepper.value, stepper.minimumValue)
        XCTAssertEqual(stepper.decrementValue().value, stepper.minimumValue)
    }

    // MARK: - Double Arithmetic

    /// Tests decrementing and incrementing with IEEE 754 floating-point numbers.
    func testDoubleArithmetic() {
        stepper.value(4.8).decrementStepValue(0.4).decrementValue()
        XCTAssertEqual(stepper.value, 4.4)

        stepper.value(1.1).incrementStepValue(0.1).incrementValue()
        XCTAssertEqual(stepper.value, 1.2)
    }

    // Tests that incrementing from 0 by 0.01 should eventually clamp at 1.2.
    func testDoubleArithmeticByClamping() {
        var stepperWasClamped = false

        stepper.value(0).maximumValue(1.2).incrementStepValue(0.01).maxValueClamped { stepper in
            stepperWasClamped = true
            XCTAssertEqual(stepper.value, stepper.maximumValue)
        }

        while !stepperWasClamped { stepper.incrementValue() }
    }

    // MARK: - Auto Repeat

    /// Tests that `autoRepeat` is `false` when `autoRepeatInterval` is 0.
    func testAutoRepeat() {
        XCTAssertFalse(stepper.autoRepeatInterval(0).autoRepeat)
    }

    // MARK: - Callbacks

    /// Tests that `valueChangedCallback` is executed when `value` changes
    /// and not when the new value is equal to the previous value.
    func testValueChangedCallback() {
        XCTAssertNil(stepper.valueChangedCallback)

        var executedCallback = false
        stepper.valueChangedCallback = { stepper in
            executedCallback = true
        }

        // The `value` is equal to the old `value`; `executedCallback` should be `false`.
        stepper.value = stepper.value
        XCTAssertFalse(executedCallback)

        stepper.value += 1
        XCTAssertTrue(executedCallback)
    }

    /// Tests that `decrementCallback` is executed when decrementing
    /// and not when `value` is clamped or wrapped to `maximumValue`.
    func testDecrementCallback() {
        XCTAssertNil(stepper.decrementCallback)

        var executedCallback = false
        stepper.decrementCallback = { stepper in
            executedCallback = true
        }

        // The `value` is clamped; `executedCallback` should be `false`.
        stepper.decrementValue()
        XCTAssertFalse(executedCallback)

        // The `value` is wrapped; `executedCallback` should be `false`.
        stepper.wraps(true).decrementValue()
        XCTAssertFalse(executedCallback)

        // The `value` is decremented; `executedCallback` shoud be `true`.
        stepper.decrementValue()
        XCTAssertTrue(executedCallback)
    }

    /// Tests that `incrementCallback` is executed when incrementing
    /// and not when `value` is clamped or wrapped to `minimumValue`.
    func testIncrementCallback() {
        XCTAssertNil(stepper.incrementCallback)

        var executedCallback = false
        stepper.incrementCallback = { stepper in
            executedCallback = true
        }

        // The `value` is clamped; `executedCallback` should be `false`.
        stepper.value(stepper.maximumValue).incrementValue()
        XCTAssertFalse(executedCallback)

        // The `value` is wrapped; `executedCallback` should be `false`.
        stepper.wraps(true).incrementValue()
        XCTAssertFalse(executedCallback)

        // The `value` is incremented; `executedCallback` shoud be `true`.
        stepper.incrementValue()
        XCTAssertTrue(executedCallback)
    }

    /// Tests that `maxValueClampedCallback` is executed when calling
    /// `incrementValue()` results in clamping.
    func testMaxValueClampedCallback() {
        XCTAssertNil(stepper.maxValueClampedCallback)

        var executedCallback = false
        stepper.maxValueClampedCallback = { stepper in
            executedCallback = true
        }

        stepper.value(stepper.maximumValue).incrementValue()

        XCTAssertEqual(stepper.value, stepper.maximumValue)
        XCTAssertTrue(executedCallback)
    }

    /// Tests that `minValueClampedCallback` is executed when calling
    /// `decrementValue()` results in clamping.
    func testMinValueClampedCallback() {
        XCTAssertNil(stepper.minValueClampedCallback)

        var executedCallback = false
        stepper.minValueClampedCallback = { stepper in
            executedCallback = true
        }

        XCTAssertEqual(stepper.decrementValue().value, stepper.minimumValue)
        XCTAssertTrue(executedCallback)
    }

    // MARK: - Chaining

    /// Tests that incrementing from 0 and then decrementing by 1 equals 0.
    func testChaining() {
        XCTAssertEqual(stepper.value, 0)
        XCTAssertEqual(stepper.incrementValue().decrementValue().value, 0)
    }

    /// Tests that `stepValue(_:)` sets both `decrementStepValue` and `incrementStepValue`.
    func testStepValue() {
        XCTAssertEqual(stepper.value, 0)
        XCTAssertEqual(stepper.stepValue(4).incrementStepValue, 4)
        XCTAssertEqual(stepper.decrementStepValue, stepper.incrementStepValue)
    }

    /// Tests that `valueClamped(_:)` sets both `maxValueClampedCallback` and `minValueClampedCallback`.
    func testValueClamped() {
        XCTAssertNil(stepper.maxValueClampedCallback)
        XCTAssertNil(stepper.minValueClampedCallback)
        stepper.valueClamped { _ in }
        XCTAssertNotNil(stepper.maxValueClampedCallback)
        XCTAssertNotNil(stepper.minValueClampedCallback)
    }
}
