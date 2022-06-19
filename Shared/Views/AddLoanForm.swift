//
//  AddLoanForm.swift
//  Artic
//
//  Created by Josiah Campbell on 6/19/22.
//

import SwiftUI

struct AddLoanForm: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var form = LoanForm()

    var onLoanAdded: (() -> Void)?
    
    var body: some View {
        Text("Add Loan Form here!")
        TextField("Name", text: $form.name)
        Button("Save") {
            addLoan()
        }
    }
    
    func addLoan() {
        form.create(viewContext: viewContext)
        guard onLoanAdded != nil else { return }
        onLoanAdded!()
    }

    func createLoanRecord() {

    }
}

struct AddLoanForm_Previews: PreviewProvider {
    static var previews: some View {
        AddLoanForm()
    }
}
