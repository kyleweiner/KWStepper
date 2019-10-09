//
//  KWStepper.swift
//  Created by Kyle Weiner on 1/22/17.
//  https://github.com/kyleweiner/KWStepper
//
import Foundation

extension KWStepper {
    // MARK: - Configuration Methods

    /// Sets the stepper's `autoRepeat` value.
    @discardableResult
    public func autoRepeat(_ value: Bool) -> Self {
        autoRepeat = value

        return self
    }

    /// Sets the stepper's `autoRepeatInterval`.
    @discardableResult
    public func autoRepeatInterval(_ value: TimeInterval) -> Self {
        autoRepeatInterval = value

        return self
    }

    /// Sets the stepper's `wraps` value.
    @discardableResult
    public func wraps(_ value: Bool) -> Self {
        wraps = value

        return self
    }

    /// Sets the stepper's `minimumValue`.
    @discardableResult
    public func minimumValue(_ value: Double) -> Self {
        minimumValue = value

        return self
    }

    /// Sets the stepper's `maximumValue`.
    @discardableResult
    public func maximumValue(_ value: Double) -> Self {
        maximumValue = value

        return self
    }

    /// Sets the stepper's `decrementStepValue`.
    @discardableResult
    public func decrementStepValue(_ value: Double) -> Self {
        decrementStepValue = value

        return self
    }

    /// Sets the stepper's `incrementStepValue`.
    @discardableResult
    public func incrementStepValue(_ value: Double) -> Self {
        incrementStepValue = value

        return self
    }

    /// Sets the stepper's `roundingBehavior`.
    @discardableResult
    public func roundingBehavior(_ value: Double) -> Self {
        self.roundingBehavior = roundingBehavior

        return self
    }

    /// Sets the stepper's `delegate`.
    @discardableResult
    public func delegate(_ value: KWStepperDelegate?) -> Self {
        delegate = value

        return self
    }

    /// Sets the stepper's `value`.
    @discardableResult
    public func value(_ value: Double) -> Self {
        self.value = value

        return self
    }

    // MARK: - Callback Methods

    /// Sets the stepper's `valueChangedCallback`.
    @discardableResult
    public func valueChanged(_ callback: KWStepperCallback?) -> Self {
        valueChangedCallback = callback

        return self
    }

    /// Sets the stepper's `decrementCallback`.
    @discardableResult
    public func didDecrement(_ callback: KWStepperCallback?) -> Self {
        decrementCallback = callback

        return self
    }

    /// Sets the stepper's `incrementCallback`.
    @discardableResult
    public func didIncrement(_ callback: KWStepperCallback?) -> Self {
        incrementCallback = callback

        return self
    }

    /// Sets the stepper's `maxValueClampedCallback`.
    @discardableResult
    public func maxValueClamped(_ callback: KWStepperCallback?) -> Self {
        maxValueClampedCallback = callback

        return self
    }

    /// Sets the stepper's `minValueClampedCallback`.
    @discardableResult
    public func minValueClamped(_ callback: KWStepperCallback?) -> Self {
        minValueClampedCallback = callback
        
        return self
    }

    /// Sets the stepper's `longPressEndedCallback`.
    @discardableResult
    public func longPressEnded(_ callback: KWStepperCallback?) -> Self {
        longPressEndedCallback = callback

        return self
    }

    // MARK: - Convenience Methods

    /// Sets the stepper's `decrementStepValue` and `incrementStepValue`.
    @discardableResult
    public func stepValue(_ value: Double) -> Self {
        decrementStepValue = value
        incrementStepValue = value

        return self
    }

    /// Sets the stepper's `maxValueClampedCallback` and `minValueClampedCallback`.
    @discardableResult
    public func valueClamped(_ callback: @escaping KWStepperCallback) -> Self {
        maxValueClampedCallback = callback
        minValueClampedCallback = callback

        return self
    }
}
