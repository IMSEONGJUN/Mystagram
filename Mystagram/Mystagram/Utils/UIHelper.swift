//
//  UIHelper.swift
//  Mystagram
//
//  Created by SEONGJUN on 2021/02/10.
//

import UIKit

struct UIHelper {
    static func setFeedCellFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let collectionViewWidth = view.frame.width
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let itemsInLine: CGFloat = 1
        let itemSpacing: CGFloat = 0
        let lineSpacing: CGFloat = 0
        let availableWidth = collectionViewWidth - ((itemSpacing * (itemsInLine - 1)) + (inset.left + inset.right))
        let itemWidth = availableWidth / itemsInLine
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = itemSpacing
        layout.minimumLineSpacing = lineSpacing
        layout.sectionInset = inset
        layout.estimatedItemSize = CGSize(width: itemWidth, height: itemWidth + 40 + 8 + 8 + 110)
//        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.scrollDirection = .vertical
        return layout
    }
}
