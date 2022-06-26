//
//  AddLoanForm.swift
//  Arctic
//
//  Created by jocmp on 6/19/22.
//

import SwiftUI

struct AddLoanForm: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var form = LoanForm()

    var onLoanAdded: (() -> Void)?

    var body: some View {
        VStack {
            Text("addLoanForm.title")
            TextField("name", text: $form.name)
            TextField("currentLoanAmount", text: $form.startingBalance)
            TextField("minimumMonthlyPayment", text: $form.minimumPayment)
            TextField("interestRate", text: $form.interestRate)

            Button("addLoanForm.saveButton") {
                addLoan()
            }
            if !form.errors.isEmpty {
                ForEach(form.errors) { error in
                    Text("\(error.attribute) => \(error.printed)")
                }
            }
        }.padding()
    }

    func addLoan() {
        if form.create(viewContext: viewContext) {
            guard let safeOnLoanAdded = onLoanAdded else { return }
            safeOnLoanAdded()
        }
    }
}

struct AddLoanForm_Previews: PreviewProvider {
    static var previews: some View {
        AddLoanForm()
    }
}
