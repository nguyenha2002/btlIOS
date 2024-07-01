
import UIKit

class BaseView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func showAlert(title: String, mess: String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: mess, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alert.addAction(action)
            self.present(alert, animated: true)
        }
        
    }

}
extension UIViewController{
    func moveFromProfile(screen: UIViewController){
        navigationController?.pushViewController(screen, animated:  true)
    }
    func moveToScreenDetail(){
        let vc = DetailScreen(nibName: "DetailScreen", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    func moveToDetail(product: Product){
        if let vc = DetailScreen(nibName: "DetailScreen", bundle: nil) as? DetailScreen {
            vc.selectedProduct = product
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension UIView{
    func roundCorners(radius: CGFloat){
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
}
