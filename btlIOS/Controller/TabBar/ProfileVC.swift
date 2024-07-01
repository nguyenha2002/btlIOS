

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfileVC: BaseView {
    
    var user: User?
    var db = Firestore.firestore()
    @IBOutlet weak var lbNameUser: UILabel!
    @IBOutlet weak var imageUser: UIImageView!
    
    @IBOutlet weak var btnLogout: UIButton!
    var arrListProfile = [ListProfile]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageUser.roundCorners(radius: imageUser.frame.width/2)
        
        // Do any additional setup after loading the view.
        setupTable()
        bindData()
        showInfoUser()
        btnLogout.roundCorners(radius: 10)
    }
    
    func setupTable(){
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "ProfileTableCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "profileTableCell")
    }
    func bindData(){
        let l1 = ListProfile(img: "account",subject: "Account Details")
        let l2 = ListProfile(img: "clock",subject: "Order History")
        let l3 = ListProfile(img: "heart",subject: "Wishlist")
        let l4 = ListProfile(img: "mess",subject: "Chat")
        let l5 = ListProfile(img: "map",subject: "Address")
        let l6 = ListProfile(img: "notification",subject: "Notifications")
        
        arrListProfile.append(l1)
        arrListProfile.append(l2)
        arrListProfile.append(l3)
        arrListProfile.append(l4)
        arrListProfile.append(l5)
        arrListProfile.append(l6)
        
        tableView.reloadData()
    }
    func showInfoUser(){
        if let userID = Auth.auth().currentUser?.uid{
            db.collection("Users").document(userID).addSnapshotListener { snapshot, error in
                if let error = error {
                    self.showAlert(title: "", mess: error.localizedDescription)
                    return
                }
                guard let snapshot = snapshot, snapshot.exists else {
                    return
                }
                let userData = snapshot.data()
                if let username = userData?["name"] as? String,
                   let image = userData?["image"] as? String,
                   let phone = userData?["phone"] as? String,
                   let address = userData?["address"] as? String,
                   let email = userData?["email"] as? String,
                   let gender = userData?["gender"] as? String
                {
                    self.lbNameUser.text = username
                    if let url = URL(string: image){
                        URLSession.shared.dataTask(with: url) { data, response, error in
                            if let error = error{
                                self.showAlert(title: "", mess: error.localizedDescription)
                                return
                            }
                            guard let data = data, let image = UIImage(data: data) else {
                                return
                            }
                            DispatchQueue.main.async {
                                self.imageUser.image = image
                            }
                        }.resume()
                    }
                    self.user = User(name: username, email: email, address: address, image: image, phone: phone, gender: gender)
                } else
                {
                    return
                }
            }
        }
    }
    
    @IBAction func btnLogout(_ sender: Any) {
        let auth = Auth.auth()
        do {
           try auth.signOut()
            navigationController?.popToRootViewController(animated: true)
            showAlert(title: "", mess: "Ban da dang xuat thanh cong!")
        }catch{
            self.showAlert(title: "", mess: "\(NSError.self)")
        }
    }
    
}
extension ProfileVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrListProfile.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileTableCell") as! ProfileTableCell
        let data = arrListProfile[indexPath.row]
        cell.img.image = UIImage(named: data.img)
        cell.lbSubject.text = data.subject
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 0:
            //moveFromProfile(screen: EditProfile(nibName: "EditProfile", bundle: nil))
            let editProfile = EditProfile(nibName: "EditProfile", bundle: nil)
            editProfile.user = user
            navigationController?.pushViewController(editProfile, animated: true)
            
        case 1:
            moveFromProfile(screen: OrderHistory(nibName: "OrderHistory", bundle: nil))
            
        default:
            break
        }
    }
}


extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            imageUser.image = image
            dismiss(animated: true)
        }
    }
}
