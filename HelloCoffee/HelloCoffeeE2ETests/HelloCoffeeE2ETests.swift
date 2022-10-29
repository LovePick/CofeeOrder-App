//
//  HelloCoffeeE2ETests.swift
//  HelloCoffeeE2ETests
//
//  Created by Supapon Pucknavin on 26/10/2565 BE.
//

import XCTest


final class when_updating_an_existing_order: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUp() {
        app = XCUIApplication()
        continueAfterFailure = false
        app.launchEnvironment = ["ENV": "TEST"]
        app.launch()
        
        
        // go to the add order screen
        app.buttons["addNewOrderButton"].tap()
        
        // write into textfields
        let nameTextField = app.textFields["name"]
        let coffeeNameTextField = app.textFields["coffeeName"]
        let priceTextField = app.textFields["price"]
        let placeOrderButton = app.buttons["placeOrderButton"]
        
        nameTextField.tap()
        nameTextField.typeText("John")
        
        coffeeNameTextField.tap()
        coffeeNameTextField.typeText("Macchiato")
        
        priceTextField.tap()
        priceTextField.typeText("4.50")
        
        // place the order
        placeOrderButton.tap()
        
        
        
    }
    
    func test_should_update_order_successfully() {
        
        // go to the order screen
        let orderList = app.collectionViews["orderList"]
        orderList.buttons["orderNameText-coffeeNameAndSizeText-coffeePriceText"].tap()
        
        app.buttons["editOrderButton"].tap()
        
        let nameTextField = app.textFields["name"]
        let coffeeNameTextField = app.textFields["coffeeName"]
        let priceTextField = app.textFields["price"]
        let placeOrderButton = app.buttons["placeOrderButton"]
        
        let _ = nameTextField.waitForExistence(timeout: 2.0)
        nameTextField.tap(withNumberOfTaps: 2, numberOfTouches: 1)
        nameTextField.typeText("John Edit")
        
        let _ = coffeeNameTextField.waitForExistence(timeout: 2.0)
        coffeeNameTextField.tap(withNumberOfTaps: 2, numberOfTouches: 1)
        coffeeNameTextField.typeText("Hot Coffee Edit")
        
        let _ = priceTextField.waitForExistence(timeout: 2.0)
        priceTextField.tap(withNumberOfTaps: 2, numberOfTouches: 1)
        priceTextField.typeText("1.50")
        
        placeOrderButton.tap()
        
        XCTAssertEqual("Hot Coffee Edit", app.staticTexts["coffeeNameText"].label)
        
    }
    
    // call after running each test
    override func tearDown() {
        Task {
            guard let url = URL(string: "/clear-orders", relativeTo: URL(string: "http://localhost:3334")! ) else { return }
            let (_,_) = try! await URLSession.shared.data(from: url)
        }
    }
}


/*
 // Swipe gestures not working on iOS simulator
 // Wait Apple update
final class when_deleteing_an_order: XCTestCase {
    private var app: XCUIApplication!
    
    override func setUp() {
        app = XCUIApplication()
        continueAfterFailure = false
        app.launchEnvironment = ["ENV": "TEST"]
        app.launch()
        
        
        // go to the add order screen
        app.buttons["addNewOrderButton"].tap()
        
        // write into textfields
        let nameTextField = app.textFields["name"]
        let coffeeNameTextField = app.textFields["coffeeName"]
        let priceTextField = app.textFields["price"]
        let placeOrderButton = app.buttons["placeOrderButton"]
        
        nameTextField.tap()
        nameTextField.typeText("John")
        
        coffeeNameTextField.tap()
        coffeeNameTextField.typeText("Macchiato")
        
        priceTextField.tap()
        priceTextField.typeText("4.50")
        
        // place the order
        placeOrderButton.tap()
        
        
        
    }
    
    func test_should_delete_order_successfully() {
        let collectionViewsQuery = XCUIApplication().collectionViews
        let cellsQuery = collectionViewsQuery.cells
        let element = cellsQuery.children(matching: .other).element(boundBy: 1).children(matching: .other).element
        element.swipeLeft()
//        collectionViewsQuery.buttons["Delete"].tap()
        let deleteOrderButton = app.buttons["deleteOrder"]
        deleteOrderButton.tap()
        
        let orderList = app.collectionViews["orderList"]
        XCTAssertEqual(0, orderList.cells.count)
        
    }
    
    // call after running each test
    override func tearDown() {
        Task {
            guard let url = URL(string: "/clear-orders", relativeTo: URL(string: "http://localhost:3334")! ) else { return }
            let (_,_) = try! await URLSession.shared.data(from: url)
        }
    }
    
}
*/

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
