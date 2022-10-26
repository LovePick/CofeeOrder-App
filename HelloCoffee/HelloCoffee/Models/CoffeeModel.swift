//
//  CoffeeModel.swift
//  HelloCoffee
//
//  Created by Supapon Pucknavin on 26/10/2565 BE.
//

import Foundation
import SwiftUI

@MainActor
class CoffeeModel: ObservableObject {
    
    let webservice: Webservice
    @Published private(set) var orders:[Order] = []
    
    init(webservice: Webservice) {
        self.webservice = webservice
    }
    
    func populateOrders() async throws {
        orders = try await webservice.getOrders()
    }
    
    func placeOrder(_ order:Order) async throws {
        let newOrders = try await webservice.placeOrder(order: order)
        orders.append(newOrders)
    }
    
}
