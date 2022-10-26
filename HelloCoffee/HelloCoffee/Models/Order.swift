//
//  Order.swift
//  HelloCoffee
//
//  Created by Supapon Pucknavin on 26/10/2565 BE.
//

import Foundation

enum CoffeeSize: String, Codable, CaseIterable {
    case small = "Small"
    case medium = "Medium"
    case large = "Large"
}

struct Order: Codable, Identifiable, Hashable {
    var id: String = UUID().uuidString
    var name: String
    var coffeeName: String
    var total: Double
    var size: CoffeeSize
}
