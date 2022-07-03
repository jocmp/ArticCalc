//
//  ContentView.swift
//  Shared
//
//  Created by jocmp on 6/12/22.
//

import SwiftUI
import CoreData

struct LoanList: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showAddLoanForm = false

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Loan.createdAt, ascending: true)],
        animation: .default)
    private var results: FetchedResults<Loan>

    private var loans: [PresentedLoan] {
        results.map { PresentedLoan.from(loan: $0) }
    }

    var body: some View {
        NavigationView {
            List {
                NavigationLink {
                    PaymentPlanIndex()
                } label: {
                    Text("Overview")
                }
                Section("Loans") {
                    ForEach(loans) { loan in
                        NavigationLink {
                            LoanDetail(id: loan.id)
                        } label: {
                            Text(loan.name)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Loan", systemImage: "plus")
                    }
                    .sheet(isPresented: $showAddLoanForm) {
                        AddLoanModal()
                    }
                }
            }
            Text("Select an item")
        }
    }

    private func addItem() {
        showAddLoanForm = true
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { results[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoanList().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
