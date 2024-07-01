

import UIKit
import FirebaseAuth
import FirebaseFirestore

class OrderPlaced: BaseView {

    @IBOutlet weak var tablePlaced: UITableView!
    
    
    var footerTable: [(total: Double, address: String)] = []
    var arr = [Orders]()
    var db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTable()

    }
    func setupTable(){
        tablePlaced.delegate = self
        tablePlaced.dataSource = self

        let nib = UINib(nibName: "OrderCell", bundle: nil)
        tablePlaced.register(nib, forCellReuseIdentifier: "orderCell")
        fetchOrders()
    }
    
    func fetchOrders(){
        if let currentID = Auth.auth().currentUser?.uid{
            db.collection("Orders").whereField("userID", isEqualTo: currentID).getDocuments { snapshot, error in
                if let error = error{
                    self.showAlert(title: "", mess: error.localizedDescription)
                    return
                }
                else{
                    self.arr.removeAll()
                    self.footerTable.removeAll()
                    for document in snapshot!.documents{
                        let data = document.data()
                        let total = data["total"] as? Double ?? 0.0
                        let address = data["address"] as? String ?? ""
                        var product = data["products"] as? [[String: Any]] ?? []
                        
                        var products = [Order]()
                        for productData in product {
                            let imageURL = productData["imageURL"] as? String ?? ""
                            let name = productData["name"] as? String ?? ""
                            let size = productData["size"] as? String ?? ""
                            let price = productData["price"] as? Double ?? 0.0
                            let quantity = productData["quantity"] as? Int ?? 0
                            
                            let order = Order(imageURL: imageURL, name: name, price: price, quantity: quantity, size: size)
                            products.append(order)
                        }
                        let orders = Orders(address: address, products: products, total: total, userID: currentID)
                        self.arr.append(orders)
                        self.footerTable.append((total, address))
                    }
                    self.tablePlaced.reloadData()
                }
            }
        }
    }

}

extension OrderPlaced: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return arr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablePlaced.dequeueReusableCell(withIdentifier: "orderCell") as? OrderCell
        cell?.collectionOrder.delegate = self
        cell?.collectionOrder.dataSource = self
        
        let nib = UINib(nibName: "OrderCollectionCell", bundle: nil)
        cell?.collectionOrder.register(nib, forCellWithReuseIdentifier: "orderCollectionCell")
        
        cell?.collectionOrder.tag = indexPath.section
        cell?.collectionOrder.reloadData()
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let width = tableView.frame.width
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 100))
        footerView.backgroundColor = .lightGray
        
        let totalLabel = UILabel(frame: CGRect(x: 10, y: 5, width: width - 20, height: 40))
        totalLabel.textAlignment = .right
        totalLabel.text = "Total: \(footerTable[section].total) VND"
        footerView.addSubview(totalLabel)
        
        let addressLabel = UILabel(frame: CGRect(x: 10, y: 40, width: width - 20, height: 40))
        addressLabel.textAlignment = .right
        addressLabel.text = "Address: \(footerTable[section].address)"
        footerView.addSubview(addressLabel)
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 85
    }
}

extension OrderPlaced: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr[collectionView.tag].products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "orderCollectionCell", for: indexPath) as? OrderCollectionCell
        let product = arr[collectionView.tag].products[indexPath.row]
        if let imageURL = URL(string: product.imageURL){
            URLSession.shared.dataTask(with: imageURL) { data, response, error in
                if let error = error {
                    self.showAlert(title: "", mess: error.localizedDescription)
                    return
                }
                guard let data = data, let image = UIImage(data: data) else{
                    return
                }
                DispatchQueue.main.async {
                    cell?.imageURL.image = image
                }
            }.resume()
        }
        cell?.lbName.text = product.name
        cell?.lbSize.text = "Quantity: \(product.quantity)"
        cell?.lbPrice.text = "Price: \(product.price) VND"
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 150)
    }
}
