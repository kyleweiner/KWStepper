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
}

// MARK: - Stepper Configuration & Event Handling

extension ViewController {
    func configureStepper() {
        // https://github.com/kyleweiner/KWStepper#usage
        stepper = KWStepper(decrementButton: decrementButton, incrementButton: incrementButton)

        // https://github.com/kyleweiner/KWStepper#configuring-kwstepper
        stepper
            .maximumValue(10)
            .valueChanged { [unowned self] stepper in
                self.countLabel.text = String(format: "%.f", stepper.value)
            }
            .valueClamped { [unowned self] stepper in
                self.presentValueClampedAlert()
            }
    }

    // Presents a `UIAlertController` when the stepper's value is clamped.
    fileprivate func presentValueClampedAlert() {
        let alertController = UIAlertController(
            title: "Stepper Limit Reached",
            message: "The step value was clamped. It must be between \(stepper.minimumValue) and \(stepper.maximumValue).",
            preferredStyle: .alert
        ).addAlertAction(withTitle: "OK", handler: nil)

        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UISwitch Configuration & Event Handling

extension ViewController {
    fileprivate func configureSwitches() {
        wrapsSwitch.isOn = stepper.wraps
        autoRepeatSwitch.isOn = stepper.autoRepeat
    }

    @IBAction func switchDidChange(_ sender: UISwitch) {
        if sender === wrapsSwitch {
            stepper.wraps = wrapsSwitch.isOn
        }

        if sender === autoRepeatSwitch {
            stepper.autoRepeat = autoRepeatSwitch.isOn
        }
    }
}
