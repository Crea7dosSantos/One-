//
//  XibTotalPhotoView.swift
//  OneMore
//
//  Created by 池田優作 on 2018/05/05.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import UIKit

class XibTotalPhotoView: UIView {
  @IBOutlet weak var totalCollectionView: UICollectionView!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    loadNib()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    loadNib()
  }
  
  func loadNib() {
    let view = Bundle.main.loadNibNamed("TotalPhotoView", owner: self, options: nil)?.first as! UIView
    view.frame = self.bounds
    self.addSubview(view)
  }
  
  override func awakeFromNib() {
    
    let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
    totalCollectionView.register(nib, forCellWithReuseIdentifier: "Cell")
    
  }
  
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
