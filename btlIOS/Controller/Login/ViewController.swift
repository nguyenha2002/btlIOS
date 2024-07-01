

import UIKit
import FirebaseAuth
class ViewController: BaseView {
    
    
    @IBOutlet weak var btnGg: UIButton!
    @IBOutlet weak var btnFb: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        btnContinue.roundCorners(radius: 10)
        btnFb.roundCorners(radius: 10)
        btnGg.roundCorners(radius: 10)
        
    }
    @IBAction func tapOnContinue(_ sender: Any) {
        if tfEmail.text == "" {
            showAlert(title: "", mess: "Please enter your email")
            return
        }
        if tfPassword.text == ""{
            showAlert(title: "", mess: "Please enter your password")
            return
        }
        Auth.auth().signIn(withEmail: tfEmail.text!, password: tfPassword.text!) { result, error in
            if error != nil{
                self.showAlert(title: "", mess: error!.localizedDescription as String)
            }else{
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "tabBarController")
                self.navigationController?.pushViewController(vc, animated: true)
                self.tfEmail.text = ""
                self.tfPassword.text = ""
                self.view.endEditing(true)
            }
        }

    }
    
    @IBAction func tapOnLogInFace(_ sender: Any) {
        moveFromProfile(screen: RegisterScreen(nibName: "RegisterScreen", bundle: nil))
    }
    @IBAction func tapOnLogInGg(_ sender: Any) {
    }
    
    @IBAction func tapOnForgotPass(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: tfEmail.text!) { error in
            if error != nil{
                self.showAlert(title: "", mess: error!.localizedDescription as String)
            }else{
                self.showAlert(title: "", mess: "Please open email to reset password")
            }
        }
    }
}

