

import UIKit
import FirebaseFirestore
import FirebaseAuth
class DetailScreen: BaseView {
    
    let db = Firestore.firestore()

    var selectedProduct: Product?
    @IBOutlet weak var segmentSize: UISegmentedControl!
    @IBOutlet weak var lbSoLuong: UILabel!
    @IBOutlet weak var stepperSL: UIStepper!
    @IBOutlet weak var btnAddToCart: UIButton!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var imgCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnAddToCart.roundCorners(radius: 15)
        setupStepper()
        setupView()
        setupCollection()
    }
    func setupView(){
        lbPrice.text = "\(selectedProduct!.price)"+"VNĐ"
        segmentSize.removeAllSegments()
        if let sizes = selectedProduct?.size{
            if sizes.count == 0{
                segmentSize.isHidden = true
            }else{
                for(index, size) in sizes.enumerated() {
                    segmentSize.insertSegment(withTitle: size, at: index, animated: false)
                }
                segmentSize.selectedSegmentIndex = 0
                segmentSize.isEnabled = true
            }
        }
        lbName.text = selectedProduct?.name
    }

    func setupCollection(){
        imgCollection.delegate = self
        imgCollection.dataSource = self
        
        let nib = UINib(nibName: "imageCell", bundle: nil)
        imgCollection.register(nib, forCellWithReuseIdentifier: "imageCell")
    }
    func setupStepper(){
        stepperSL.maximumValue = Double(selectedProduct!.stock)
        stepperSL.addTarget(self, action: #selector(changeView), for: .valueChanged)
    }
    
    @objc func changeView(){
        lbSoLuong.text = "\(Int(stepperSL.value))"
    }

    @IBAction func btnReviews(_ sender: Any) {
       
    }
    @IBAction func btnAddToCart(_ sender: Any) {

        if segmentSize.isHidden == false{
            if let name = selectedProduct?.name,
               let price = selectedProduct?.price,
               let stock = selectedProduct?.stock,
               let imageURL = selectedProduct?.imageURL.first,
               let size = segmentSize.titleForSegment(at: segmentSize.selectedSegmentIndex),
               let userID = Auth.auth().currentUser?.uid {
                let cartItem: [String: Any] =
                [
                    "name": name,
                    "price": price,
                    "quantity": Int(stepperSL.value),
                    "size": size,
                    "imageURL": imageURL,
                    "userID": userID,
                    "stock": stock
                ]
                db.collection("Carts").addDocument(data: cartItem) { error in
                    if let error = error{
                        self.showAlert(title: "", mess: error.localizedDescription)
                    }else{
                        self.showAlert(title: "", mess: "Ban da them vao gio hang thanh cong!")
                    }
                }
            }
        }else{
            if let name = selectedProduct?.name,
               let price = selectedProduct?.price,
               let stock = selectedProduct?.stock,
               let imageURL = selectedProduct?.imageURL.first,
               let userID = Auth.auth().currentUser?.uid {
                let cartItem: [String: Any] =
                [
                    "name": name,
                    "price": price,
                    "quantity": Int(stepperSL.value),
                    "size": "",
                    "imageURL": imageURL,
                    "userID": userID,
                    "stock": stock
                ]
                db.collection("Carts").addDocument(data: cartItem) { error in
                    if let error = error{
                        self.showAlert(title: "", mess: error.localizedDescription)
                    }else{
                        self.showAlert(title: "", mess: "Ban da them vao gio hang thanh cong!")
                    }
                }
            }
        }
//        let sb = UIStoryboard(name: "Main", bundle: nil)
//        let vc = sb.instantiateViewController(withIdentifier: "cart")
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension DetailScreen: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedProduct!.imageURL.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imgCollection.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? imageCell
        let data = selectedProduct?.imageURL[indexPath.row]
        if let imageURLString = data, let imageURL = URL(string: imageURLString){
            URLSession.shared.dataTask(with: imageURL) { data, response, error in
                if let error = error {
                    self.showAlert(title: "", mess: error.localizedDescription)
                    return
                }
                guard let data = data, let image = UIImage(data: data) else {
                    return
                }
                DispatchQueue.main.async {
                    cell!.imageCell.image = image
                }
            }.resume()
        }
        return cell!
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: imgCollection.frame.width, height: 210)
    }
}
