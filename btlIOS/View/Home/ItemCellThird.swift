
import UIKit

class ItemCellThird: UICollectionViewCell {

    @IBOutlet weak var viewCellThird: UIView!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewCellThird.roundCorners(radius: 15)
    }

}
