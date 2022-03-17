//
//  DetailBankAccountsTableViewCell.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/3/8.
//

import UIKit

class DetailBankAccountsTableViewCell: UITableViewCell {

    @IBOutlet weak var transferBankNameLabel: UILabel!
    @IBOutlet weak var transferBankMoney: UILabel!
    @IBOutlet weak var transferDate: UILabel!
    @IBOutlet weak var transferNote: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
