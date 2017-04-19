//
//  OpenPagesLayout.swift
//  FaceIraq
//
//  Created by HEMIkr on 19/04/2017.
//  Copyright © 2017 Ready4S. All rights reserved.
//

import UIKit

class OpenPagesLayout: UICollectionViewFlowLayout {
    
}

protocol OpenPagesLayoutDelegate: UICollectionViewDelegateFlowLayout {
    
    func didSwitchingToIndex(index: Int)
    
}
