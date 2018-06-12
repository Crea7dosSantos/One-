//
//  XibCategoryPhotoView.swift
//  OneMore
//
//  Created by 池田優作 on 2018/05/05.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import UIKit

class XibCategoryPhotoView: UIView {
  @IBOutlet weak var timeView: UIView!
  @IBOutlet weak var muscleView: UIView!
  @IBOutlet weak var categoryView: UIView!
  @IBOutlet weak var morningButton: UIButton!
  @IBOutlet weak var noonButton: UIButton!
  @IBOutlet weak var nightButton: UIButton!
  @IBOutlet weak var upperBodyButton: UIButton!
  @IBOutlet weak var lowerBodyButton: UIButton!
  @IBOutlet weak var chestButton: UIButton!
  @IBOutlet weak var backButton: UIButton!
  @IBOutlet weak var absButton: UIButton!
  @IBOutlet weak var bicepsButton: UIButton!
  @IBOutlet weak var tricepsButton: UIButton!
  @IBOutlet weak var sholderButton: UIButton!
  @IBOutlet weak var legButton: UIButton!
  @IBOutlet weak var calfButton: UIButton!
  @IBOutlet weak var footButton: UIButton!
  @IBOutlet weak var assButton: UIButton!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    loadNib()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    loadNib()
  }
  
  func loadNib() {
    let view = Bundle.main.loadNibNamed("CategoryPhotoView", owner: self, options: nil)?.first as! UIView
    view.frame = self.bounds
    self.addSubview(view)
  }
  
  override func awakeFromNib() {
  }
  
  
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
