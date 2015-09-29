//
//  KWStepper.swift
//  Created by Kyle Weiner on 10/17/14.
//  https://github.com/kyleweiner/KWStepper
//

import UIKit

@objc public protocol KWStepperDelegate {
    optional func KWStepperDidDecrement()
    optional func KWStepperDidIncrement()
    optional func KWStepperMaxValueClamped()
    optional func KWStepperMinValueClamped()
}

public class KWStepper: UIControl {

    // MARK: - Required Variables

    /// The decrement button used initialize the control.
    let decrementButton: UIButton

    /// The increment button used initialize the control.
    let incrementButton: UIButton

    // MARK: - Optional Variables

    /// If true, press & hold repeatedly alters value. Default = true.
    public var autoRepeat: Bool = true {
        didSet {
            if autoRepeatInterval <= 0 {
                autoRepeat = false
            }
        }
    }

    /// The interval that autoRepeat changes the stepper value, specified in seconds. Default = 0.10.
    public var autoRepeatInterval: NSTimeInterval = 0.10 {
        didSet {
            if autoRepeatInterval <= 0 {
                autoRepeatInterval = 0.10
                autoRepeat = false
            }
        }
    }

    /// If true, value wraps from min <-> max. Default = false.
    public var wraps: Bool = false

    /// Sends UIControlEventValueChanged, clamped to min/max. Default = 0.
    public var value: Double = 0 {
        didSet {
            if value > oldValue {
                delegate?.KWStepperDidIncrement?()
                incrementCallback?()
            } else {
                delegate?.KWStepperDidDecrement?()
                decrementCallback?()
            }

            if value < minimumValue {
                value = minimumValue
            } else if value > maximumValue {
                value = maximumValue
            }

            sendActionsForControlEvents(.ValueChanged)
            valueChangedCallback?()
        }
    }

    /// Must be less than maximumValue. Default = 0.
    public var minimumValue: Double = 0 {
        willSet {
            assert(newValue < maximumValue, "\(self.dynamicType): minimumValue must be less than maximumValue.")
        }
    }

    /// Must be less than minimumValue. Default = 100.
    public var maximumValue: Double = 100 {
        willSet {
            assert(newValue > minimumValue, "\(self.dynamicType): maximumValue must be greater than minimumValue.")
        }
    }

    /// The value to step when incrementing. Must be greater than 0. Default = 1.
    public var incrementStepValue: Double = 1 {
        willSet {
            assert(newValue > 0, "\(self.dynamicType): incrementStepValue must be greater than zero.")
        }
    }

    /// The value to step when decrementing. Must be greater than 0. Default = 1.
    public var decrementStepValue: Double = 1 {
        willSet {
            assert(newValue > 0, "\(self.dynamicType): decrementStepValue must be greater than zero.")
        }
    }

    /// Executed when the value is changed.
    public var valueChangedCallback: (() -> ())?

    /// Executed when the value is decremented.
    public var decrementCallback: (() -> ())?

    /// Executed when the value is incremented.
    public var incrementCallback: (() -> ())?

    /// Executed when the max value is clamped.
    public var maxValueClampedCallback: (() -> ())?

    /// Executed when the min value is clamped.
    public var minValueClampedCallback: (() -> ())?

    public var delegate: KWStepperDelegate? = nil

    // MARK: - Private Variables

    private var longPressTimer: NSTimer?

    // MARK: - Initialization

    public init(decrementButton: UIButton, incrementButton: UIButton) {
        self.decrementButton = decrementButton
        self.incrementButton = incrementButton
        super.init(frame: CGRectZero)

        self.decrementButton.addTarget(self, action: "decrementValue", forControlEvents: .TouchUpInside)
        self.incrementButton.addTarget(self, action: "incrementValue", forControlEvents: .TouchUpInside)

        self.decrementButton.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: "didLongPress:"))
        self.incrementButton.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: "didLongPress:"))
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("KWStepper: NSCoding is not supported!")
    }

    // MARK: - KWStepper

    public func decrementValue() {
        switch value - decrementStepValue {
            case let x where wraps && x < minimumValue:
                value = maximumValue
            case let x where x >= minimumValue:
                value = x
            default:
                endLongPress()
                delegate?.KWStepperMinValueClamped?()
                maxValueClampedCallback?()
        }
    }

    public func incrementValue() {
        switch value + incrementStepValue {
            case let x where wraps && x > maximumValue:
                value = minimumValue
            case let x where x <= maximumValue:
                value = x
            default:
                endLongPress()
                delegate?.KWStepperMaxValueClamped?()
                maxValueClampedCallback?()
        }
    }

    // MARK: - User Interaction

    public func didLongPress(sender: UIGestureRecognizer) {
        if !autoRepeat {
            return
        }

        if longPressTimer == nil && sender.state == .Began {
            longPressTimer = NSTimer.scheduledTimerWithTimeInterval(
                autoRepeatInterval,
                target: self,
                selector: sender.view == incrementButton ? "incrementValue" : "decrementValue",
                userInfo: nil,
                repeats: true
            )
        }

        if sender.state == .Ended || sender.state == .Cancelled || sender.state == .Failed {
            endLongPress()
        }
    }

    private func endLongPress() {
        if longPressTimer != nil {
            longPressTimer?.invalidate()
            longPressTimer = nil
        }
    }
    
}
