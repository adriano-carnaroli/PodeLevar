//
//  String.swift
//
//  Created by Adriano Carnaroli.
//  Copyright © 2021 Adriano Carnaroli. All rights reserved.
//

import UIKit

extension String {

    static func strNil() -> String {
        return "nil"
    }

    static func empty() -> String {
        return ""
    }

    static func undefined() -> String {
        return "undefined"
    }

    func captalizeFirstCharacter() -> String {
        var result = self.lowercased()
        if !result.isEmpty {
            let substr1 = String(self[startIndex]).uppercased()
            result.replaceSubrange(...startIndex, with: substr1)
        }
        return result
    }

    func captalizeFirstCharacterWithoutLowerOthers() -> String {
        var result = self
        if !result.isEmpty {
            let substr1 = String(self[startIndex]).uppercased()
            result.replaceSubrange(...startIndex, with: substr1)
        }
        return result
    }

    func replace(_ index: Int, _ newChar: Character) -> String {
        var chars = Array(self)
        chars[index] = newChar
        let modifiedString = String(chars)
        return modifiedString
    }

    func captalizeFirstCharacterOnEachParagraph() -> String {
        let result = self.split(separator: ".")
        var formatedString = String.empty()
        for item in result {
            if !item.trimmingCharacters(in: .whitespaces).isEmpty {
                formatedString += item.trimmingCharacters(in: .whitespaces).captalizeFirstCharacter() + ". "
            }
        }
        return formatedString
    }

    public func removeDotPoints() -> String {
        return self.replacingOccurrences(of: ".", with: String.empty())
    }

    public func trim() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }

    public func getFirstNameUser(name:String) -> String {
        let fullName = name
        let fullNameArr = fullName.components(separatedBy: " ")
        return !fullNameArr.isEmpty ? fullNameArr.first! : fullName
    }

    var stringToAttributedString:NSAttributedString {
        return NSAttributedString(string: self, attributes: [
            .font: UIFont.systemFont(ofSize: 16),
          .foregroundColor: UIColor.init(hexString: ColorsHex.greyIsBrown)
        ])
    }

    static func dateFormatter(timeStamp:Double, patternOutput:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: Locale.current.identifier + "_POSIX")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = patternOutput
        let date = Date(timeIntervalSince1970: timeStamp/1000)
        return dateFormatter.string(from: date)
    }

    static func dateFormatter(date:Date, patternOutput:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: Locale.current.identifier + "_POSIX")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = patternOutput
        return dateFormatter.string(from: date)
    }

    public func dateFormatter(patternInput:String? = "yyyy-MM-dd'T'HH:mm:ss.SSSZ", patternOutput:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = patternInput
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        let formatter = DateFormatter()
        formatter.dateFormat = patternOutput
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current

        guard let date = dateFormatter.date(from: self) else { return String.empty()}
        return formatter.string(from: date)
    }

    public func removeMaskFromCPF() -> String {
        return self.replacingOccurrences(of: " ", with: String.empty())
            .replacingOccurrences(of: ".", with: String.empty()).replacingOccurrences(of: "-", with: String.empty())
    }

    public func removeMaskFromDocument() -> String {
        return self.replacingOccurrences(of: " ", with: String.empty())
            .replacingOccurrences(of: ".", with: String.empty()).replacingOccurrences(of: "-", with: String.empty())
            .replacingOccurrences(of: "/", with: String.empty())
    }

    public func removeMaskFromCellphone() -> String {
        return self.replacingOccurrences(of: " ", with: String.empty())
            .replacingOccurrences(of: "-", with: String.empty()).replacingOccurrences(of: "(", with: String.empty()).replacingOccurrences(of: ")", with: String.empty())
    }

    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value:String.empty(), comment: String.empty())
    }

    func localized(withComment:String) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: String.empty(), comment: withComment)
    }

    func customLocalize(_ stringFileName:String) -> String {
        return  NSLocalizedString(self, tableName: stringFileName, bundle: Bundle.main, value: String.empty(), comment: String.empty())
    }

    var maskPhoneNumber: String {
        let array = [0, 1, 2, 3, 4, self.count - 1, self.count - 2, self.count - 3, self.count - 4]
        return String(self.enumerated().map { index, char in
            return array.contains(index) ? char : "*"
        })
     }

    // MARK: - Email Validate
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }

    var isValidCellphone: Bool {
        let phoneRegex = "^\\([1-9]{2}\\) (?:[2-8]|9[1-9])[0-9]{3}\\-[0-9]{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        let result = phoneTest.evaluate(with: self)
        return result
    }

    var isValidPass: String {
        let checkTextLen = self.trim().count >= 8
        if !checkTextLen { return "A senha deve ter ao menos 8 digitos" }
        let checkTwoNumbers = self.trim().components(separatedBy: CharacterSet.decimalDigits.inverted).joined().count >= 2
        if !checkTwoNumbers { return "A senha deve ter ao menos 2 números" }
        let checkSpecialCharacter = !self.trim().components(separatedBy: CharacterSet.punctuationCharacters.inverted).joined().isEmpty
        if !checkSpecialCharacter { return "A senha deve ter ao menos 1 caracter especial" }
        let checkUppercase = !self.trim().components(separatedBy: CharacterSet.uppercaseLetters.inverted).joined().isEmpty
        if !checkUppercase { return "A senha deve ter ao menos 1 letra maiúscula" }
        return String.empty()
    }

    func isValidDate(minYearDate:Int, maxYearDate:Int) -> Bool {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"

        if let dateOfBirth = dateFormatter.date(from:self) {
            guard let todayDateLessMinYears = Calendar.current.date(byAdding: .year, value: -minYearDate, to: Date()) else { return false}
            guard let todayDatePlusMaxYears = Calendar.current.date(byAdding: .year, value: maxYearDate, to: Date()) else { return false}
            if dateOfBirth > todayDateLessMinYears && dateOfBirth <= todayDatePlusMaxYears {
                return false
            } else {
                return true
            }
        } else {
           return false
        }
    }

    func isValidDateForDocument(dateOfBirth: String, docEmittingDate: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if let birthDate = dateFormatter.date(from: dateOfBirth), let emittingdate = dateFormatter.date(from: docEmittingDate) {
            if birthDate > emittingdate {
                return false
            }
        }
        return true
    }

    func withMask(mask: String) -> String {
        var resultString = String()

        let chars = self
        let maskChars = mask

        var stringIndex = chars.startIndex
        var maskIndex = mask.startIndex

        while stringIndex < chars.endIndex && maskIndex < maskChars.endIndex {
            if (maskChars[maskIndex] == "#") {
                resultString.append(chars[stringIndex])
                stringIndex = chars.index(after: stringIndex)
            } else {
                resultString.append(maskChars[maskIndex])
            }
            maskIndex = mask.index(after: maskIndex)
        }

        return resultString
    }

    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html,
                                                                .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }

    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }

    var unescaped: String {
        let entities = ["\0", "\t", "\n", "\r", "\"", "\'", "\\"]
        var current = self
        for entity in entities {
            let descriptionCharacters = entity.debugDescription.dropFirst().dropLast()
            let description = String(describing: descriptionCharacters)
            current = current.replacingOccurrences(of: description, with: entity)
        }
        return current
    }

    // MARK: - Call Phone
    enum RegularExpressions: String {
        case phone = "^\\s*(?:\\+?(\\d{1,3}))?([-. (]*(\\d{3})[-. )]*)?((\\d{3})[-. ]*(\\d{2,4})(?:[-.x ]*(\\d+))?)\\s*$"
    }

    func isValid(regex: RegularExpressions) -> Bool {
        return isValid(regex: regex.rawValue)
    }

    func isValid(regex: String) -> Bool {
        let matches = range(of: regex, options: .regularExpression)
        return matches != nil
    }

    func onlyDigits() -> String {
        let filtredUnicodeScalars = unicodeScalars.filter { CharacterSet.decimalDigits.contains($0) }
        return String(String.UnicodeScalarView(filtredUnicodeScalars))
    }

    func makeAColl() {
        if isValid(regex: .phone) {
            if let url = URL(string: "tel://\(self.onlyDigits())"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }

    func withoutDecimals() -> String {
        return String(format: "%g", Double(self) ?? String.empty())
    }

    func change(_ ofEntry:String, toEntry:String) -> String {
        return replacingOccurrences(of: ofEntry, with: toEntry)
    }

    func stringBrToCurrency() -> String {
        return self.replacingOccurrences(of: "R$", with: String.empty())
            .replacingOccurrences(of: ".", with: String.empty()).replacingOccurrences(of: ",", with: ".").trim()
    }

    func currencyDouble() -> Double {
         var amount:String = self
        amount = amount.trim().replacingOccurrences(of: ".", with: String.empty())
                               .replacingOccurrences(of: ",", with: String.empty())
        let converted:Double = Double(amount) ?? 0

        return converted > 0 ? converted / 100 : 0
    }

    var currencyStringToDouble:Double {
        let formatter = NumberFormatter()

        formatter.numberStyle = .currency
        formatter.currencySymbol = "R$"
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.decimalSeparator = ","

        var newString = self.replacingOccurrences(of: " ", with: String.empty())

        if newString.contains(".") && newString.contains(",") {
            newString = newString.replacingOccurrences(of: ".", with: String.empty())
        } else if newString.contains(".") {
            newString = newString.replacingOccurrences(of: ".", with: ",")
        }

        return formatter.number(from: newString)?.doubleValue ?? 0.0
    }

    var percent:String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.multiplier = 1
        formatter.roundingMode = .halfUp
        formatter.groupingSeparator = ","
        return formatter.string(for: Double(self)) ?? "0.0"
    }

    subscript (char: Int) -> String {
        return self[char ..< char + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, count) ..< count]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (rang: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(count, rang.lowerBound)),
                                            upper: min(count, max(0, rang.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }

    func saveStringInPasteBoard(string:String) {
        UIPasteboard.general.string = string
    }

    func setMaskCPF() -> String? {
        let cpf = self
        var masked:String =  ""

        if cpf != String.empty() {
            var characters = Array(cpf)
            characters.insert(".", at: 3)//399.77666814
            characters.insert(".", at: 7)//399.776.66814
            characters.insert("-", at: 11)//399.776.668-14
            masked = String(characters)
        } else {
            return nil
        }

        return masked
    }

    func setMaskPhoneAndCellPhone() -> String? {
        let cellphone = self
        var masked:String =  ""
        if cellphone != String.empty() {
            var characters = Array(cellphone)
            if characters.count == 11 {
                characters.insert("(", at: 0)
                characters.insert(")", at: 3)
                characters.insert(" ", at: 4)
                characters.insert("-", at: 10)
                masked = String(characters)
            } else if characters.count == 10 {
                characters.insert("(", at: 0)
                characters.insert(")", at: 3)
                characters.insert(" ", at: 4)
                characters.insert("-", at: 9)
                masked = String(characters)
            }
        } else {
            return nil
        }
        return masked
    }

    func formatterDocument() -> String {
        let document = self.removeMaskFromDocument()
        if document.count == 11 {
            return document.withMask(mask: Constants.cpfMask)
        }
        return self
    }
}
