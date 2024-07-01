
import UIKit
import FirebaseFirestore

class ListProduct: BaseView {
    var selectedCategory: Category?
    let db = Firestore.firestore()
    var arrList = [Product]()
    var isSearching = false
    var filteredArr = [Product]()
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionListProduct: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        if let category = selectedCategory?.name{
            bindData(category: category)
        }
        // Do any additional setup after loading the view.
        setupCollectionListProduct()
        setupSearch()
        searchBar.backgroundImage = UIImage()
    }
    func setupSearch(){
        searchBar.delegate = self
    }

    func setupCollectionListProduct(){
        collectionListProduct.delegate = self
        collectionListProduct.dataSource = self
        
        let nib = UINib(nibName: "ItemCellThird", bundle: nil)
        collectionListProduct.register(nib, forCellWithReuseIdentifier: "itemCellThird")
    }
    func bindData(category: String){
        db.collection("Products").whereField("category", isEqualTo: category).addSnapshotListener { snapshot, error in
            if let error = error {
                self.showAlert(title: "", mess: error.localizedDescription)
                return
            }
            guard let documents = snapshot?.documents else {
                return
            }
            self.arrList = documents.compactMap{ document in
                guard let name = document.get("name") as? String,
                      let price = document.get("price") as? Double,
                      let imageURL = document.get("imageURL") as? [String],
                      let id = document.documentID as? String,
                      let description = document.get("description") as? String,
                      let stock = document.get("stock") as? Int,
                      let size = document.get("size") as? [String],
                      let category = document.get("category") as? String
                else {
                    return nil
                }
                return Product(id: id, name: name, description: description, category: category, price: price, stock: stock, imageURL: imageURL, size: size)
            }
            self.collectionListProduct.reloadData()
        }
    }
}
extension ListProduct: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearching == false{
            return arrList.count
        }else{
            return filteredArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionListProduct.dequeueReusableCell(withReuseIdentifier: "itemCellThird", for: indexPath) as! ItemCellThird
        let data = isSearching ? filteredArr[indexPath.row] : arrList[indexPath.row]
        if let imageURL = URL(string: data.imageURL.first!) {
            URLSession.shared.dataTask(with: imageURL) { data, response, error in
                if let error = error {
                    self.showAlert(title: "", mess: error.localizedDescription)
                    return
                }
                guard let data = data , let image = UIImage(data: data) else{
                    return
                }
                DispatchQueue.main.async {
                    cell.img.image = image
                }
            }.resume()
        }
        cell.lbName.text = data.name
        cell.lbPrice.text = "\(data.price) VND"
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = (view.frame.width - 30)/2
        return CGSize(width: w, height: w)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var selectedProduct: Product?
        selectedProduct = arrList[indexPath.row]
        if let selectedProduct = selectedProduct{
            moveToDetail(product: selectedProduct)
        }
    }

}

extension ListProduct: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            filteredArr = arrList
            isSearching = false
        }else{
            filteredArr = arrList.filter{ $0.name.lowercased().contains(searchText.lowercased()) }
            isSearching = true
        }
        collectionListProduct.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filteredArr = arrList
        isSearching = false
        collectionListProduct.reloadData()
    }
    
}
