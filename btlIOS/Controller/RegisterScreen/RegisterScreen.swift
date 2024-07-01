
import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class RegisterScreen: BaseView {

    @IBOutlet weak var tfPhoneNumber: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var tfConfirmPass: UITextField!
    @IBOutlet weak var tfPass: UITextField!
    @IBOutlet weak var tfNameUser: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func btnRegister(_ sender: Any) {
        if tfName.text == "" {
            showAlert(title: "", mess: "Please enter your name")
            return
        }
        if tfNameUser.text == "" {
            showAlert(title: "", mess: "Please enter your email")
            return
        }
        if tfAddress.text == nil{
            showAlert(title: "", mess: "Please enter your address")
            return
        }
        if tfPhoneNumber.text == "" {
            showAlert(title: "", mess: "Please enter your phone number")
            return
        }
        if tfPass.text == "" {
            showAlert(title: "", mess: "Please enter your password")
            return
        }
        if tfConfirmPass.text == "" {
            showAlert(title: "", mess: "Please enter confirm your password")
            return
        }
        if tfPass.text != tfConfirmPass.text{
            showAlert(title: "", mess: "Password not match")
            return
        }
        
        
        Auth.auth().createUser(withEmail: tfNameUser.text!, password: tfPass.text!) { [self] result, error in
            if error != nil{
                self.showAlert(title: "", mess: (error!.localizedDescription as String))
            }else{
                self.showAlert(title: "", mess: "You have register successfully")
                let db = Firestore.firestore()
                if let data = result{
                    let value = ["email": data.user.email]
                    db.collection("Users").document(data.user.uid).setData(["email":data.user.email!, "address": self.tfAddress.text!, "name": tfName.text!, "phone": tfPhoneNumber.text!, "image": "", "gender": ""]) { error in
                        if error != nil {
                            self.showAlert(title: "", mess: error!.localizedDescription)
                        }else{
                            self.tfName.text = ""
                            self.tfAddress.text = ""
                            self.tfNameUser.text = ""
                            self.tfPass.text = ""
                            self.tfConfirmPass.text = ""
                            self.tfPhoneNumber.text = ""
                            let sb = UIStoryboard(name: "Main", bundle: nil)
                            let vc = sb.instantiateViewController(withIdentifier: "tabBarController")
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        }
                    }
                }
                
        }
        
    }
    
    
}

