
import Foundation

class Discount {
    var id: String
    var code: String
    var discountAmount: Double
    var validUntil: Date
    
    init(id: String, code: String, discountAmount: Double, validUntil: Date) {
        self.id = id
        self.code = code
        self.discountAmount = discountAmount
        self.validUntil = validUntil
    }
}
