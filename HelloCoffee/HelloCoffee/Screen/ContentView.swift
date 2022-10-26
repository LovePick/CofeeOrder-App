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
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            VStack {
                // **2. THEN CALL THIS
                if (model.orders.isEmpty){
                    Text("No orders available!")
                        .accessibilityIdentifier("noOrdersText")
                }else{
                    
                    List(model.orders){ order in
                        OrderCellView(order: order)
                    }//: LIST
                }
                
            }//: VSTACK
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

