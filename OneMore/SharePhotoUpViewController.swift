//
//  SharePhotoUpViewController.swift
//  OneMore
//
//  Created by 池田優作 on 2018/05/24.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SharePhotoUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
  @IBOutlet weak var oneMoreImageView: UIImageView!
  @IBOutlet weak var profielNameLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var fightButton: UIButton!
  @IBOutlet weak var commentButton: UIButton!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var moreCountLabel: UILabel!
  @IBOutlet weak var captionTextView: UITextView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var captionBorderView: UIView!
  @IBOutlet weak var commentBorderView: UIView!
  @IBOutlet weak var commentCountLabel: UILabel!
  
  // 変数photoInformationに前の画面でUICollectionViewでタップされた画像の情報を取得する
  var photoInformation: PostData!
  let formatter = DateFormatter()
  var label = UILabel()
  var buttonStatus: Bool?
  var user = Auth.auth().currentUser
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      tableView.delegate = self
      tableView.dataSource = self
      // tableViewのCellのタップを不可にする
      self.tableView.allowsSelection = false
      // tableViewのseparatorColorを透明にする
      self.tableView.separatorColor = UIColor.clear
     
      print("DEBUG_PRINT: viewDidLoad")
      // moreの配列の中にログインしているユーザーのidがあるかを確認してある場合とない場合の処理を記述する
      
      if let uid = Auth.auth().currentUser?.uid {
        for likeID in photoInformation.likes {
          if likeID == uid {
            buttonStatus = true
            let buttonImage = UIImage(named: "FireRed48.png")
            self.fightButton.setImage(buttonImage, for: .normal)
          } else {
            buttonStatus = false
            let buttonImage = UIImage(named: "FireWhite48.png")
            self.fightButton.setImage(buttonImage, for: .normal)
          }
        }
      }
      
      self.oneMoreImageView.layer.cornerRadius = 15
      self.oneMoreImageView.layer.masksToBounds = true
      
      label.font = UIFont.systemFont(ofSize: 20)
      label.text = photoInformation?.name
      
      oneMoreImageView.image = UIImage(named: "mascleEditor.png")
      imageView.image = photoInformation.image
      profielNameLabel.text = photoInformation?.name
      formatter.dateFormat = "yyyy/MM/dd HH:mm"
      let dateString = formatter.string(from: photoInformation.date!)
      dateLabel.text = dateString
      captionTextView.text = "\(label.text!) \(photoInformation.caption!)"
      let fightCount = photoInformation.likes.count
      moreCountLabel.text = "more! \(fightCount)"
      let commentCount = photoInformation.commentList.count
      commentCountLabel.text = "\(commentCount)"
      /*
      let captionViewBorder = CALayer()
      captionViewBorder.frame = CGRect(x: 0, y: captionBorderView.frame.height, width: captionBorderView.frame.width, height: 1.0)
      captionViewBorder.backgroundColor = UIColor.lightGray.cgColor
      captionBorderView.layer.addSublayer(captionViewBorder) */
      let commentViewBorder = CALayer()
      commentViewBorder.frame = CGRect(x: 0, y: commentBorderView.frame.height, width: commentBorderView.frame.width, height: 1.0)
      commentViewBorder.backgroundColor = UIColor.lightGray.cgColor
      commentBorderView.layer.addSublayer(commentViewBorder)
      
      navigationItem.title = "応援"
      
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  override func viewWillAppear(_ animated: Bool) {
    tableView.reloadData()
  }
  
  @IBAction func handleFightButton(_ sender: Any) {
    print("DEBUG_PRINT: moreボタンがタップされました")
    let postData = photoInformation!
 
    // Firebaseに保存するデータの準備
    if let uid = Auth.auth().currentUser?.uid {
      // moreボタンがタップされていた時の処理
      if buttonStatus == true {
        var index = -1
        for likeId in postData.likes {
          if likeId == uid {
            index = postData.likes.index(of: likeId)!
            break
          }
        }
        postData.likes.remove(at: index)
        buttonStatus = false
        let buttonImage = UIImage(named: "FireWhite48.png")
        self.fightButton.setImage(buttonImage, for: .normal)
        let moreCountInt = postData.likes.count
        print("DEBUG_PRINT: \(moreCountInt)")
        moreCountLabel.text = "more! \(moreCountInt)"
   
      } else {
        // moreボタンがタップされていなかったときの処理
        postData.likes.append(uid)
        buttonStatus = true
        let buttonImage = UIImage(named: "FireRed48.png")
        self.fightButton.setImage(buttonImage, for: .normal)
        let moreCountInt = postData.likes.count
        print("DEBUG_PRINT: \(moreCountInt)")
        moreCountLabel.text = "more! \(moreCountInt)"
      }
      
      let postRef = Database.database().reference().child(Const.PostPath).child(postData.id!)
      let likes = ["likes": postData.likes]
      postRef.updateChildValues(likes)
    }
  }
  
  @IBAction func commentAction(_ sender: Any) {
    performSegue(withIdentifier: "shareButtonSegue", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // もしコメントボタンをタップした時はshareButtonSegueで画面遷移をする
    if segue.identifier == "shareButtonSegue" {
      let shareCommentViewController: ShareCommentViewController = segue.destination as! ShareCommentViewController
      print("DEBUG_PRINT: CommentActionがタップされました")
      // 画面遷移時に表示されているデータをshareCommentViewControllerの変数に格納する
      shareCommentViewController.photoInformation = photoInformation
    }
  }
  
  var commentArray = [String]()
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return photoInformation.commentList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // 再利用可能なcellを得る
    let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath)
    
    // Cellに値を設定する
    for comment in photoInformation.commentList {
      commentArray.append(comment)
    }
    cell.textLabel?.numberOfLines = 0
    cell.textLabel?.text = commentArray[indexPath.row]
  return cell
  }
  
 
  
  

}
