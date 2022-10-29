//
//  ContentView.swift
//  HelloCoffee
//
//  Created by Supapon Pucknavin on 26/10/2565 BE.
//

import SwiftUI

struct ContentView: View {
    // MARK: - PROPERTY
    @State private var isPressented: Bool = false
    @EnvironmentObject private var model: CoffeeModel
    
    // MARK: - FUNCTION
    private func populateOrders() async {
        do{
            try await model.populateOrders()
        } catch {
            print(error)
        }
    }
    
    private func deleteOrder(_ order: Order) {
        
        Task {
            do {
                try await model.deleteOrder(order.id)
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            VStack {
                // **2. THEN CALL THIS
                if (model.orders.isEmpty){
                    Text("No orders available!")
                        .accessibilityIdentifier("noOrdersText")
                }else{
                    
                    List{
                        ForEach(model.orders) { order in
                            NavigationLink(value: order.id) {
                                OrderCellView(order: order)
                                    .swipeActions(edge: .trailing) {
                                        Button {
                                            deleteOrder(order)
                                        } label: {
                                            Label("Delete", systemImage:"trash")
                                        }
                                        .accessibilityIdentifier("DeleteOrder")
                                        .tint(.red)
                                        
                                    }//: SWIPE ACTION
                            }
                        }//: LOOP
                        
                        
                    }//: LIST
                    .accessibilityIdentifier("orderList")
                    
                }
                
            }//: VSTACK
            .navigationDestination(for: String.self, destination: { orderId in
                OrderDetailView(orderId: orderId)
            })
            .task {
                // **1. CALL THIS FIRST
                await populateOrders()
            }//: TASK
            .sheet(isPresented: $isPressented, content: {
                AddCoffeeView()
            })//: PRESENTED SHEET
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button("Add New Order") {
                        isPressented = true
                    }
                    .accessibilityIdentifier("addNewOrderButton")
                }
            }//: TOOL BAR
            
        }//: NAVIGATION
        
        
    }
}

// MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        var config = Configuration()
        let webservice = Webservice(baseURL: config.environment.baseURL)
        ContentView()
            .environmentObject(CoffeeModel(webservice: webservice))
    }
}

