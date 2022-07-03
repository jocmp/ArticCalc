//
//  PaymentPlan.swift
//  ArcticApp
//
//  Created by jocmp on 7/3/22.
//

import Foundation
import CoreData

class PaymentPlan: ObservableObject {
    @FetchRequest var loans: FetchedResults<Loan>

    init(id: String) {
        _loans = FetchRequest(fetchRequest: Loan.findByID(id: id))
    }
}
