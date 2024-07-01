
import Foundation

class Order{
    var imageURL: String
    var name: String
    var price: Double
    var quantity: Int
    var size: String
    
    init(imageURL: String, name: String, price: Double, quantity: Int, size: String) {
        self.imageURL = imageURL
        self.name = name
        self.price = price
        self.quantity = quantity
        self.size = size
    }
}
class Orders {
    var address: String
    var products: [Order]
    var total: Double
    var userID: String
    
    init(address: String, products: [Order], total: Double, userID: String) {
        self.address = address
        self.products = products
        self.total = total
        self.userID = userID
    }
}
