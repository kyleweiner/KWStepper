//
//  KWStepper.swift
//  Created by Kyle Weiner on 1/22/17.
//  https://github.com/kyleweiner/KWStepper
//

public extension KWStepper {
    // MARK: - Configuration Methods

    /// Sets the stepper's `autoRepeat` value.
    @discardableResult
    func autoRepeat(_ value: Bool) -> Self {
        autoRepeat = value

        return self
    }

    /// Sets the stepper's `autoRepeatInterval`.
    @discardableResult
    func autoRepeatInterval(_ value: TimeInterval) -> Self {
        autoRepeatInterval = value

        return self
    }

    /// Sets the stepper's `wraps` value.
    @discardableResult
    func wraps(_ value: Bool) -> Self {
        wraps = value

        return self
    }

    /// Sets the stepper's `minimumValue`.
    @discardableResult
    func minimumValue(_ value: Double) -> Self {
        minimumValue = value

        return self
    }

    /// Sets the stepper's `maximumValue`.
    @discardableResult
    func maximumValue(_ value: Double) -> Self {
        maximumValue = value

        return self
    }

    /// Sets the stepper's `decrementStepValue`.
    @discardableResult
    func decrementStepValue(_ value: Double) -> Self {
        decrementStepValue = value

        return self
    }

    /// Sets the stepper's `incrementStepValue`.
    @discardableResult
    func incrementStepValue(_ value: Double) -> Self {
        incrementStepValue = value

        return self
    }

    /// Sets the stepper's `roundingBehavior`.
    @discardableResult
    func roundingBehavior(_ value: Double) -> Self {
        self.roundingBehavior = roundingBehavior

        return self
    }

    /// Sets the stepper's `delegate`.
    @discardableResult
    func delegate(_ value: KWStepperDelegate?) -> Self {
        delegate = value

        return self
    }

    /// Sets the stepper's `value`.
    @discardableResult
    func value(_ value: Double) -> Self {
        self.value = value

        return self
    }

    // MARK: - Callback Methods

    /// Sets the stepper's `valueChangedCallback`.
    @discardableResult
    func valueChanged(_ callback: KWStepperCallback?) -> Self {
        valueChangedCallback = callback

        return self
    }

    /// Sets the stepper's `decrementCallback`.
    @discardableResult
    func didDecrement(_ callback: KWStepperCallback?) -> Self {
        decrementCallback = callback

        return self
    }

    /// Sets the stepper's `incrementCallback`.
    @discardableResult
    func didIncrement(_ callback: KWStepperCallback?) -> Self {
        incrementCallback = callback

        return self
    }

    /// Sets the stepper's `maxValueClampedCallback`.
    @discardableResult
    func maxValueClamped(_ callback: KWStepperCallback?) -> Self {
        maxValueClampedCallback = callback

        return self
    }

    /// Sets the stepper's `minValueClampedCallback`.
    @discardableResult
    func minValueClamped(_ callback: KWStepperCallback?) -> Self {
        minValueClampedCallback = callback
        
        return self
    }

    /// Sets the stepper's `longPressEndedCallback`.
    @discardableResult
    func longPressEnded(_ callback: KWStepperCallback?) -> Self {
        longPressEndedCallback = callback

        return self
    }

    // MARK: - Convenience Methods

    /// Sets the stepper's `decrementStepValue` and `incrementStepValue`.
    @discardableResult
    func stepValue(_ value: Double) -> Self {
        decrementStepValue = value
        incrementStepValue = value

        return self
    }

    /// Sets the stepper's `maxValueClampedCallback` and `minValueClampedCallback`.
    @discardableResult
    func valueClamped(_ callback: @escaping KWStepperCallback) -> Self {
        maxValueClampedCallback = callback
        minValueClampedCallback = callback

        return self
    }
}
