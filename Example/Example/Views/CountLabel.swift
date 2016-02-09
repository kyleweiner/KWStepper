//
//  CountLabel.swift
//  Created by Kyle Weiner on 10/18/14.
//

import UIKit

class CountLabel: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()

        font = UIFont(descriptor: font.fontDescriptor().stepperDescriptor(), size: 0)
    }
}

extension UIFontDescriptor {
    func stepperDescriptor() -> UIFontDescriptor {
        return fontDescriptorByAddingAttributes([
            UIFontDescriptorFeatureSettingsAttribute: [
                [
                    UIFontFeatureTypeIdentifierKey: kNumberSpacingType,
                    UIFontFeatureSelectorIdentifierKey: kProportionalNumbersSelector
                ],
                [
                    UIFontFeatureTypeIdentifierKey: kCharacterAlternativesType,
                    UIFontFeatureSelectorIdentifierKey: 1
                ]
            ]
        ])
    }
}