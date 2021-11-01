//
//  HomeCollCell.swift
//  MyEasyNotes
//
//  Created by admin on 09/10/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class HomeCollCell: UICollectionViewCell {
    
    @IBOutlet weak var img : UIImageView!
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblNotes : UILabel!
    @IBOutlet weak var lblReminder : UILabel!
    @IBOutlet weak var imgClock : UIImageView!
    @IBOutlet weak var lblCreatedAt : UILabel!
    @IBOutlet weak var vwReminder : UIView!
    
    @IBOutlet weak var consImgHeight : NSLayoutConstraint!
    @IBOutlet weak var lblContentHeight : NSLayoutConstraint!
}
