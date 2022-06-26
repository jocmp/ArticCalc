//
//  AddLoanModal.swift
//  Arctic
//
//  Created by jocmp on 6/19/22.
//

import SwiftUI

struct AddLoanModal: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        AddLoanForm() {
            dismiss()
        }
    }
}

struct AddLoanModal_Previews: PreviewProvider {
    static var previews: some View {
        AddLoanModal()
    }
}
