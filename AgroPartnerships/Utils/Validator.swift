//
//  Validator.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 10/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit

class Validator {
    static let EMAIL_ADDRESS =
        "[a-zA-Z0-9\\+\\.\\_\\%\\-\\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
            "\\." +
            "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+"

    // Validator e-mail from string
    static func isValidEmail(_ value: String) -> Bool {
        let string = value.trimmingCharacters(in: .whitespacesAndNewlines)
        let predicate = NSPredicate(format: "SELF MATCHES %@", Validator.EMAIL_ADDRESS)
        return predicate.evaluate(with: string) || string.isEmpty
    }

    static func isValidEmail(field: UITextField, show: Bool = true) -> Bool {
        if Validator.isValidEmail(field.text!) {
            field.setError()
            return true
        } else {
            field.setError("Error message", show: show)
        }
        return false
    }
}
