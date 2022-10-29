//
//  Webservice.swift
//  HelloCoffee
//
//  Created by Supapon Pucknavin on 26/10/2565 BE.
//

import Foundation

enum NetworkError: Error {
    case badRequest
    case decodingError
    case badUrl
}

class Webservice {
    
    private var baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func updateOrder(_ order: Order) async throws -> Order {
//        guard let orderId = order.id else {
//            throw NetworkError.badRequest
//        }
        
        guard let url = URL(string: Endpoints.updateOrder(order.id).path, relativeTo: baseURL) else {
            throw NetworkError.badUrl
        }
        print(url.absoluteString)
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(order)
        
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.badRequest
        }
        
        guard let updateOrder = try? JSONDecoder().decode(Order.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return updateOrder
    }
    
    func deleteOrder(orderId: String) async throws -> Order {
        guard let url = URL(string: Endpoints.deleteOrder(orderId).path, relativeTo: baseURL) else {
            throw NetworkError.badUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.badRequest
        }
        
        guard let deletedOrder = try? JSONDecoder().decode(Order.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return deletedOrder
    }
    
    func placeOrder(order: Order) async throws -> Order {
        //http://localhost:3334/new-order
        guard let url = URL(string: Endpoints.placeOrder.path, relativeTo: baseURL) else {
            throw NetworkError.badUrl
        }
        print(url.absoluteString)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(order)
        
        
        let (data, response) = try await URLSession.shared.data(for: request)
        let str = String(data: data, encoding: .utf8)
        print(str ?? "Data not String")
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.badRequest
        }
        
        guard let newOrder = try? JSONDecoder().decode(Order.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return newOrder
        
    }
    
    func getOrders() async throws -> [Order] {
        
        //http://localhost:3334/orders
        guard let url = URL(string: Endpoints.allOrders.path, relativeTo: baseURL) else {
            throw NetworkError.badUrl
        }
        print(url.absoluteString)
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.badRequest
        }
        
        guard let ordersObj = try? JSONDecoder().decode([String:Order].self, from: data) else {
            throw NetworkError.decodingError
        }
        
        var orders = [Order]()
        for (_, value) in ordersObj {
            orders.append(value)
        }
        
        return orders
    }
}
