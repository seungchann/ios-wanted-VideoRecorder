//
//  UIColor+extension.swift
//  VideoRecorder
//
//  Created by 유영훈 on 2022/11/08.
//

import UIKit

extension UIColor {
    struct DefaultTheme {
        static var mainBackground: UIColor { return UIColor(named: "backgroundColorAsset")! }
        static var mainForeground: UIColor { return UIColor(named: "foregroundColorAsset")! }
        static var subText: UIColor { return UIColor(named: "subTextColorAsset")! }
    }
}
