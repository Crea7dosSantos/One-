//
//  MorningPhotoViewCell.swift
//  OneMore
//
//  Created by 池田優作 on 2018/05/09.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import UIKit

class MorningPhotoViewCell: UICollectionViewCell {
  @IBOutlet weak var imageView: UIImageView!
  
  override func awakeFromNib() {
    print("DEBUG_PRINT_CELL_M: セルが表示されます")
  }
}
