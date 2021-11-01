//
//  ImageCell.swift
//  MyEasyNotes
//
//  Created by admin on 12/10/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {

    @IBOutlet weak var collShowContents : UICollectionView!

    var imageArr = [FileTypeInfo]()

  
}

extension ImageCell {

    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {

        collShowContents.delegate = dataSourceDelegate
        collShowContents.dataSource = dataSourceDelegate
        collShowContents.tag = row
        collShowContents.setContentOffset(collShowContents.contentOffset, animated:false) // Stops collection view if it was scrolling.
        collShowContents.reloadData()
    }

    var collectionViewOffset: CGFloat {
        set { collShowContents.contentOffset.x = newValue }
        get { return collShowContents.contentOffset.x }
    }
}
