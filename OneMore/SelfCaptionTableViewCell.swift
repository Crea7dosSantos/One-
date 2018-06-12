//
//  SelfCaptionTableViewCell.swift
//  OneMore
//
//  Created by 池田優作 on 2018/05/25.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import UIKit

class SelfCaptionTableViewCell: UITableViewCell {
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var textView: UITextView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
