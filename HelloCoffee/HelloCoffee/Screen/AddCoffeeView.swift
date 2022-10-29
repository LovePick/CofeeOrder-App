//
//  AddCoffeeView.swift
//  HelloCoffee
//
//  Created by Supapon Pucknavin on 26/10/2565 BE.
//

import SwiftUI

struct AddCoffeeErrors {
    var name: String = ""
    var coffeeName: String = ""
    var prie: String = ""
}

struct AddCoffeeView: View {
    // MARK: - PROPERTY
    var order: Order? = nil
    @State private var name: String = ""
    @State private var coffeeName: String = ""
    @State private var price: String = ""
    @State private var coffeeSize: CoffeeSize = .medium
    @State private var errors: AddCoffeeErrors = AddCoffeeErrors()
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var model: CoffeeModel
    
    // MARK: - FUNCTION
    var isValid: Bool {
        errors = AddCoffeeErrors()
        
        // This is NOT a business rule
        // This is just UI valication
        if name.isEmpty {
            errors.name = "Name cannot be empty!"
        }
        
        if coffeeName.isEmpty {
            errors.coffeeName = "Coffee name cannot be empty!"
        }
        
        if price.isEmpty {
            errors.prie = "Price cannot be empty!"
        } else if (!price.isNumeric) {
            errors.prie = "Price need to be a number"
        } else if price.isLessThan(1) {
            errors.prie = "Price needs to be more than 0"
        }
        
        return errors.name.isEmpty && errors.prie.isEmpty && errors.coffeeName.isEmpty
    }
    
    
    private func placeOrder(_ order:Order) async {
        
        
        do {
            try await model.placeOrder(order)
        } catch {
            print(error)
        }
        
    }
    
    private func updateOrder(_ order:Order) async {
        do {
            try await model.updateOrder(order)
        } catch {
            print(error)
        }
    }
    
    private func saveOrUpdate() async {
        if let order {
            var editOrder = order
            editOrder.name = name
            editOrder.coffeeName = coffeeName
            editOrder.total = Double(price) ?? 0.0
            editOrder.size = coffeeSize
            
            await updateOrder(editOrder)
        } else {
            let order = Order(name: name, coffeeName: coffeeName, total: Double(price) ?? 0, size: coffeeSize)
            await placeOrder(order)
        }
        
        //dismiss
        dismiss()
    }
    
    
    private func populateExistingOrder() {
        if let order = order {
            name = order.name
            coffeeName = order.coffeeName
            price = String(order.total)
            coffeeSize = order.size
        }
    }
    
    // MARK: - BODY
    var body: some View {
        
        NavigationStack {
            Form{
                TextField("Name", text: $name)
                    .accessibilityIdentifier("name")
                Text(errors.name)
                    .visible(errors.name.isNotEmpty)
                    .font(.caption)
                    .foregroundColor(.red)
                
                
                TextField("Coffee name", text: $coffeeName)
                    .accessibilityIdentifier("coffeeName")
                Text(errors.coffeeName)
                    .visible(errors.coffeeName.isNotEmpty)
                    .font(.caption)
                    .foregroundColor(.red)
                
                
                TextField("Price", text: $price)
                    .accessibilityIdentifier("price")
                Text(errors.prie)
                    .visible(errors.prie.isNotEmpty)
                    .font(.caption)
                    .foregroundColor(.red)
                
                
                
                Picker("Select size", selection: $coffeeSize) {
                    ForEach(CoffeeSize.allCases, id: \.rawValue) { size in
                        Text(size.rawValue)
                            .tag(size) // <--  size will be set to $coffeeSize
                    }//: LOOP
                }//: PICKER
                .pickerStyle(.segmented)
                
                Button(order != nil ? "Update Order" : "Place Order") {
                    
                    if isValid {
                        // place the order
                        Task {
                            await saveOrUpdate()
                        }
                    }
                    
                }//: BUTTON
                .accessibilityIdentifier("placeOrderButton")
                .centerHorizontally()
                
            }//: FORM
            .navigationTitle(order != nil ? "Update Order" : "Add Order")
            .onAppear(){
                populateExistingOrder()
            }
            
        }//: NAVIGATION
        
        
    }
}

// MARK: - PREVIEW
struct AddCoffeeView_Previews: PreviewProvider {
    static var previews: some View {
        AddCoffeeView()
    }
}
