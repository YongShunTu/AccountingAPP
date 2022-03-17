//
//  BankAccountsTableViewCell.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/3/7.
//

import UIKit

class BankAccountsTableViewCell: UITableViewCell {

    @IBOutlet weak var bankPhoto: UIImageView!
    @IBOutlet weak var bankTitleLabel: UILabel!
    @IBOutlet weak var bankInitialMoneyLabel: UILabel!
    @IBOutlet weak var bankMoney: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
