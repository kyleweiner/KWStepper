//
//  ViewController.swift
//  KWStepperDemo
//
//  Created by Kyle Weiner on 10/17/14.
//  Copyright (c) 2014 Kyle Weiner. All rights reserved.
//

import UIKit

class ViewController: UIViewController, KWStepperDelegate {

    var stepper: KWStepper!

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
        stepper = KWStepper(
            decrementButton: decrementButton,
            incrementButton: incrementButton)

        stepper.autoRepeat = true
        stepper.autoRepeatInterval = 0.10
        stepper.wraps = true
        stepper.minimumValue = 0
        stepper.maximumValue = 8
        stepper.value = 0
        stepper.incrementStepValue = 1
        stepper.decrementStepValue = 1

        stepper.delegate = self
        
        stepper.valueChangedCallback = {
            self.countLabel.text = NSString(format: "%.f", self.stepper.value)
        }

        stepper.decrementCallback = {
            println("decrementCallback: The stepper did decrement")
        }

        stepper.incrementCallback = {
            println("incrementCallback: The stepper did increment")
        }
    }

    func configureSwitches() {
        wrapsSwitch.on = stepper.wraps
        autoRepeatSwitch.on = stepper.autoRepeat

        wrapsSwitch.addTarget(self,
            action: "switchDidChange:",
            forControlEvents: .ValueChanged)

        autoRepeatSwitch.addTarget(self,
            action: "switchDidChange:",
            forControlEvents: .ValueChanged)
    }

    // MARK: KWStepperDelegate
    
    func KWStepperDidDecrement() {
    }
    
    func KWStepperDidIncrement() {
    }
    
    func KWStepperMaxValueClamped() {
        println("KWStepperDelegate: Max value clamped")
        stepperDidClampValue()
    }
    
    func KWStepperMinValueClamped() {
        println("KWStepperDelegate: Min value clamped")
        stepperDidClampValue()
    }

    func stepperDidClampValue() {
        let minValue = NSString(format: "%.f", stepper.minimumValue)
        let maxValue = NSString(format: "%.f", stepper.maximumValue)
        
        UIAlertView(
            title: "Stepper Limit Reached",
            message: "The step value was clamped, as it must be between \(minValue) and \(maxValue).",
            delegate: self,
            cancelButtonTitle: "OK"
        ).show()
    }

    // MARK: UISwitch Events

    func switchDidChange(sender: UISwitch) {
        if (sender === wrapsSwitch) {
            stepper.wraps = wrapsSwitch.on
        }

        if (sender === autoRepeatSwitch) {
            stepper.autoRepeat = autoRepeatSwitch.on
        }
    }

}

