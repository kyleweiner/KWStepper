//
//  KWStepper.swift
//  Created by Kyle Weiner on 10/17/14.
//  Copyright (c) 2014 Kyle Weiner. All rights reserved.
//

import UIKit

@objc protocol KWStepperDelegate {
    optional func KWStepperDidDecrement()
    optional func KWStepperDidIncrement()
    optional func KWStepperMaxValueClamped()
    optional func KWStepperMinValueClamped()
}

class KWStepper: UIControl {

    // MARK: Required Variables

    /**
    The decrement button used initialize the control.
    */
    var decrementButton: UIButton!

    /**
    The increment button used initialize the control.
    */
    var incrementButton: UIButton!

    // MARK: Optional Variables

    /**
    If true, press & hold repeatedly alters value. Default = true.
    */
    var autoRepeat: Bool = true {
        didSet {
            if autoRepeatInterval <= 0 {
                self.autoRepeat = false
            }
        }
    }

    /**
    The interval that autoRepeat changes the stepper value, specified in seconds. Default = 0.10.
    */
    var autoRepeatInterval: NSTimeInterval = 0.10 {
        didSet {
            if autoRepeatInterval <= 0 {
                self.autoRepeatInterval = 0.10;
                self.autoRepeat = false
            }
        }
    }

    /**
    If YES, value wraps from min <-> max. Default = false.
    */
    var wraps: Bool = false
    
    /**
    Sends UIControlEventValueChanged, clamped to min/max. Default = 0.
    */
    var value: Double = 0 {
        didSet {
            if value > oldValue {
                if let delegate = self.delegate {
                    delegate.KWStepperDidIncrement?()
                }
            } else {
                if let delegate = self.delegate {
                    delegate.KWStepperDidDecrement?()
                }
            }

            if value < self.minimumValue {
                self.value = self.minimumValue
            } else if value > self.maximumValue {
                self.value = self.maximumValue
            }
            
            self.sendActionsForControlEvents(.ValueChanged)
        }
    }

    /**
    Must be less than maximumValue. Default = 0.
    */
    var minimumValue: Double = 0 {
        willSet {
            if newValue >= self.maximumValue {
                let reason = "KWStepper: minimumValue must be less than maximumValue."
                NSException(name: NSInvalidArgumentException, reason: reason, userInfo: nil).raise()
            }
        }
    }

    /**
    Must be less than minimumValue. Default = 100.
    */
    var maximumValue: Double = 100 {
        willSet {
            if newValue <= self.minimumValue {
                let reason = "KWStepper: maximumValue must be greater than minimumValue."
                NSException(name: NSInvalidArgumentException, reason: reason, userInfo: nil).raise()
            }
        }
    }

    /**
    The value to step when incrementing. Must be greater than 0. Default = 1.
    */
    var incrementStepValue: Double = 1 {
        willSet {
            if newValue <= 0 {
                let reason = "KWStepper: incrementStepValue must be greater than zero."
                NSException(name: NSInvalidArgumentException, reason: reason, userInfo: nil).raise()
            }
        }
    }
    
    /**
    The value to step when decrementing. Must be greater than 0. Default = 1.
    */
    var decrementStepValue: Double = 1 {
        willSet {
            if newValue <= 0 {
                let reason = "KWStepper: decrementStepValue must be greater than zero."
                NSException(name: NSInvalidArgumentException, reason: reason, userInfo: nil).raise()
            }
        }
    }

    var delegate:KWStepperDelegate? = nil

    // MARK: Private Variables
    
    private var longPressTimer: NSTimer?

    // MARK: Initialization
    
    init(decrementButton: UIButton, incrementButton: UIButton) {
        self.decrementButton = decrementButton
        self.incrementButton = incrementButton
        super.init(frame: CGRectZero)

        self.decrementButton.addTarget(self, action: Selector("decrementValue"), forControlEvents: UIControlEvents.TouchUpInside)
        self.incrementButton.addTarget(self, action: Selector("incrementValue"), forControlEvents: UIControlEvents.TouchUpInside)

        self.decrementButton.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: Selector("didLongPress:")))
        self.incrementButton.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: Selector("didLongPress:")))
    }

    required init(coder: NSCoder) {
        fatalError("KWStepper: NSCoding is not supported!")
    }

    // MARK: KWStepper

    func decrementValue() {
        let decrementedValue: Double = self.value - self.decrementStepValue

        if self.wraps && decrementedValue < self.minimumValue {
            self.value = self.maximumValue
            return
        }

        if decrementedValue >= self.minimumValue {
            self.value = decrementedValue
        } else {
            endLongPress()
            if let delegate = self.delegate {
                delegate.KWStepperMinValueClamped?()
            }
        }
    }

    func incrementValue() {
        let incrementedValue = self.value + self.incrementStepValue;
        
        if self.wraps && incrementedValue > self.maximumValue {
            self.value = self.minimumValue
            return
        }

        if (incrementedValue <= self.maximumValue) {
            self.value = incrementedValue;
        } else {
            endLongPress()
            if let delegate = self.delegate {
                delegate.KWStepperMaxValueClamped?()
            }
        }
    }

    // MARK: User Interaction

    func didLongPress(sender: UIGestureRecognizer) {
        if !self.autoRepeat {
            return
        }

        if self.longPressTimer == nil && sender.state == .Began {
            let selector = sender.view == self.incrementButton ? Selector("incrementValue") : Selector("decrementValue")

            self.longPressTimer = NSTimer.scheduledTimerWithTimeInterval(
                self.autoRepeatInterval,
                target: self,
                selector: selector,
                userInfo: nil,
                repeats: true
            )
        }

        if sender.state == .Ended || sender.state == .Cancelled || sender.state == .Failed {
            endLongPress()
        }
    }
    
    private func endLongPress() {
        if self.longPressTimer != nil {
            self.longPressTimer?.invalidate()
            self.longPressTimer = nil
        }
    }

}
