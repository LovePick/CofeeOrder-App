//
//  AppEnvironment.swift
//  HelloCoffee
//
//  Created by Supapon Pucknavin on 26/10/2565 BE.
//

import Foundation

enum Endpoints {
    case allOrders
    case placeOrder
    
    var path: String {
        switch self{
        case .allOrders:
            return "/orders"
        case .placeOrder:
            return "/new-order"
        }
        
    }
}

struct Configuration {
    lazy var environment: AppEnvironment = {
        // READ VALUE FROM ENIVONMENT VARIABLE
        guard let env = ProcessInfo.processInfo.environment["ENV"] else {
            return AppEnvironment.dev
        }
        
        if env == "TEST" {
            return AppEnvironment.test
        }
        
        return AppEnvironment.dev
    }()
}

enum AppEnvironment: String {
    case dev
    case test
    
    var baseURL: URL {
        switch self {
        case .dev:
            return URL(string: "http://localhost:3334")!
        case .test:
            return URL(string: "http://localhost:3334")!
        }
    }
}
