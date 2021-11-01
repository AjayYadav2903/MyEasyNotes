//
//  TitleCell.swift
//  MyEasyNotes
//
//  Created by admin on 12/10/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class TitleCell: UITableViewCell {

    @IBOutlet weak var vwSide : UIView!

    @IBOutlet weak var txtFldTitle : UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        DataUtils.setTextFieldTextColor(textField: txtFldTitle, text: "Title Here", placeholderCol: .gray)
    }
}
