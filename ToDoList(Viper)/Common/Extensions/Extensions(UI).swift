//
//  Extensions(UI).swift
//  ToDoList(Viper)
//
//  Created by Pavel Maal on 5.08.25.
//

import Foundation
import UIKit

extension UILabel {
    func strikeThrough(_ isStrikeThrough: Bool) {
        guard let text = self.text else { return }

        let attributeString = NSMutableAttributedString(string: text)
        if isStrikeThrough {
            attributeString.addAttribute(
                .strikethroughStyle,
                value: NSUnderlineStyle.single.rawValue,
                range: NSMakeRange(0, attributeString.length)
            )
        } else {
            attributeString.removeAttribute(.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
        }
        self.attributedText = attributeString
    }
}
