//
//  CountLabel.swift
//  Created by Kyle Weiner on 10/18/14.
//

import UIKit

class CountLabel: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()

        font = UIFont(descriptor: font.fontDescriptor.stepperDescriptor(), size: 0)
    }
}

extension UIFontDescriptor {
    func stepperDescriptor() -> UIFontDescriptor {
        return addingAttributes([
            UIFontDescriptor.AttributeName.featureSettings: [
                [
                    UIFontDescriptor.FeatureKey.featureIdentifier: kNumberSpacingType,
                    UIFontDescriptor.FeatureKey.typeIdentifier: kProportionalNumbersSelector
                ],
                [
                    UIFontDescriptor.FeatureKey.featureIdentifier: kCharacterAlternativesType,
                    UIFontDescriptor.FeatureKey.typeIdentifier: 1
                ]
            ]
        ])
    }
}
