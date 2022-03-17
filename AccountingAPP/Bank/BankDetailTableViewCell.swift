//
//  BankDetailTableViewCell.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/3/15.
//

import UIKit

class BankDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var bankDetailNameLabel: UILabel!
    @IBOutlet weak var bankDetailMoney: UILabel!
    @IBOutlet weak var bankDetailDate: UILabel!
    @IBOutlet weak var bankDetailNote: UILabel!
    @IBOutlet weak var bankDetailPhoto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
