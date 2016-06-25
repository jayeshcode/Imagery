//
//  FilterCell.swift
//  Imagery
//
//  Created by  Jayesh Wadhwani on 2016-06-14.
//  Copyright © 2016  Jayesh Wadhwani. All rights reserved.
//

import UIKit
import GPUImage

class FilterCell: UICollectionViewCell {
    
    // MARK: Properties
    @IBOutlet weak var filterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func displayFilter(filterTuple: (UIImage, Filter)) {
        let filterName = filterTuple.1.name
        filterImageView.image = filterTuple.0
        nameLabel.text = filterName
    }
}
