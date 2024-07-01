

import UIKit

class ShopCellTable: UITableViewCell {


    @IBOutlet weak var viewCellShop: UIView!
    @IBOutlet weak var lbLoai: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewCellShop.roundCorners(radius: 20)
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
