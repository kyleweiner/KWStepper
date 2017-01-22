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

        stepper
            // https://github.com/kyleweiner/KWStepper#configuring-kwstepper
            .maximumValue(9)

            // Adopting KWStepperDelegate provides optional methods for tailoring the UX.
            // https://github.com/kyleweiner/KWStepper#kwstepperdelegate
            .delegate(self)

            // Callbacks (closures) offer an alternative to the KWStepperDelegate protocol.
            // https://github.com/kyleweiner/KWStepper#callbacks
            .valueChanged { [unowned self] stepper in
                self.countLabel.text = String(stepper.value)
            }
    }

    // MARK: - Helper

    private func configureSwitches() {
        wrapsSwitch.isOn = stepper.wraps
        autoRepeatSwitch.isOn = stepper.autoRepeat
    }

    // MARK: - UISwitch Events

    @IBAction func switchDidChange(_ sender: UISwitch) {
        if sender === wrapsSwitch {
            stepper.wraps = wrapsSwitch.isOn
        }

        if sender === autoRepeatSwitch {
            stepper.autoRepeat = autoRepeatSwitch.isOn
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
            preferredStyle: .alert
        )

        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)

        present(alertController, animated: true, completion: nil)
    }
}
