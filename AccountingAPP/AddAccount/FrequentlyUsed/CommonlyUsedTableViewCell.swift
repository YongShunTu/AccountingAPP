//
//  CommonlyUsedTableViewCell.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/2/18.
//

import UIKit

class CommonlyUsedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var commonPhoto: UIImageView!
    @IBOutlet weak var commonTitleLabel: UILabel!
    @IBOutlet weak var commonCategoryLabel: UILabel!
    @IBOutlet weak var commonMoney: UILabel!
    @IBOutlet weak var commonButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }


}
