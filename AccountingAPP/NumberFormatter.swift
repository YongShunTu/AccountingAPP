//
//  NumberFormatter.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/3/5.
//

import Foundation

class NumberStyle {
    static func currencyStyle() -> NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "Zh_TW")
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter
    }

    static func percentStyle() -> NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter
    }
}
