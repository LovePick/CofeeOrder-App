//
//  HelloCoffeeApp.swift
//  HelloCoffee
//
//  Created by Supapon Pucknavin on 26/10/2565 BE.
//

import SwiftUI

@main
struct HelloCoffeeApp: App {
    // MARK: - PROPERTY
    @StateObject private var model: CoffeeModel
    
    
    // MARK: - FUNCTION
    init() {
        var config = Configuration()
        let webservice = Webservice(baseURL: config.environment.baseURL)
        _model = StateObject(wrappedValue: CoffeeModel(webservice: webservice))
    }
    
    // MARK: - BODY
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(model)
        }
    }
}
