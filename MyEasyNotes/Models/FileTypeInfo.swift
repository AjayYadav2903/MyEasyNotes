//
//  FileTypeInfo.swift
//  Tirade
//
//  Created by admin on 09/04/20.
//  Copyright © 2020 ajayyadav. All rights reserved.
//

import UIKit

class FileTypeInfo: Decodable {
    var fileName : String!
    var mimeType : String!
    var fileData : Data!
    var uploadFileKey : String! 
}
