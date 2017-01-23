//
//  UIAlertController+Helper.swift
//  Created by Kyle Weiner on 1/22/17.
//

import UIKit

extension UIAlertController {
    func addAlertAction(withTitle title: String?, style: UIAlertActionStyle = .default, handler: ((UIAlertAction) -> Void)?) -> Self {
        addAction(UIAlertAction(title: title, style: style, handler: handler))

        return self
    }
}
