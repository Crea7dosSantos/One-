//
//  CollectionViewCell.swift
//  OneMore
//
//  Created by 池田優作 on 2018/05/06.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var imageView: UIImageView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  
  func setPostData(_ postData: PostData) {
    self.imageView.image = postData.image
    print("DBUG_PRINT_CELL: \(String(describing: imageView.image))")
    
  }
  
  

}
