//
//  KWStepper.swift
//  Created by Kyle Weiner on 1/22/17.
//  https://github.com/kyleweiner/KWStepper
//

extension KWStepper {
    @discardableResult
    public func autoRepeat(_ value: Bool) -> Self {
        autoRepeat = value

        return self
    }

    @discardableResult
    public func autoRepeatInterval(_ value: TimeInterval) -> Self {
        autoRepeatInterval = value

        return self
    }

    @discardableResult
    public func wraps(_ value: Bool) -> Self {
        wraps = value

        return self
    }

    @discardableResult
    public func minimumValue(_ value: Double) -> Self {
        minimumValue = value

        return self
    }

    @discardableResult
    public func maximumValue(_ value: Double) -> Self {
        maximumValue = value

        return self
    }

    @discardableResult
    public func decrementStepValue(_ value: Double) -> Self {
        decrementStepValue = value

        return self
    }

    @discardableResult
    public func incrementStepValue(_ value: Double) -> Self {
        incrementStepValue = value

        return self
    }

    @discardableResult
    public func delegate(_ value: KWStepperDelegate?) -> Self {
        delegate = value

        return self
    }

    @discardableResult
    public func value(_ value: Double) -> Self {
        self.value = value

        return self
    }

    @discardableResult
    public func roundingBehavior(_ value: Double) -> Self {
        self.roundingBehavior = roundingBehavior

        return self
    }

    @discardableResult
    public func valueChanged(_ callback: KWStepperCallback?) -> Self {
        valueChangedCallback = callback

        return self
    }

    @discardableResult
    public func didDecrement(_ callback: KWStepperCallback?) -> Self {
        decrementCallback = callback

        return self
    }

    @discardableResult
    public func didIncrement(_ callback: KWStepperCallback?) -> Self {
        incrementCallback = callback

        return self
    }

    @discardableResult
    public func maxValueClamped(_ callback: KWStepperCallback?) -> Self {
        maxValueClampedCallback = callback

        return self
    }

    @discardableResult
    public func minValueClamped(_ callback: KWStepperCallback?) -> Self {
        minValueClampedCallback = callback
        
        return self
    }
}

// MARK: - Convenience

extension KWStepper {
    @discardableResult
    public func stepValue(_ value: Double) -> Self {
        decrementStepValue = value
        incrementStepValue = value

        return self
    }

    @discardableResult
    public func valueClamped(_ callback: @escaping KWStepperCallback) -> Self {
        maxValueClampedCallback = callback
        minValueClampedCallback = callback

        return self
    }
}
