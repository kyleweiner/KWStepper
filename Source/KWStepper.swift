//
//  KWStepper.swift
//  Created by Kyle Weiner on 10/17/14.
//  https://github.com/kyleweiner/KWStepper
//

import UIKit

/// Optional delegate methods for tailoring the UX.

@objc public protocol KWStepperDelegate {
    /// Called when `value` is decremented; not when `value` is clamped or wrapped.
    @objc optional func KWStepperDidDecrement()

    /// Called when `value` is incremented; not when `value` is clamped or wrapped.
    @objc optional func KWStepperDidIncrement()

    /// Called when `value` is clamped to `maximumValue` via `incrementValue()`.
    @objc optional func KWStepperMaxValueClamped()

    /// Called when `value` is clamped to `minimumValue` via `decrementValue()`.
    @objc optional func KWStepperMinValueClamped()

    /// Called when a long press gesture ends.
    @objc optional func KWStepperDidEndLongPress()
}

/// A stepper control with flexible UI and tailored UX.

public class KWStepper: UIControl {
    // MARK: - Configuring the Stepper

    /// If true, long pressing repeatedly alters `value`. Default = true.
    public var autoRepeat = true {
        didSet {
            if autoRepeatInterval <= 0 {
                autoRepeat = false
            }
        }
    }

    /// The interval at which `autoRepeat` changes the stepper value, specified in seconds. Default = 0.10.
    public var autoRepeatInterval: TimeInterval = 0.10 {
        didSet {
            if autoRepeatInterval <= 0 {
                autoRepeatInterval = 0.10
                autoRepeat = false
            }
        }
    }

    /**
     If true, `value` wraps from `minimumValue` <-> `maximumValue`. Default = false.
     The expected result of a wrapped `value` is the opposite limit–regardless of the
     `decrementStepValue` or `incrementStepValue`. `UIStepper` exhibits the same behavior.
    */
    public var wraps = false

    /// The minimum value. Must be less than `maximumValue`. Default = 0.
    public var minimumValue = 0.0 {
        willSet {
            assert(newValue < maximumValue, "\(type(of: self)): minimumValue must be less than maximumValue.")
        }
    }

    /// The maximum value. Must be greater than `minimumValue`. Default = 100.
    public var maximumValue = 100.0 {
        willSet {
            assert(newValue > minimumValue, "\(type(of: self)): maximumValue must be greater than minimumValue.")
        }
    }

    /// The value to step when decrementing. Must be greater than 0. Default = 1.
    public var decrementStepValue = 1.0 {
        willSet {
            assert(newValue > 0, "\(type(of: self)): decrementStepValue must be greater than zero.")
        }
    }

    /// The value to step when incrementing. Must be greater than 0. Default = 1.
    public var incrementStepValue = 1.0 {
        willSet {
            assert(newValue > 0, "\(type(of: self)): incrementStepValue must be greater than zero.")
        }
    }

    /// Determines the rounding behavior used when incrementing or decrementing.
    public var roundingBehavior = NSDecimalNumberHandler(
        roundingMode: .bankers,
        scale: 2,
        raiseOnExactness: false,
        raiseOnOverflow: false,
        raiseOnUnderflow: false,
        raiseOnDivideByZero: true)

    /// The delegate for the control.
    public weak var delegate: KWStepperDelegate?

    // MARK: - Accessing the Stepper’s Value

    /// The stepper value. Default = 0.
    public var value = 0.0 {
        didSet {
            guard value != oldValue else { return }

            if value < minimumValue {
                value = minimumValue
            } else if value > maximumValue {
                value = maximumValue
            }

            sendActions(for: .valueChanged)
            valueChangedCallback?(self)
        }
    }

    // MARK: - Callbacks

    public typealias KWStepperCallback = ((KWStepper) -> Void)

    /// Executed when `value` is changed; not when `value == oldValue`.
    public var valueChangedCallback: KWStepperCallback?

    /// Executed when `value` is decremented; not when `value` is clamped or wrapped.
    public var decrementCallback: KWStepperCallback?

    /// Executed when `value` is incremented; not when `value` is clamped or wrapped.
    public var incrementCallback: KWStepperCallback?

    /// Executed when `value` is clamped to `maximumValue` via `incrementValue()`.
    public var maxValueClampedCallback: KWStepperCallback?

    /// Executed when `value` is clamped to `minimumValue` via `decrementValue()`.
    public var minValueClampedCallback: KWStepperCallback?

    /// Executed when a long press gesture ends.
    public var longPressEndedCallback: KWStepperCallback?

    // MARK: - Private Variables

    fileprivate var longPressTimer: Timer?

    // MARK: - Initialization

    /// A `UIButton` that decrements `value` when pressed.
    public let decrementButton: UIButton

    /// A `UIButton` that increments `value` when pressed.
    public let incrementButton: UIButton

    /**
     Initializes a `KWStepper` instance with the provided buttons.

     - Parameters:
     - decrementButton: The button used to decrement the `value`
     - incrementButton: The button used to increment the `value`
     */
    public init(decrementButton: UIButton, incrementButton: UIButton) {
        self.decrementButton = decrementButton
        self.incrementButton = incrementButton

        super.init(frame: .zero)

        self.decrementButton.addTarget(self, action: #selector(decrementValue), for: .touchUpInside)
        self.incrementButton.addTarget(self, action: #selector(incrementValue), for: .touchUpInside)

        for button in [self.decrementButton, self.incrementButton] {
            let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
            button.addGestureRecognizer(longPressRecognizer)
        }
    }

    /// :nodoc:
    required public init?(coder aDecoder: NSCoder) {
        fatalError("KWStepper: NSCoding is not supported!")
    }

    // MARK: - Decrementing & Incrementing

    /// Decrements the stepper `value` by `decrementStepValue`.
    @objc @discardableResult
    public func decrementValue() -> Self {
        let decrementedValue = (value - decrementStepValue).round(with: roundingBehavior)

        // The `value` should wrap to `maximumValue`.
        if wraps && decrementedValue < minimumValue {
            value = maximumValue
        // The `value` should be decremented.
        } else if decrementedValue >= minimumValue {
            value = decrementedValue
            delegate?.KWStepperDidDecrement?()
            decrementCallback?(self)
        // The `value` should be clamped.
        } else {
            endLongPress()
            delegate?.KWStepperMinValueClamped?()
            minValueClampedCallback?(self)
        }

        return self
    }

    /// Increments the stepper `value` by `incrementStepValue`.
    @objc @discardableResult
    public func incrementValue() -> Self {
        let incrementedValue = (value + incrementStepValue).round(with: roundingBehavior)

        // The `value` should wrap to `minimumValue`.
        if wraps && incrementedValue > maximumValue {
            value = minimumValue
        // The `value` should be incremented.
        } else if incrementedValue <= maximumValue {
            value = incrementedValue
            delegate?.KWStepperDidIncrement?()
            incrementCallback?(self)
        // The `value` should be clamped.
        } else {
            endLongPress()
            delegate?.KWStepperMaxValueClamped?()
            maxValueClampedCallback?(self)
        }

        return self
    }
}

// MARK: - User Interaction

extension KWStepper {
    /// Called while `decrementButton` or `incrementButton` are long pressed.
    @objc fileprivate func didLongPress(_ sender: UIGestureRecognizer) {
        guard autoRepeat else {
            return
        }

        switch sender.state {
        case .began: startLongPress(sender)
        case .ended, .cancelled, .failed: endLongPress()
        default: break
        }
    }

    fileprivate func startLongPress(_ sender: UIGestureRecognizer) {
        guard longPressTimer == nil else { return }

        longPressTimer = Timer.scheduledTimer(
            timeInterval: autoRepeatInterval,
            target: self,
            selector: sender.view == incrementButton ? #selector(incrementValue) : #selector(decrementValue),
            userInfo: nil,
            repeats: true
        )
    }

    fileprivate func endLongPress() {
        guard let timer = longPressTimer else { return }
        
        timer.invalidate()
        longPressTimer = nil

        delegate?.KWStepperDidEndLongPress?()
        longPressEndedCallback?(self)
    }
}

// MARK: - Rounding

extension Double {
    func round(with behavior: NSDecimalNumberHandler) -> Double {
        return NSDecimalNumber(value: self).rounding(accordingToBehavior: behavior).doubleValue
    }
}
