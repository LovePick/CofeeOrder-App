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
    
    
    private func placeOrder() async {
        let order = Order(name: name, coffeeName: coffeeName, total: Double(price) ?? 0, size: coffeeSize)
        
        do {
            try await model.placeOrder(order)
            
            //dismiss
            dismiss()
        } catch {
            print(error)
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
                
                Button("Place Order") {
                    
                    if isValid {
                        // place the order
                        Task {
                            await placeOrder()
                        }
                    }
                    
                }//: BUTTON
                .accessibilityIdentifier("placeOrderButton")
                .centerHorizontally()
                
            }//: FORM
            .navigationTitle("Add Coffee")
            
        }//: NAVIGATION
        
        
    }
}

// MARK: - PREVIEW
struct AddCoffeeView_Previews: PreviewProvider {
    static var previews: some View {
        AddCoffeeView()
    }
}
