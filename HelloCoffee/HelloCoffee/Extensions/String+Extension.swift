//
//  String+Extension.swift
//  HelloCoffee
//
//  Created by Supapon Pucknavin on 26/10/2565 BE.
//

import Foundation

extension String {
    var isNumeric: Bool {
        Double(self) != nil
    }
    
    var isNotEmpty: Bool {
        !self.isEmpty
    }
    
    func isLessThan(_ number: Double) -> Bool {
        if !self.isNumeric {
            return false
        }
        
        guard let value = Double(self) else { return false }
        return value < number
    }
}
