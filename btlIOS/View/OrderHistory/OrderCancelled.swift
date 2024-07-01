//
//  OrderCancelled.swift
//  btlIOS
//
//  Created by Nguyễn Thị Hạ on 13/06/2024.
//

import UIKit

class OrderCancelled: UIViewController {

    @IBOutlet weak var tableCancelled: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpCancelled()
    }
    func setUpCancelled(){
//        tableCancelled.delegate = self
//        tableCancelled.dataSource = self
//        
        let nib = UINib(nibName: "OrderCell", bundle: nil)
        tableCancelled.register(nib, forCellReuseIdentifier: "orderCell")
    }
}
//extension OrderCancelled: UITableViewDelegate, UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//
    
//}
