//
//  LoanDetail.swift
//
//
//  Created by jocmp on 6/19/22.
//

import SwiftUI
import CoreData
import Arctic
import Money

struct LoanDetail: View {
    @FetchRequest var loans: FetchedResults<Loan>

    init(id: String) {
        _loans = FetchRequest(fetchRequest: Loan.findByID(id: id))
    }

    var body: some View {
        let loan = PresentedLoan.from(loan: loans.first)

        VStack(alignment: .leading) {
            Text(loan.name)
            Text("Current Amount")
            Text(loan.startingBalance)
            Text("Minimum Payment")
            Text(loan.minimumAmount)
            Text("Interest Rate")
            Text(loan.interestRate)
        }
    }
}

struct LoanDetail_Previews: PreviewProvider {
    static var previews: some View {
        LoanDetail(id: PersistenceController.sampleID)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

extension Loan {
    static func findByID(id: String) -> NSFetchRequest<Loan> {
      let request = Loan.fetchRequest()
      request.predicate = NSPredicate(format: "id = %@", id)
      request.sortDescriptors = []
      request.fetchLimit = 1
      return request
    }
}
