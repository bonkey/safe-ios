//
//  Copyright © 2018 Gnosis Ltd. All rights reserved.
//

import Foundation
import BigInt

public final class TokenNumberFormatter {

    public static let eth: TokenNumberFormatter = TokenNumberFormatter.ERC20Token(code: "ETH", decimals: 18)

    public static func ERC20Token(code: String? = nil, decimals: Int) -> TokenNumberFormatter {
        let formatter = TokenNumberFormatter()
        formatter.tokenCode = code
        formatter.decimals = decimals
        return formatter
    }

    var decimals: Int = 18
    var locale = Locale.autoupdatingCurrent
    var groupingSeparator: String { return locale.groupingSeparator ?? " " }
    var decimalSeparator: String { return locale.decimalSeparator ?? "," }
    var usesGroupingSeparator = false
    var usesGroupingSeparatorForFractionDigits = false
    var groupSize = 3
    var tokenSymbol: String?
    var tokenCode: String?

    public init() {}

    public func string(from number: BigInt) -> String {
        let tokenCurrency = tokenSymbol != nil ? " \(tokenSymbol!)" : (tokenCode != nil ? " \(tokenCode!)" : "")
        if number == 0 { return "0,00" + tokenCurrency }
        let sign = number.sign == .minus ? "-" : ""
        let str = String(number.magnitude)
        var integer = str.count <= decimals ? "0" : String(str.prefix(str.count - decimals))
        addIntegerGrouping(integer: &integer)
        var fraction = str.count <= decimals ? str.paddingWithLeadingZeroes(to: decimals) : String(str.suffix(decimals))
        fraction = fraction.removingTrailingZeroes
        addFractionGrouping(fraction: &fraction)
        let adjustedFraction = (fraction.isEmpty ? "00" : fraction) + (fraction.count == 1 ? "0" : "")
        return sign + integer + decimalSeparator + adjustedFraction + tokenCurrency
    }

    public func number(from string: String) -> BigInt? {
        let input = string.replacingOccurrences(of: groupingSeparator, with: "")
        if input == "0" { return 0 }
        let parts = input.components(separatedBy: decimalSeparator)
        guard !parts.isEmpty, let integer = BigInt(parts[0]) else { return nil }
        var fractionString = parts.count > 1 ? parts[1] : ""
        fractionString = fractionString.removingTrailingZeroes
        guard let fraction = BigInt(fractionString) else { return nil }
        return integer * BigInt(10).power(decimals) + fraction * BigInt(10).power(decimals - fractionString.count)
    }

    private func addFractionGrouping(fraction: inout String) {
        guard usesGroupingSeparatorForFractionDigits else { return }
        var insertionIndex = fraction.index(fraction.startIndex,
                                            offsetBy: groupSize,
                                            limitedBy: fraction.index(before: fraction.endIndex))
        while insertionIndex != nil && insertionIndex! < fraction.index(before: fraction.endIndex) {
            fraction.insert(Character(groupingSeparator), at: insertionIndex!)
            insertionIndex = fraction.index(insertionIndex!,
                                            offsetBy: groupSize,
                                            limitedBy: fraction.endIndex)
        }
    }

    private func addIntegerGrouping(integer: inout String) {
        guard usesGroupingSeparator else { return }
        var insertionIndex = integer.index(integer.endIndex,
                                           offsetBy: -groupSize,
                                           limitedBy: integer.startIndex)
        while insertionIndex != nil && insertionIndex! > integer.startIndex {
            integer.insert(Character(groupingSeparator), at: insertionIndex!)
            insertionIndex = integer.index(insertionIndex!,
                                           offsetBy: -groupSize,
                                           limitedBy: integer.startIndex)
        }
    }

}
