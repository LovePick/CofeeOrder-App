//
//  OrderCellView.swift
//  HelloCoffee
//
//  Created by Supapon Pucknavin on 26/10/2565 BE.
//

import SwiftUI

struct OrderCellView: View {
    // MARK: - PROPERTY
    let order: Order
    
    
    // MARK: - BODY
    var body: some View {
        
        HStack{
            
            VStack(alignment: .leading, spacing: 5) {
                
                Text(order.name)
                    .accessibilityIdentifier("orderNameText")
                    .font(.title2)
                    .fontWeight(.bold)
                    .allowsHitTesting(false)
                
                Text("\(order.coffeeName) (\(order.size.rawValue))")
                    .accessibilityIdentifier("coffeeNameAndSizeText")
                    .font(.caption)
                    .opacity(0.5)
                    .multilineTextAlignment(.leading)
                    .allowsHitTesting(false)
            }//: VSTACK

            Spacer()
            
            Text(order.total as NSNumber, formatter: NumberFormatter.currency)
                .accessibilityIdentifier("coffeePriceText")
                .allowsHitTesting(false)
            
         
        }//: HSTACK
       
    }
}

// MARK: - PREVIEW
struct OrderCellView_Previews: PreviewProvider {
    static var previews: some View {
        OrderCellView(order: Order(name: "John Doe", coffeeName: "Cappuccino", total: 1, size: .large))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
