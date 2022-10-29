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
    
    func orderById(_ orderId: String) -> Order? {
        guard let index = orders.firstIndex(where: { $0.id == orderId }) else {
            return nil
        }
        
        return orders[index]
        
    }
    

    
    func populateOrders() async throws {
        orders = try await webservice.getOrders()
    }
    
    func placeOrder(_ order:Order) async throws {
        let newOrders = try await webservice.placeOrder(order: order)
        orders.append(newOrders)
    }
    
    func deleteOrder(_ orderId: String) async throws {
        let deletedOrder = try await webservice.deleteOrder(orderId: orderId)
        orders = orders.filter{ $0.id != deletedOrder.id }
    }
    
    func updateOrder(_ order:Order) async throws {
        let updateOrder = try await webservice.updateOrder(order)
        guard let index = orders.firstIndex(where: { $0.id == updateOrder.id }) else {
            throw CoffeeOrderError.invalidOrderId
        }
        
        orders[index] = updateOrder
    }
    
}
