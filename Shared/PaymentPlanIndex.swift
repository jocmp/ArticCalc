//
//  PaymentPlanIndex.swift
//  Arctic
//
//  Created by jocmp on 6/19/22.
//

import SwiftUI

struct PaymentPlanIndex: View {
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        PaymentPlanTable(presented: PresentedPaymentPlan(viewContext: viewContext))
    }
}
            
struct PaymentPlanTable: View {
    @ObservedObject var presented: PresentedPaymentPlan
    let step = 10
    
    var body: some View {
        VStack {
            Stepper(
                "Monthly Payment",
                value: $presented.monthlyPayment,
                in: (presented.minimumPayment...3_000),
                step: step
            )
            Text("Monthly Payment: \($presented.monthlyPayment.wrappedValue)")
            Text(presented.interestPaid)
            Text(presented.principalPaid)
        }
    }
}

struct PaymentPlanIndex_Previews: PreviewProvider {
    static var previews: some View {
        PaymentPlanIndex()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
