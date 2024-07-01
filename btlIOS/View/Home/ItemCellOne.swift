

import UIKit
import QuartzCore

class ItemCellOne: UICollectionViewCell {

    let gradientLayer = CAGradientLayer()
    
    @IBOutlet weak var btnShow: UIButton!
    @IBOutlet weak var lbMoTa: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var viewCell: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
        viewCell.roundCorners(radius: 15)
        btnShow.roundCorners(radius: (btnShow.frame.height)/2)
        gradientLayer.frame = viewCell.bounds

        gradientLayer.colors = [UIColor.lightGray.cgColor, UIColor.systemGray5.cgColor]
        // Đặt hướng gradient (từ trái sang phải)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)

         // Thêm gradient layer vào view
         self.viewCell.layer.insertSublayer(gradientLayer, at: 0)
    }

}
