//
//  MainTableViewCell.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/2/14.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainPhoto: UIImageView!
    @IBOutlet weak var subTypeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state

    }

}
