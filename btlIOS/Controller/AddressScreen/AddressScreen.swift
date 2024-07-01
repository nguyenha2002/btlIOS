

import UIKit
import FirebaseFirestore
import FirebaseAuth

class AddressScreen: BaseView {
    var orderPlace: [Cart]?
    var totalPrice: Double = 0.0
    var ordersData: [[String: Any]] = []
    
    var db = Firestore.firestore()
    @IBOutlet weak var tfAddress: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupAddress()
    }
    
    func setupAddress(){
        if let currentUser = Auth.auth().currentUser?.uid{
            db.collection("Users").document(currentUser).getDocument { snapshot, error in
                if let error = error{
                    self.showAlert(title: "", mess: error.localizedDescription)
                    return
                }
                if let snapshot = snapshot, snapshot.exists{
                    let userData = snapshot.data()
                    
                    if let address = userData!["address"] as? String {
                        self.tfAddress.text = address
                    }
                }
            }
        }
    }
    
    @IBAction func btnPlace(_ sender: Any) {
        guard let orderPlace = orderPlace else {return}
        for orderPlace in orderPlace {
            let orderData: [String: Any] = [
                "name": orderPlace.name,
                "price": orderPlace.price,
                "quantity": orderPlace.quantity,
                "imageURL": orderPlace.imageURL,
                "size": orderPlace.size,
            ]
            ordersData.append(orderData)
        }
            if let currentUser = Auth.auth().currentUser?.uid{
                db.collection("Orders").addDocument(data: [
                    "products": ordersData,
                    "userID": currentUser,
                    "address": tfAddress.text,
                    "total": totalPrice
                ])
            }
        if let currentID = Auth.auth().currentUser?.uid{
            db.collection("Carts").whereField("userID", isEqualTo: currentID).getDocuments { snapshot, error in
                if let error = error {
                    self.showAlert(title: "", mess: error.localizedDescription)
                    return
                }
                for document in snapshot?.documents ?? []{
                    document.reference.delete { error in
                        if let error = error{
                            self.showAlert(title: "", mess: error.localizedDescription)
                            return
                        }
                        else{
                            self.showAlert(title: "", mess: "Chuc mung ban da dat hang thanh cong")
                        }
                    }
                }
            }
        }
            let orderPlaced = OrderPlaced(nibName: "OrderPlaced", bundle: nil)
            navigationController?.pushViewController(orderPlaced, animated: true)
        }
    }

