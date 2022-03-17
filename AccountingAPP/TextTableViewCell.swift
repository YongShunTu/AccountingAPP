//
//  TextTableViewCell.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/2/21.
//

import UIKit

class TextTableViewCell: UITableViewCell {
    
    @IBOutlet var imagePhoto: UIImageView!
    @IBOutlet var itemsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
