

import UIKit
import FirebaseFirestore


class ShopVC: BaseView {
    let db = Firestore.firestore()
    var arr = [Category]()
    
    var filteredArr = [Category]()
    var isSearching  = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableShop: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTable()
        bindData()
        setupSearchBar()
    }
    func setupTable(){
        tableShop.delegate = self
        tableShop.dataSource = self
        
        let nib = UINib(nibName: "ShopCellTable", bundle: nil)
        tableShop.register(nib, forCellReuseIdentifier: "shopCellTable")
    }
    func bindData(){
        db.collection("Category").addSnapshotListener { [self] snapshot, error in
            if let error = error {
                self.showAlert(title: "", mess: error.localizedDescription)
            }
            guard let documents = snapshot?.documents else{
                 return
            }
            self.arr = documents.compactMap{ document in
                guard let name = document.get("name") as? String,
                      let image = document.get("image") as? String,
                      let id = document.documentID as? String
                else{
                    return nil
                }
                return Category(id: id, name: name, image: image)
            }
            self.filteredArr = self.arr
            self.tableShop.reloadData()
        }
    }
    
    func setupSearchBar(){
        searchBar.delegate = self
        searchBar.backgroundImage =  UIImage()
    }
}
extension ShopVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching == false{
            return arr.count
        }else{
            return filteredArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableShop.dequeueReusableCell(withIdentifier: "shopCellTable") as! ShopCellTable
        let data = isSearching ?  filteredArr[indexPath.row] : arr[indexPath.row]
        if let image = URL(string: data.image){
            URLSession.shared.dataTask(with: image) { data, response, error in
                if let error = error {
                    self.showAlert(title: "", mess: error.localizedDescription)
                    return
                }
                guard let data = data, let imageURL = UIImage(data: data) else {
                    return
                }
                DispatchQueue.main.async {
                    cell.img.image = imageURL
                }
            }.resume()
        }
        cell.lbLoai.text = data.name
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 215
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ListProduct(nibName: "ListProduct", bundle: nil)
        vc.selectedCategory = arr[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ShopVC: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredArr = arr
            isSearching = false
        }else{
            filteredArr = arr.filter{ $0.name.lowercased().contains(searchText.lowercased()) }
            isSearching = true
        }
        tableShop.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filteredArr = arr
        isSearching = false
        tableShop.reloadData()
    }
}
