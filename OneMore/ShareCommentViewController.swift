//
//  ShareCommentViewController.swift
//  OneMore
//
//  Created by 池田優作 on 2018/05/25.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD
import SDWebImage

class ShareCommentViewController: UIViewController, UITextViewDelegate {
  @IBOutlet weak var selfImageView: UIImageView!
  @IBOutlet weak var selfCaptionTextView: UITextView!
  @IBOutlet weak var selfCommentView: UIView!
  @IBOutlet weak var commenterImageView: UIImageView!
  @IBOutlet weak var commentTextView: UITextView!
  @IBOutlet weak var handleCommentButton: UIButton!
  @IBOutlet weak var hiddenLabal: UILabel!
  
  var photoInformation: PostData!
  let user = Auth.auth().currentUser
  
    override func viewDidLoad() {
        super.viewDidLoad()
      // 現在ログインしているユーザーのphotoURLをcommenterImageViewに格納する
      if user?.photoURL == nil {
        commenterImageView.image = UIImage(named: "SelfHuman128.png")
      } else {
        commenterImageView.sd_setImage(with: user?.photoURL)
      }
      
      // textViewを編集不可にする
      selfCaptionTextView.isEditable = false
      commentTextView.delegate = self
      
      selfImageView.image = photoInformation.image
      selfCaptionTextView.text = "\(photoInformation.name!) : \(photoInformation.caption!)"
      
      let selfCommentViewBorder = CALayer()
      selfCommentViewBorder.frame = CGRect(x: 0, y: selfCommentView.frame.height, width: selfCommentView.frame.width, height: 1.0)
      selfCommentViewBorder.backgroundColor = UIColor.lightGray.cgColor
      selfCommentView.layer.addSublayer(selfCommentViewBorder)
      
      self.selfImageView.layer.cornerRadius = 15
      self.selfImageView.layer.masksToBounds = true
      
      self.commenterImageView.layer.cornerRadius = 15
      self.commenterImageView.layer.masksToBounds = true
      
      navigationItem.title = "コメント"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  @IBAction func commentTransmissionAction(_ sender: Any) {
    if let text = commentTextView.text {
      if text.isEmpty {
        SVProgressHUD.showError(withStatus: "コメントを入力してください")
        return
      }
      SVProgressHUD.showSuccess(withStatus: "コメントを送信しました")
      photoInformation.commentList.append("\(user!.displayName!): \(commentTextView.text!)")
    }
    let postRef = Database.database().reference().child(Const.PostPath).child(photoInformation.id!)
    
    let comment = ["commentList": photoInformation.commentList]
    postRef.updateChildValues(comment)
    
    // 一つ前の画面に遷移する
    self.navigationController?.popViewController(animated: true)
  }
  
  
  func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
    hiddenLabal.isHidden = true
    return true
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if let text = commentTextView.text {
      if text.isEmpty {
        hiddenLabal.isHidden = false
      }
      hiddenLabal.isHidden = true
    }
  }
  
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
