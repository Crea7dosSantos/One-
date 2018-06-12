//
//  PostTableViewCell.swift
//  OneMore
//
//  Created by 池田優作 on 2018/05/30.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
  @IBOutlet weak var profielNameLabel: UILabel!
  @IBOutlet weak var postImageView: UIImageView!
  @IBOutlet weak var fireButton: UIButton!
  @IBOutlet weak var commentButton: UIButton!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var moreCountLabel: UILabel!
  @IBOutlet weak var captionTextView: UITextView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
