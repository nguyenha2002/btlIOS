

import UIKit

class ItemCellTwo: UICollectionViewCell {

    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        img.roundCorners(radius: (img.frame.height)/2)
    }

}
