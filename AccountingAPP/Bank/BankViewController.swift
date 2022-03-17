//
//  BankViewController.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/3/7.
//

import UIKit

class BankViewController: UIViewController {
    
    var bank = [Bank]() {
        didSet {
            Bank.saveBank(bank)
        }
    }
    
    var speictly

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("test bankView")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let bank = Bank.loadBank() {
            self.bank = bank
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BankViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        bankItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(BankTableViewCell.self)", for: indexPath) as? BankTableViewCell else
        { return UITableViewCell() }
        cell.bankTitleLabel.text = bankItems[indexPath.row]
        return cell
    }
    
    
}
