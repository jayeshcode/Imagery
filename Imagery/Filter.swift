//
//  Filter.swift
//  Imagery
//
//  Created by  Jayesh Wadhwanion 2016-06-14.
//  Copyright © 2016  Jayesh Wadhwani. All rights reserved.
//

import Foundation
import GPUImage

class Filter: NSObject {
    
    // MARK: Properties
    
    var type: GPUImageOutput
    var group: FilterGroup
    var name: String
    var source: GPUImagePicture?
    
    init(type: GPUImageOutput, name: String, group: FilterGroup, source: GPUImagePicture?) {
        self.type = type
        self.name = name
        self.group = group
        self.source = source
    }
}