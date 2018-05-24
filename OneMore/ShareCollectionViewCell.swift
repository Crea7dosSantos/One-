//
//  ShareCollectionViewCell.swift
//  OneMore
//
//  Created by 池田優作 on 2018/05/24.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import UIKit

class ShareCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var imageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Intialization code
  }
  
  func setPostData(_ postData: PostData) {
    self.imageView.image = postData.image
  }
  
}


