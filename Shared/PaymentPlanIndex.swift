//
//  PaymentPlanIndex.swift
//  Arctic
//
//  Created by jocmp on 6/19/22.
//

import SwiftUI
import Charts

struct PaymentPlanIndex: View {
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        PaymentPlanTable(paymentPlan: PresentedPaymentPlan(viewContext: viewContext))
    }
}
            
struct PaymentPlanTable: View {
    @ObservedObject var paymentPlan: PresentedPaymentPlan
    let step: Double = 10
    
    var body: some View {
        VStack {
            Stepper(
                "Monthly Payment",
                value: $paymentPlan.monthlyPayment,
                in: (paymentPlan.minimumPayment...3_000),
                step: step
            )
            Text("Monthly Payment: \(paymentPlan.monthlyPayment)")
            Text("Interest Paid: \(paymentPlan.interestPaid)")
            Text("Principal Paid: \(paymentPlan.principalPaid)")
        }.padding()
        Chart {
            ForEach(paymentPlan.monthlyBalanceSheets) { balanceSheet in
                ForEach(balanceSheet.rows, id: \.date) { row in
                    AreaMark(
                        x: .value("Day", row.date, unit: .month),
                        y: .value("Sales", row.principalBalance)
                    )
                }
                .foregroundStyle(by: .value("Loan Name", balanceSheet.name))                
            }
        }
    }
}

struct PaymentPlanIndex_Previews: PreviewProvider {
    static var previews: some View {
        PaymentPlanIndex()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
