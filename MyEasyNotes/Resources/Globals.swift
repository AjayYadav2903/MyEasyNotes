//
//  Globals.swift
//  BlueCoupon
//
//  Created by Impero IT on 03/06/16.
//  Copyright © 2016 Impero IT. All rights reserved.
//

import UIKit
import SystemConfiguration
class Globals {
    static let sharedInstance = Globals()

    var stateglobal = ""
    var cityglobal = ""
    var zipcodeglobal = ""
    var iSLocation = true
    var subLocality = ""
    
    var latitu = 0.0
    var longitu = 0.0
    let userDefaults = UserDefaults.standard

    
 
    private init() {

    }
     class func convertToDictionary(text: String) -> [String: Any]? {
          if let data = text.data(using: .utf8) {
               do {
                    return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
               } catch {
                    
               }
          }
          return nil
     }
}
func isInternetAvailable() -> Bool
{
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
        }
    }
    
    var flags = SCNetworkReachabilityFlags()
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
        return false
    }
    let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
    let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
    return (isReachable && !needsConnection)
}
func compressForUpload(original:UIImage, withHeightLimit heightLimit:CGFloat, andWidthLimit widthLimit:CGFloat)->UIImage{
    
    let originalSize = original.size
    var newSize = originalSize
    
    if originalSize.width > widthLimit && originalSize.width > originalSize.height {
        
        newSize.width = widthLimit
        newSize.height = originalSize.height*(widthLimit/originalSize.width)
    }else if originalSize.height > heightLimit && originalSize.height > originalSize.width {
        
        newSize.width = 800
        newSize.height = originalSize.height*(widthLimit/originalSize.width)
    }
    
    // Scale the original image to match the new size.
    UIGraphicsBeginImageContext(newSize)
    
    original.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
    let compressedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return compressedImage!
}

