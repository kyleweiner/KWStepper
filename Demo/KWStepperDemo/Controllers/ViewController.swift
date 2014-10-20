//
//  ViewController.swift
//  KWStepperDemo
//
//  Created by Kyle Weiner on 10/17/14.
//  Copyright (c) 2014 Kyle Weiner. All rights reserved.
//

import UIKit

class ViewController: UIViewController, KWStepperDelegate {

    var stepper: KWStepper?

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var decrementButton: UIButton!
    @IBOutlet weak var incrementButton: UIButton!
    @IBOutlet weak var wrapsSwitch: UISwitch!
    @IBOutlet weak var autoRepeatSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureStepper()
        configureSwitches()
    }

    // MARK: Configuration

    func configureStepper() {
        self.stepper = KWStepper(
            decrementButton: self.decrementButton,
            incrementButton: self.incrementButton)

        if let stepper = self.stepper {
            stepper.addTarget(self,
                action: Selector("stepperDidChange"),
                forControlEvents: .ValueChanged)

            stepper.autoRepeat = true
            stepper.autoRepeatInterval = 0.10
            stepper.wraps = true
            stepper.minimumValue = 0
            stepper.maximumValue = 8
            stepper.value = 0
            stepper.incrementStepValue = 1
            stepper.decrementStepValue = 1

            stepper.delegate = self
        }
    }
    
    func configureSwitches() {
        if let stepper = self.stepper {
            self.wrapsSwitch.on = stepper.wraps
            self.autoRepeatSwitch.on = stepper.autoRepeat
        }

        self.wrapsSwitch.addTarget(self,
            action: Selector("switchDidChange:"),
            forControlEvents: .ValueChanged)

        self.autoRepeatSwitch.addTarget(self,
            action: Selector("switchDidChange:"),
            forControlEvents: .ValueChanged)
    }

    // MARK: KWStepper Events

    func stepperDidChange() {
        self.countLabel.text = NSString(format: "%.f", self.stepper!.value)
    }

    func stepperDidClampValue() {
        let stepper = self.stepper!
        let minValue = NSString(format: "%.f", stepper.minimumValue)
        let maxValue = NSString(format: "%.f", stepper.maximumValue)

        UIAlertView(
            title: "Stepper Limit Reached",
            message: "The step value was clamped, as it must be between \(minValue) and \(maxValue).",
            delegate: self,
            cancelButtonTitle: "OK"
        ).show()
    }

    // MARK: KWStepperDelegate Methods
    
    func KWStepperDidDecrement() {
        println("The stepper did decrement")
    }

    func KWStepperDidIncrement() {
        println("The stepper did increment")
    }

    func KWStepperMaxValueClamped() {
        println("Max value clamped")
        stepperDidClampValue()
    }
    
    func KWStepperMinValueClamped() {
        println("Min value clamped")
        stepperDidClampValue()
    }
    
    // MARK: UISwitch Events

    func switchDidChange(sender: UISwitch) {
        if let stepper = self.stepper {
            if (sender === self.wrapsSwitch) {
                stepper.wraps = self.wrapsSwitch.on
            }
            
            if (sender === self.autoRepeatSwitch) {
                stepper.autoRepeat = self.autoRepeatSwitch.on
            }
        }
    }

}

