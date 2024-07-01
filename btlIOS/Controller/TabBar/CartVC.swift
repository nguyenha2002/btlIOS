

import UIKit
import FirebaseFirestore
import FirebaseAuth

protocol PlacedOrder {
    func delegatePlace(item: [Cart])
}

class CartVC: BaseView {
    
    var arr = [Cart]()
    let db = Firestore.firestore()
    var orderDelegate: PlacedOrder?
    //var discountedPrice: Double = 0.0
    var total = 0.0
    
    @IBOutlet weak var lbTotalPrice: UILabel!
    @IBOutlet weak var lbMaGg: UITextField!
    @IBOutlet weak var tableCart: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpTable()
        bindData()
        
    }
    func setUpTable(){
        tableCart.delegate = self
        tableCart.dataSource = self
        
        let nib = UINib(nibName: "CartTableCell", bundle: nil)
        tableCart.register(nib, forCellReuseIdentifier: "cartTableCell")
    }
    func bindData(){
        if let userID = Auth.auth().currentUser?.uid{
            db.collection("Carts").whereField("userID", isEqualTo: userID).addSnapshotListener { snapshot, error in
                if let error = error {
                    self.showAlert(title: "", mess: error.localizedDescription)
                }
                guard let documents = snapshot?.documents else {
                    self.arr = []
                    self.tableCart.reloadData()
                    return
                }
                self.arr = documents.compactMap{ document in
                    guard let name = document.get("name") as? String,
                          let imageURL = document.get("imageURL") as? String,
                          let price = document.get("price") as? Double,
                          let size = document.get("size") as? String,
                          let quantity = document.get("quantity") as? Int,
                          let stock = document.get("stock") as? Int
                    else {
                        return nil
                    }
                    return Cart(userID: userID, name: name, price: price, quantity: quantity, size: size, imageURL: imageURL, stock: stock)
                    
                }
                self.tableCart.reloadData()
                self.totalPrice()
            }
            
        }
        
    }
    func totalPrice(){
        let totalPrice = arr.reduce(0) { $0 + ($1.price)*Double($1.quantity)}
        lbTotalPrice.text = "\(totalPrice)VNĐ"
        total = totalPrice
    }
    @IBAction func btnPlace(_ sender: Any) {
        let address = AddressScreen(nibName: "AddressScreen", bundle: nil)
        address.orderPlace = arr
        address.totalPrice = total
        navigationController?.pushViewController(address, animated: true)
        
    }
    
    @IBAction func btnApply(_ sender: Any) {
        view.endEditing(true)
        let discountCode = lbMaGg.text
        db.collection("Discount").whereField("code", isEqualTo: discountCode).getDocuments { [self] snapshot, error in
            if let error = error {
                self.showAlert(title: "", mess: error.localizedDescription)
            }
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                self.showAlert(title: "", mess: "Ma giam gia khong hop le")
                return
            }
            if let document = documents.first, let valid = document["validUntil"] as? Timestamp,
               let discountAmount = document["discountAmount"] as? Double?
            {
                let totalPrice = arr.reduce(0) { $0 + ($1.price)*Double($1.quantity)}
                let discount = totalPrice * discountAmount!
                let currentDay = Date()
                if currentDay <= valid.dateValue(){
                let discountedPrice = totalPrice - (Double(discount))
                    total = discountedPrice
                    self.lbTotalPrice.text = "\(discountedPrice)VNĐ"
                }else{
                    self.showAlert(title: "", mess: "Ma giam gia nay da het han!")
                    self.lbTotalPrice.text = "\(totalPrice)VNĐ"
                }
            }
        }
    }
}
extension CartVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableCart.dequeueReusableCell(withIdentifier: "cartTableCell") as! CartTableCell
        let data = arr[indexPath.row]
        if let imageURL = URL(string: data.imageURL){
            URLSession.shared.dataTask(with: imageURL) { data, response, error in
                if let error = error{
                    self.showAlert(title: "", mess: error.localizedDescription)
                    return
                }
                guard let data = data , let image = UIImage(data: data) else {
                    return
                }
                DispatchQueue.main.async {
                    cell.img.image = image
                }
            }.resume()
        }
        cell.lbMota.text = data.name
        cell.lbPrice.text = "\(data.price)"
        cell.lbSize.text = data.size
        cell.lbSL.text = "\(data.quantity)"
        cell.stepperSL.maximumValue = Double(data.stock)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, success) in
            guard let self = self else { return }
                let cartItem = self.arr[indexPath.row]
                if let currentUser = Auth.auth().currentUser?.uid {
                    self.db.collection("Carts")
                        .whereField("userID", isEqualTo: currentUser)
                        .whereField("name", isEqualTo: cartItem.name)
                        .getDocuments { snapshot, error in
                            if let error = error {
                                self.showAlert(title: "", mess: error.localizedDescription)
                                success(false)
                                return
                            }
                            
                            guard let document = snapshot?.documents.first else {
                                self.showAlert(title: "", mess: "Không có dữ liệu")
                                success(false)
                                return
                            }
                            
                            document.reference.delete { error in
                                if let error = error {
                                    self.showAlert(title: "", mess: error.localizedDescription)
                                    success(false)
                                } else {
                                    DispatchQueue.main.async {
                                        if indexPath.row < self.arr.count {
                                            self.arr.remove(at: indexPath.row)
                                            
                                        }
                                    }
                                    self.totalPrice()
                                    success(true)
                                }
                            }
                        }
                }
            }
        //deleteAction.backgroundColor = .red
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            success(true)
        }
        editAction.backgroundColor = .blue
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}
