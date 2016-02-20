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

    // MARK: - Decrementing / Incrementing

    /// Tests decrementing / incrementing (without testing `wraps`) and
    /// ensures that `decrementCallback` and `incrementCallback` are executed.
    func testValue() {
        var executedDecrementCallback = false
        var executedIncrementCallback = false

        stepper.decrementCallback = { stepper in
            executedDecrementCallback = true
        }

        stepper.incrementCallback = { stepper in
            executedIncrementCallback = true
        }

        let initialValue = 50.0
        stepper.value = initialValue

        stepper.incrementValue()
        XCTAssertEqual(stepper.value, initialValue + stepper.decrementStepValue)
        XCTAssertEqual(executedIncrementCallback, true)

        stepper.decrementValue()
        XCTAssertEqual(stepper.value, initialValue)
        XCTAssertEqual(executedDecrementCallback, true)
    }

    /// Tests decrementing / incrementing with `wraps` enabled.
    func testWrapping() {
        stepper.wraps = true

        stepper.decrementValue()
        XCTAssertEqual(stepper.value, stepper.maximumValue)

        stepper.incrementValue()
        XCTAssertEqual(stepper.value, stepper.minimumValue)
    }

    /// Tests decrementing / incrementing with `wraps` disabled and
    /// ensures that `minValueClampedCallback` and `maxValueClampedCallback` are executed.
    func testClamping() {
        var executedMinValueClampedCallback = false
        var executedMaxValueClampedCallback = false

        stepper.minValueClampedCallback = { stepper in
            executedMinValueClampedCallback = true
        }

        stepper.maxValueClampedCallback = { stepper in
            executedMaxValueClampedCallback = true
        }

        stepper.decrementValue()
        XCTAssertEqual(stepper.value, stepper.minimumValue)
        XCTAssertEqual(executedMinValueClampedCallback, true)

        stepper.value = stepper.maximumValue
        stepper.incrementValue()
        XCTAssertEqual(stepper.value, stepper.maximumValue)
        XCTAssertEqual(executedMaxValueClampedCallback, true)
    }
}
