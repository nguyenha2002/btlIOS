
import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class EditProfile: BaseView {
    let db = Firestore.firestore()
    let auth = Auth.auth()
    var user: User?
    var gender = ["Male", "Female"]
    let imagePicker = UIImagePickerController()
    
    let storage = Storage.storage()
    @IBOutlet weak var pickerGender: UIPickerView!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfGender: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var imageUser: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerGender.isHidden = true
        setDelegateTextField()
        setupPickerGender()
        
        imageUser.isUserInteractionEnabled = true
        imageUser.roundCorners(radius: 55)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageUser.addGestureRecognizer(tapGesture)
        setupTextField()
        
    }
    @objc func chooseImage(){
        let alert = UIAlertController(title: "", message: "Choose image !!!", preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Library", style: .default) { action1 in
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.delegate = self
            self.present(self.imagePicker, animated: true)
        }
        let action2 = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(action1)
        alert.addAction(action2)
        present(alert, animated: true)
    }
    @IBAction func btnSave(_ sender: Any) {
        if let userID = auth.currentUser?.uid {
            var userData: [String: Any] = [
                "name": tfName.text ?? "",
                "address": tfAddress.text ?? "",
                "phone": tfPhone.text ?? "",
                "gender": tfGender.text ?? "",
                "email": tfEmail.text ?? ""
            ]
            
            if let newImage = imageUser.image{
                uploadImageToStorage(newImage) { imageUrl in
                    if let imageUrl = imageUrl{
                        userData["image"] = imageUrl.absoluteString
                    }
                    
                    self.db.collection("Users").document(userID).updateData(userData) { error in
                        if let error = error{
                            self.showAlert(title: "", mess: error.localizedDescription)
                        }else{
                            self.showAlert(title: "", mess: "Cap nhat thong tin ca nhan thanh cong!")
                        }
                    }
                }
            } else{
                self.db.collection("Users").document(userID).updateData(userData) { error in
                    if let error = error {
                        self.showAlert(title: "", mess: error.localizedDescription)
                    }else{
                        self.showAlert(title: "", mess: "Cap nhat thong tin ca nhan thanh cong!")
                    }
                }
            }
        }
    }
    
    func uploadImageToStorage(_ image: UIImage, completion: @escaping (URL?) -> Void){
        guard let imageData = image.jpegData(compressionQuality: 0.3) else {
            return
        }
        let imageRef = storage.reference().child("user_images/\(UUID().uuidString).jpg")
        imageRef.putData(imageData) { metadata, error in
            if let error = error{
                self.showAlert(title: "", mess: error.localizedDescription)
                completion(nil)
                return
            }
            
            imageRef.downloadURL { url, error in
                if let error = error{
                    self.showAlert(title: "", mess: error.localizedDescription)
                    completion(nil)
                    return
                }
                completion(url)
            }
        }
    }
    
    func setupPickerGender(){
        pickerGender.delegate = self
        pickerGender.dataSource = self
    }
    func setDelegateTextField(){
        tfGender.delegate = self
        tfName.delegate = self
        tfEmail.delegate = self
        tfPhone.delegate = self
        tfAddress.delegate = self
    }
    func setupTextField(){
        if let name = user?.name,
           let phone = user?.phone,
           let address = user?.address,
           let email = user?.email,
           let image = user?.image,
           let gender = user?.gender
        {
            tfName.text = name
            tfEmail.text = email
            tfPhone.text = phone
            tfAddress.text = address
            tfGender.text = gender
            if let url = URL(string: image){
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let error = error {
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
        }
    }
}
extension EditProfile: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gender.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gender[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tfGender.text = gender[row]
        pickerGender.isHidden = true
    }
    
}

extension EditProfile: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == tfGender{
            pickerGender.isHidden = false
            return false
        }else{
            return true
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tfGender.resignFirstResponder()
        tfName.resignFirstResponder()
        tfEmail.resignFirstResponder()
        tfPhone.resignFirstResponder()
        tfAddress.resignFirstResponder()
    }
}
extension EditProfile: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let chooseImage = info[.originalImage] as? UIImage {
            imageUser.image = chooseImage
            dismiss(animated: true)
        }
    }
}
