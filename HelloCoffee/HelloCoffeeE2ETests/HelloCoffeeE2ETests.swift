//
//  HelloCoffeeE2ETests.swift
//  HelloCoffeeE2ETests
//
//  Created by Supapon Pucknavin on 26/10/2565 BE.
//

import XCTest
final class when_add_a_new_coffee_order: XCTestCase {
    private var app: XCUIApplication!
    
    
    // call before running each test
    override func setUp() {
        app = XCUIApplication()
        continueAfterFailure = false
        app.launchEnvironment = ["ENV": "TEST"]
        app.launch()
        
        // go to place order screen
        app.buttons["addNewOrderButton"].tap()
        
        //fill out the textfields
        let nameTextField = app.textFields["name"]
        let coffeeNameTextField = app.textFields["coffeeName"]
        let priceTextField = app.textFields["price"]
        let placeOrderButton = app.buttons["placeOrderButton"]
        
        nameTextField.tap()
        nameTextField.typeText("John")
        
        coffeeNameTextField.tap()
        coffeeNameTextField.typeText("Macchiato")
        
        priceTextField.tap()
        priceTextField.typeText("7")
        
        // place the order
        placeOrderButton.tap()
    }
    
    func test_should_display_coffee_order_in_list_successfully() throws {
        XCTAssertEqual("John", app.staticTexts["orderNameText"].label)
        XCTAssertEqual("Macchiato (Medium)", app.staticTexts["coffeeNameAndSizeText"].label)
        XCTAssertEqual("$7.00", app.staticTexts["coffeePriceText"].label)
    }
    
    // call after running each test
    override func tearDown() {
        Task {
            guard let url = URL(string: "/clear-orders", relativeTo: URL(string: "http://localhost:3334")! ) else { return }
            let (_,_) = try! await URLSession.shared.data(from: url)
        }
    }
}

final class when_app_launched_with_no_orders: XCTestCase {

    func test_should_make_suare_no_orders_message_is_displayed() {
        let app = XCUIApplication()
        continueAfterFailure = false
        app.launchEnvironment = ["ENV": "TEST"]
        app.launch()
        
        XCTAssertEqual("No orders available!", app.staticTexts["noOrdersText"].label)
    }

  
}
