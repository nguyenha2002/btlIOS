

import UIKit
import FirebaseFirestore



class HomeVC: BaseView {
    let db = Firestore.firestore()
    var arr = [Product]()
    var arr2 = [Product]()
    var arr3 = [Product]()
    
    @IBOutlet weak var collectionThird: UICollectionView!
    @IBOutlet weak var collectionTwo: UICollectionView!
    @IBOutlet weak var collectionOne: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupCollectionOne()
        bindData1()
        
        setupCollectionTwo()
        bindData2()
        
        setupCollectionThird()
        bindData3()
        
        searchBar.backgroundImage = UIImage()
    }
    
    func setupCollectionOne(){
        collectionOne.delegate = self
        collectionOne.dataSource = self
        
        let nib = UINib(nibName: "ItemCellOne", bundle: nil)
        collectionOne.register(nib, forCellWithReuseIdentifier: "itemCellOne")
    }
    func bindData1(){
        db.collection("Products").whereField("category", isEqualTo: "Điện thoại di động").addSnapshotListener { snapshot, error in
            if let error = error{
                self.showAlert(title: "", mess: error.localizedDescription)
            }
            guard let documents = snapshot?.documents else {
                self.showAlert(title: "", mess: "Khong co du lieu trong collection 1")
                return
            }
            self.arr = documents.compactMap{ document in
                guard let name = document.get("name") as? String,
                      let imageURL = document.get("imageURL") as? [String],
                      let id = document.documentID as? String,
                      let price = document.get("price") as? Double,
                      let size = document.get("size") as? [String],
                      let description = document.get("description") as? String,
                      let stock = document.get("stock") as? Int,
                      let category = document.get("category") as? String
                else
                {
                    return nil
                }
                return Product(id: id, name: name, description: description, category: category, price: price, stock: stock, imageURL: imageURL, size: size)
            }
            self.collectionOne.reloadData()
        }
    }
    
    func setupCollectionTwo(){
        collectionTwo.delegate = self
        collectionTwo.dataSource = self
        
        let nibTwo = UINib(nibName: "ItemCellTwo", bundle: nil)
        collectionTwo.register(nibTwo, forCellWithReuseIdentifier: "itemCellTwo")
    }
    func bindData2(){
        db.collection("Products").whereField("category", isEqualTo: "Giày thể thao").addSnapshotListener { snapshot, error in
            if let error = error{
                self.showAlert(title: "", mess: error.localizedDescription)
            }
            guard let documents = snapshot?.documents else {
                return
            }
            self.arr2 = documents.compactMap{ document in
                guard let name = document.get("name") as? String,
                      let imageURL = document.get("imageURL") as? [String],
                      let id = document.documentID as? String,
                      let price = document.get("price") as? Double,
                      let size = document.get("size") as? [String],
                      let description = document.get("description") as? String,
                      let stock = document.get("stock") as? Int,
                      let category = document.get("category") as? String
                else
                {
                    return nil
                }
                return Product(id: id, name: name, description: description, category: category, price: price, stock: stock, imageURL: imageURL, size: size)
            }
            self.collectionTwo.reloadData()
        }

    }
    
    func setupCollectionThird(){
        collectionThird.delegate = self
        collectionThird.dataSource = self
        
        let nibThird = UINib(nibName: "ItemCellThird", bundle: nil)
        collectionThird.register(nibThird, forCellWithReuseIdentifier: "itemCellThird")
    }
    func bindData3(){
        db.collection("Products").addSnapshotListener { snapshot, error in
            if let error = error {
                self.showAlert(title: "", mess: error.localizedDescription)
            }
            guard let documents = snapshot?.documents else {
                return
            }
            self.arr3 = documents.compactMap{ document in
                guard let name = document.get("name") as? String,
                      let imageURL = document.get("imageURL") as? [String],
                      let id = document.documentID as? String,
                      let price = document.get("price") as? Double,
                      let size = document.get("size") as? [String],
                      let description = document.get("description") as? String,
                      let stock = document.get("stock") as? Int,
                      let category = document.get("category") as? String
                else
                {
                    return nil
                }
                return Product(id: id, name: name, description: description, category: category, price: price, stock: stock, imageURL: imageURL, size: size)
            }
            self.collectionThird.reloadData()
        }

    }
    
}
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionOne{
            return arr.count
        }else if collectionView == collectionTwo{
            return arr2.count
        }else{
            return arr3.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionOne{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCellOne", for: indexPath) as! ItemCellOne
            let data = arr[indexPath.row]

            if let imageURL = URL(string: data.imageURL.first!)
            {
                URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                    if let error = error {
                        print("Error loading image: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let data = data, let image = UIImage(data: data) else {
                        print("Invalid image data")
                        return
                    }
                    DispatchQueue.main.async {
                        cell.imageCell.image = image
                    }
                }.resume() // Start the data task
            }
            cell.lbName.text = data.name
            cell.lbMoTa.text = data.description
            return cell
        }else if collectionView == collectionTwo{
            let cell = collectionTwo.dequeueReusableCell(withReuseIdentifier: "itemCellTwo", for: indexPath) as! ItemCellTwo
            let data = arr2[indexPath.row]
            if let imageURL = URL(string: data.imageURL.first!){
                URLSession.shared.dataTask(with: imageURL) { data, response, error in
                    if let error = error {
                        self.showAlert(title: "", mess: error.localizedDescription)
                        return
                    }
                    guard let data = data, let image = UIImage(data: data) else {
                        return
                    }
                    DispatchQueue.main.async {
                        cell.img.image = image
                    }
                }.resume()
            }
            cell.lbName.text = data.name
            return cell
        }else{
            let cell = collectionThird.dequeueReusableCell(withReuseIdentifier: "itemCellThird", for: indexPath) as! ItemCellThird
            let data = arr3[indexPath.row]
            if let imageURL = URL(string: data.imageURL.first!){
                URLSession.shared.dataTask(with: imageURL) { data, response, error in
                    if let error = error {
                        self.showAlert(title: "", mess: error.localizedDescription)
                        return
                    }
                    guard let data = data, let image = UIImage(data: data) else {
                        return
                    }
                    DispatchQueue.main.async {
                        cell.img.image = image
                    }
                }.resume()
            }
            cell.lbName.text = data.name
            cell.lbPrice.text = "\(data.price) VNĐ"
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionOne{
            return CGSize(width: view.frame.width - 20, height: 200)
        }else if collectionView == collectionTwo{
            return CGSize(width: 110, height: 120)
        }else{
            return CGSize(width: (view.frame.width - 30)/2, height: (view.frame.width - 30)/2)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var selectedProduct: Product?
        if collectionView == collectionOne {
            selectedProduct = arr[indexPath.row]
        }else if collectionView == collectionTwo{
            selectedProduct = arr2[indexPath.row]
        }else{
            selectedProduct = arr3[indexPath.row]
        }
        if let selectedProduct = selectedProduct {
            moveToDetail(product: selectedProduct)
        }
    }
    
}

