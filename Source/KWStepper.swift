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
}

/// A stepper control with flexible UI and tailored UX.
public class KWStepper: UIControl {
    // MARK: - Configuring the Stepper

    /// If true, long pressing repeatedly alters `value`. Default = true.
    public var autoRepeat: Bool = true {
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
    public var wraps: Bool = false

    /// The minimum value. Must be less than `maximumValue`. Default = 0.
    public var minimumValue: Double = 0 {
        willSet {
            assert(newValue < maximumValue, "\(type(of: self)): minimumValue must be less than maximumValue.")
        }
    }

    /// The maximum value. Must be greater than `minimumValue`. Default = 100.
    public var maximumValue: Double = 100 {
        willSet {
            assert(newValue > minimumValue, "\(type(of: self)): maximumValue must be greater than minimumValue.")
        }
    }

    /// The value to step when decrementing. Must be greater than 0. Default = 1.
    public var decrementStepValue: Double = 1 {
        willSet {
            assert(newValue > 0, "\(type(of: self)): decrementStepValue must be greater than zero.")
        }
    }

    /// The value to step when incrementing. Must be greater than 0. Default = 1.
    public var incrementStepValue: Double = 1 {
        willSet {
            assert(newValue > 0, "\(type(of: self)): incrementStepValue must be greater than zero.")
        }
    }

    /// The delegate for the control.
    public weak var delegate: KWStepperDelegate?

    // MARK: - Accessing the Stepper’s Value

    /// The stepper value. Default = 0.
    public var value: Double = 0 {
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

    /// Executed when `value` is changed; not when `value == oldValue`.
    public var valueChangedCallback: ((KWStepper) -> Void)?

    /// Executed when `value` is decremented; not when `value` is clamped or wrapped.
    public var decrementCallback: ((KWStepper) -> Void)?

    /// Executed when `value` is incremented; not when `value` is clamped or wrapped.
    public var incrementCallback: ((KWStepper) -> Void)?

    /// Executed when `value` is clamped to `maximumValue` via `incrementValue()`.
    public var maxValueClampedCallback: ((KWStepper) -> Void)?

    /// Executed when `value` is clamped to `minimumValue` via `decrementValue()`.
    public var minValueClampedCallback: ((KWStepper) -> Void)?

    // MARK: - Private Variables

    private var longPressTimer: Timer?

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

        super.init(frame: CGRect.zero)

        self.decrementButton.addTarget(self, action: #selector(decrementValue), for: .touchUpInside)
        self.incrementButton.addTarget(self, action: #selector(incrementValue), for: .touchUpInside)

        for button in [self.decrementButton, self.incrementButton] {
            let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
            button.addGestureRecognizer(longPressRecognizer)
        }
    }

    /// `KWStepper` does not support `NSCoding`.
    required public init?(coder aDecoder: NSCoder) {
        fatalError("KWStepper: NSCoding is not supported!")
    }

    // MARK: - Decrementing / Incrementing

    /// Decrements the stepper `value` by `decrementStepValue`.
    public func decrementValue() {
        switch value - decrementStepValue {
        // The `value` is wrapped.
        case let x where wraps && (x <~ minimumValue):
            value = maximumValue
        // The `value` is decremented.
        case let x where x >=~ minimumValue:
            value = x
            delegate?.KWStepperDidDecrement?()
            decrementCallback?(self)
        // The `value` is clamped.
        default:
            endLongPress()
            delegate?.KWStepperMinValueClamped?()
            minValueClampedCallback?(self)
        }
    }

    /// Increments the stepper `value` by `incrementStepValue`.
    public func incrementValue() {
        switch value + incrementStepValue {
        // The `value` is wrapped.
        case let x where wraps && (x >~ maximumValue):
            value = minimumValue
        // The `value` is incremented.
        case let x where x <=~ maximumValue:
            value = x
            delegate?.KWStepperDidIncrement?()
            incrementCallback?(self)
        // The `value` is clamped.
        default:
            endLongPress()
            delegate?.KWStepperMaxValueClamped?()
            maxValueClampedCallback?(self)
        }
    }

    // MARK: - User Interaction

    /// Called while `decrementButton` or `incrementButton` are long pressed.
    public func didLongPress(_ sender: UIGestureRecognizer) {
        guard autoRepeat else {
            return
        }

        switch sender.state {
        case .began: startLongPress(sender)
        case .ended, .cancelled, .failed: endLongPress()
        default: break
        }
    }

    private func startLongPress(_ sender: UIGestureRecognizer) {
        guard longPressTimer == nil else { return }

        longPressTimer = Timer.scheduledTimer(
            timeInterval: autoRepeatInterval,
            target: self,
            selector: sender.view == incrementButton ? #selector(incrementValue) : #selector(decrementValue),
            userInfo: nil,
            repeats: true
        )
    }

    private func endLongPress() {
        guard let timer = longPressTimer else { return }
        
        timer.invalidate()
        longPressTimer = nil
    }
}

infix operator ==~ { precedence 130 }
func ==~ (left: Double, right: Double) -> Bool
{
    return fabs(left.distance(to: right)) <= 1e-15
}
infix operator !=~ { precedence 130 }
func !=~ (left: Double, right: Double) -> Bool
{
    return !(left ==~ right)
}
infix operator <~ { precedence 130 }
func <~ (left: Double, right: Double) -> Bool
{
    return left.distance(to: right) > 1e-15
}
infix operator >~ { precedence 130 }
func >~ (left: Double, right: Double) -> Bool
{
    return left.distance(to: right) < -1e-15
}
infix operator <=~ { precedence 130 }
func <=~ (left: Double, right: Double) -> Bool
{
    return (left ==~ right) || (left <~ right)
}
infix operator >=~ { precedence 130 }
func >=~ (left: Double, right: Double) -> Bool
{
    return (left ==~ right) || (left >~ right)
}
