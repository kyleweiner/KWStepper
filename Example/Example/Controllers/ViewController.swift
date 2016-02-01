//
//  ViewController.swift
//  Created by Kyle Weiner on 10/17/14.
//

import UIKit
import KWStepper

class ViewController: UIViewController {
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
        stepper = KWStepper(decrementButton: decrementButton, incrementButton: incrementButton)

        // https://github.com/kyleweiner/KWStepper#configuring-kwstepper
        stepper.maximumValue = 9

        // Adopting KWStepperDelegate provides optional methods for tailoring the UX.
        // https://github.com/kyleweiner/KWStepper#kwstepperdelegate
        stepper.delegate = self

        // Callbacks (closures) offer an alternative to the KWStepperDelegate protocol.
        // https://github.com/kyleweiner/KWStepper#callbacks
        stepper.valueChangedCallback = { [unowned self] stepper in
            self.countLabel.text = String(format: "%.f", stepper.value)
        }
    }

    // MARK: - Helper

    private func configureSwitches() {
        wrapsSwitch.on = stepper.wraps
        autoRepeatSwitch.on = stepper.autoRepeat
    }

    // MARK: - UISwitch Events

    @IBAction func switchDidChange(sender: UISwitch) {
        if sender === wrapsSwitch {
            stepper.wraps = wrapsSwitch.on
        }

        if sender === autoRepeatSwitch {
            stepper.autoRepeat = autoRepeatSwitch.on
        }
    }
}

// MARK: - KWStepperDelegate

extension ViewController: KWStepperDelegate {
    func KWStepperMaxValueClamped() {
        stepperDidClampValue()
    }

    func KWStepperMinValueClamped() {
        stepperDidClampValue()
    }

    private func stepperDidClampValue() {
        let minValue = NSString(format: "%.f", stepper.minimumValue)
        let maxValue = NSString(format: "%.f", stepper.maximumValue)

        let alertController = UIAlertController(
            title: "Stepper Limit Reached",
            message: "The step value was clamped. It must be between \(minValue) and \(maxValue).",
            preferredStyle: .Alert
        )

        let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(alertAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
}