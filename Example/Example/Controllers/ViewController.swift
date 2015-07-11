//
//  ViewController.swift
//  Created by Kyle Weiner on 10/17/14.
//

import UIKit
import KWStepper

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

    // MARK: - Configuration

    func configureStepper() {
        // https://github.com/kyleweiner/KWStepper#usage
        stepper = KWStepper(
            decrementButton: decrementButton,
            incrementButton: incrementButton)

        // https://github.com/kyleweiner/KWStepper#configuring-kwstepper
        stepper.autoRepeat = true
        stepper.autoRepeatInterval = 0.10
        stepper.wraps = true
        stepper.minimumValue = 0
        stepper.maximumValue = 8
        stepper.value = 0
        stepper.incrementStepValue = 1
        stepper.decrementStepValue = 1

        // Adopting KWStepperDelegate provides optional methods for tailoring the UX.
        // https://github.com/kyleweiner/KWStepper#kwstepperdelegate
        stepper.delegate = self

        // Callbacks (closures) offer an alternative to the KWStepperDelegate protocol.
        // https://github.com/kyleweiner/KWStepper#callbacks
        stepper.valueChangedCallback = {
            self.countLabel.text = String(format: "%.f", self.stepper.value)
        }

        stepper.decrementCallback = {
            print("decrementCallback: The stepper did decrement \n")
        }

        stepper.incrementCallback = {
            print("incrementCallback: The stepper did increment \n")
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

    // MARK: - KWStepperDelegate
    // https://github.com/kyleweiner/KWStepper#kwstepperdelegate

    func KWStepperDidDecrement() {
    }

    func KWStepperDidIncrement() {
    }

    func KWStepperMaxValueClamped() {
        print("KWStepperDelegate: Max value clamped \n")
        stepperDidClampValue()
    }

    func KWStepperMinValueClamped() {
        print("KWStepperDelegate: Min value clamped \n")
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

    // MARK: - UISwitch Events

    func switchDidChange(sender: UISwitch) {
        if (sender === wrapsSwitch) {
            stepper.wraps = wrapsSwitch.on
        }

        if (sender === autoRepeatSwitch) {
            stepper.autoRepeat = autoRepeatSwitch.on
        }
    }
    
}