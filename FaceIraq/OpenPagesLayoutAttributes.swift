//
//  OpenPagesLayoutAttributes.swift
//  FaceIraq
//
//  Created by HEMIkr on 19/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import UIKit

class OpenPagesLayoutAttributes: UICollectionViewLayoutAttributes {

    var displayTransform: CATransform3D = CATransform3DIdentity
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! OpenPagesLayoutAttributes
        copy.displayTransform = displayTransform
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        let attr = object as! OpenPagesLayoutAttributes
        return super.isEqual(object) &&
            CATransform3DEqualToTransform(displayTransform, attr.displayTransform)
    }
}
