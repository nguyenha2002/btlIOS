

import UIKit

protocol CartTableCellDelegate: AnyObject {
    func didChangeQuantity(for cell: CartTableCell, quantity: Int)
}
class CartTableCell: UITableViewCell {
    
    var itemCart: Cart?

    @IBOutlet weak var stepperSL: UIStepper!
    @IBOutlet weak var lbSL: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbSize: UILabel!
    @IBOutlet weak var lbMota: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
