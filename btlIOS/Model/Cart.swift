

import Foundation

class Cart {
    var userID: String
    var name: String
    var price: Double
    var quantity: Int
    var size: String
    var imageURL: String
    var stock: Int
    
    init(userID: String, name: String, price: Double, quantity: Int, size: String, imageURL: String, stock: Int) {
        self.userID = userID
        self.name = name
        self.price = price
        self.quantity = quantity
        self.size = size
        self.imageURL = imageURL
        self.stock = stock
    }
}
