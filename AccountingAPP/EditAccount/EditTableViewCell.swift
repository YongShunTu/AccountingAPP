//
//  EditTableViewCell.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/2/15.
//

import UIKit

class EditTableViewCell: UITableViewCell {

    @IBOutlet weak var itemsLabel: UILabel!
    @IBOutlet weak var itemsPhoto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
