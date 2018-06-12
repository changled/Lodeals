//
//  TimesCollectionViewLayout.swift
//  Lodeals
//
//  Created by Rachel Chang on 6/11/18.
//  Copyright © 2018 Rachel Chang. All rights reserved.
//

import UIKit

@IBDesignable
class TimesCollectionViewLayout: UICollectionViewLayout {
    // used to calculate each cell's CGRect on screen (to define origin and size of cell)
    let cellWidth = 46.0
    let cellHeight = 30.0
    
    // holds layout attributes for each cell to define cell's size and position (x-y-z index)
    var cellAttributesDict : [IndexPath: UICollectionViewLayoutAttributes] = [:]
    
    // defines size of area the user can move around in within collection view
    var contentSize = CGSize.zero
    
    override var collectionViewContentSize: CGSize {
        return self.contentSize
    }
    
    // generate attribute layouts with each cell's position and size and store in local dictionary cache
    override func prepare() {
        if let numSections = collectionView?.numberOfSections {
            for section in (0...numSections - 1) {
                if let numItemsInSection = collectionView?.numberOfItems(inSection: section) {
                    for item in (0...numItemsInSection - 1) {
                        let cellIndex = IndexPath(item: item, section: section)
                        let xPos = Double(item) * cellWidth
                        let yPos = Double(section) * cellHeight
                        print("sect \(section), item \(item) at x: \(xPos), y: \(yPos)")
                        
                        let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: cellIndex)
                        cellAttributes.frame = CGRect(x: xPos, y: yPos, width: cellWidth, height: cellHeight)
                        cellAttributes.zIndex = 1
                        
                        cellAttributesDict[cellIndex] = cellAttributes
                    }
                }
                else {
                    print("Error in TimesCollectionViewLayout: cannot unwrap collectionView?.numberOfItems")
                }
            }
        }
        else {
            print("Error in TimesCollectionViewLayout: cannot unwrap collectionView?.numberOfSections")
        }
    }
    
    // given a rectangle, return all attributes that intersect it (fit inside)
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for (_, attributes) in cellAttributesDict {
            if (attributes.frame.intersects(rect)) {
                print("attribute.frame \(String(describing: attributes.frame)) intersects with rect at \(rect.origin) of size \(rect.size)!")
                visibleLayoutAttributes.append(attributes)
            }
        }
        
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellAttributesDict[indexPath]
    }
    
    // if return true, prepare() will get called again; set true if scrolling
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
//        return false // doesn't work; only showing first section
        
        
        return true // doesn't work; only showing first section
    }
}
