//
//  ContentTextCell.swift
//  MyEasyNotes
//
//  Created by admin on 12/10/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class ContentTextCell: UITableViewCell {

    @IBOutlet weak var txtVwNotes : KMPlaceholderTextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        txtVwNotes.placeholder = "Notes here"
        txtVwNotes.placeholderColor = UIColor.gray
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
