//: Playground - noun: a place where people can play

import UIKit

let name = { (firstName: String, lastName: String) -> String in
     firstName + " " + lastName
}

let n = name("Nguyen", "Nam")


// ket hop autoclosure and escaping

var customersInLine =  ["Barry", "Daniella"]
var customerProviders: [() -> String] = []
func collectCustomerProviders(_ customerProvider: @autoclosure @escaping () -> String) {
    customerProviders.append(customerProvider)
}
collectCustomerProviders(customersInLine.remove(at: 0))
collectCustomerProviders(customersInLine.remove(at: 0))

print("\(customersInLine.count)")
print("Collected \(customerProviders.count) closures.")

// Prints "Collected 2 closures."
for customerProvider in customerProviders {
    print("Now serving \(customerProvider())!")
}

print("\(customersInLine.count)")










