//
//  OrderHistory.swift
//  btlIOS
//
//  Created by Nguyễn Thị Hạ on 13/06/2024.
//

import UIKit
import CarbonKit

class OrderHistory: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpCarbonKit()
    }
    func setUpCarbonKit(){
        let items = ["Placed", "Delivered", "Cancelled"]
        let carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items, delegate: self)
        carbonTabSwipeNavigation.insert(intoRootViewController: self)
        
        let w = (view.frame.width)/CGFloat(items.count)
        let customWidths: [CGFloat] = Array(repeating: w, count: items.count)
            
        for (index, width) in customWidths.enumerated() {
                    carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(width, forSegmentAt: index)
                }
    }

}
extension OrderHistory: CarbonTabSwipeNavigationDelegate{
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        switch index{
        case 0:
            let vc = OrderPlaced(nibName: "OrderPlaced", bundle: nil)
            return vc
        case 1:
            let vc = OrderDelivered(nibName: "OrderDelivered", bundle: nil)
            return vc
        default:
           let vc = OrderCancelled(nibName: "OrderCancelled", bundle: nil)
            return vc
        }
    }
    
    
}
