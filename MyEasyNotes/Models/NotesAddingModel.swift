//
//  NotesAddingModel.swift
//  MyEasyNotes
//
//  Created by admin on 13/10/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class NotesAddingModel : Codable {
    
    var title : String?    
    var colorOfObj : UIColor = DataUtils.hexStringToUIColor(hex: "#00FFFF")
    
    var isReminder = false
    var isImages = false
    var isContent = false
    var images : [Data] = []
    var reminders  : [String] = []
    var contentTxt : [String] = []
    enum CodingKeys: String, CodingKey {
        case images = "images"

    }
}


extension UIImage {
    var data: Data? {
        if let data = self.jpegData(compressionQuality: 1.0) {
            return data
        } else {
            return nil
        }
    }
}

extension Data {
    var image: UIImage? {
        if let image = UIImage(data: self) {
            return image
        } else {
            return nil
        }
    }
}


