
import Foundation

class Product {
    var id: String
    var name: String
    var description: String
    var category: String
    var price: Double
    var stock: Int
    var imageURL: [String]
    var size: [String]
    
    
    init(id: String, name: String, description: String, category: String, price: Double, stock: Int, imageURL: [String], size: [String]) {
        self.id = id
        self.name = name
        self.description = description
        self.category = category
        self.price = price
        self.stock = stock
        self.imageURL = imageURL
        self.size = size
    }
   
}
