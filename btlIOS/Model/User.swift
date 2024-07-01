

import Foundation

class User {
    var name: String
    var email: String
    var address: String
    var image: String
    var phone: String
    var gender: String
    
    init(name: String, email: String, address: String, image: String, phone: String, gender: String) {
        self.name = name
        self.email = email
        self.address = address
        self.image = image
        self.phone = phone
        self.gender = gender
    }
}
