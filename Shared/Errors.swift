//
//  Errors.swift
//  ArcticApp
//
//  Created by jocmp on 6/21/22.
//

import Foundation

struct Error: Identifiable {
    let attribute: String
    let type: ErrorType

    enum ErrorType {
        case Presence
        case MoneyFormat
        case DoubleFormat
        case Uniqueness
    }

    var id: String {
        return "\(attribute):\(type)"
    }

    var printed: String {
        switch type {
        case .Presence:
            return "Presence"
        case .MoneyFormat:
            return "Money"
        case .DoubleFormat:
            return "Double"
        case .Uniqueness:
            return "Uniqueness"
        }
    }
}
