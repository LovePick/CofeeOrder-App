//
//  OrderDetailView.swift
//  HelloCoffee
//
//  Created by Supapon Pucknavin on 29/10/2565 BE.
//

import SwiftUI

struct OrderDetailView: View {
    // MARK: - PROPERTY
    @EnvironmentObject private var model: CoffeeModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var isPresented: Bool = false
    @State private var showingAlert: Bool = false
    
    let orderId: String
    
    // MARK: - FUNCTION
    private func deleteOrder() async {
        do{
            try await model.deleteOrder(orderId)
            dismiss()
        } catch {
            print(error)
        }
    }
    
    // MARK: - BODY
    var body: some View {
        VStack {
            if let order = model.orderById(orderId) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(order.coffeeName)
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .accessibilityIdentifier("coffeeNameText")
                    
                    Text(order.size.rawValue)
                        .opacity(0.5)
                    
                    Text(order.total as NSNumber, formatter: NumberFormatter.currency)
                    
                    
                    
                    HStack{
                        Spacer()
                        
                        Button("Delete Order", role: .destructive){
                            showingAlert = true
                        }//: BUTTON DELETE
                        .accessibilityIdentifier("deleteOrder")
                        .alert("Are you sure?\nYou want to delete order.", isPresented: $showingAlert){
                            Button("Delete") {
                                Task {
                                    await deleteOrder()
                                }
                            }
                            .accessibilityIdentifier("confirmDelete")
                            
                            Button("Cancel", role: .cancel) { }
                        }
                        
                        Button("Edit Order") {
                            isPresented = true
                        }//: BUTTON EDIT
                        .accessibilityIdentifier("editOrderButton")
                        
                        Spacer()
                    }//: HSTACK
                    
                }//: VSTACK
                .sheet(isPresented: $isPresented) {
                    AddCoffeeView(order: order)
                }
                
                
            } else {
                EmptyView()
            }
            
            Spacer()
        }//: VSTACK
        .padding()
    }
}

// MARK: - PREVIEW
struct OrderDetailView_Previews: PreviewProvider {
    static var previews: some View {
        var config = Configuration()
        let webservice = Webservice(baseURL: config.environment.baseURL)
        
        OrderDetailView(orderId: UUID().uuidString)
            .environmentObject(CoffeeModel(webservice: webservice))
    }
}
