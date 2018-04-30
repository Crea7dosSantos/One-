//
//  PostTableViewCell.swift
//  OneMore
//
//  Created by 池田優作 on 2018/03/23.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//
// Autolayoutの設定によって、セル内のイメージやラベルの高さは自動的に調整される

import UIKit

class PostTableViewCell: UITableViewCell {
  @IBOutlet weak var profielImage: UIImageView!
  @IBOutlet weak var userLabel: UILabel!
  @IBOutlet weak var editingButton: UIButton!
  @IBOutlet weak var postImageView: UIImageView!
  @IBOutlet weak var likeLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var captionLabel: UILabel!
  @IBOutlet weak var likeButton: UIButton!
  
  // awakeFromNibはセルが最初に表示される時に処理される
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      
      // 角丸を適用する
      self.profielImage.layer.cornerRadius = 30
      // 角丸に合わせて画像をマスクする
      self.profielImage.layer.masksToBounds = true
      
  }
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  // setPostDataメソッドでPostTableViewCell内のUI部品に対し、PostData内の値を格納していく
  // setPostDataメソッドの引数postDataはPostDataクラスを指定する
  func setPostData(_ postData: PostData) {
    self.postImageView.image = postData.image
    
    // 文字列で表示させる為にダブルクォーテーションで括っている
    self.captionLabel.text = "\(postData.name!) : \(postData.caption!)"
    let likeNumber = postData.likes.count
    likeLabel.text = "\(likeNumber)"
    
    // DateFormatterクラスのインスタンスを作成する
    let formatter = DateFormatter()
    // dateFormatプロパティに値を格納する
    formatter.dateFormat = "yyyy-MM--dd HH:mm"
    // postDataクラスに保存された値をstring型で取りだす
    let dateString = formatter.string(from: postData.date!)
    self.dateLabel.text = dateString
    
    //UIImageクラスのsetImage()メソッドにUIImageとどの状態の画像かを指定して設定する
    // isLikedがfalseだったらハートボタンを赤で表示する
    if postData.isLiked {
      let buttonImage = UIImage(named: "like_exist")
      self.likeButton.setImage(buttonImage, for: .normal)
      // それ以外は白
    } else {
      let buttonImage = UIImage(named: "like_none")
      self.likeButton.setImage(buttonImage, for: .normal)
    }
  }
}
