//
//  OrderDelivered.swift
//  btlIOS
//
//  Created by Nguyễn Thị Hạ on 13/06/2024.
//

import UIKit

class OrderDelivered: UIViewController {

    @IBOutlet weak var tableDelivered: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpDelivered()
    }
    func setUpDelivered(){
//        tableDelivered.delegate = self
//        tableDelivered.dataSource = self
//        
        let nib = UINib(nibName: "OrderCell", bundle: nil)
        tableDelivered.register(nib, forCellReuseIdentifier: "orderCell")
    }
}
//extension OrderDelivered: UITableViewDelegate, UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//
//
//}
