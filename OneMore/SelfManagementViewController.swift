//
//  SelfManagementViewController.swift
//  OneMore
//
//  Created by 池田優作 on 2018/03/06.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SDWebImage

class SelfManagementViewController: UIViewController, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
  @IBOutlet weak var userName: UINavigationItem!
  @IBOutlet weak var profielView: UIView!
  @IBOutlet weak var dreamTextView: UITextView!
  @IBOutlet weak var profielImageView: UIImageView!
  @IBOutlet weak var recordLabel: UILabel!
  @IBOutlet weak var focusLabel: UILabel!
  @IBOutlet weak var nextView: UIView!
  @IBOutlet weak var stackView: UIStackView!
  
  // XibTotalPhotoViewの型にして変数を宣言する
  var totalXib: XibTotalPhotoView!
  
  var postArray: [PostData] = []
  
  // DatabaseのobserveEventの登録状態を表す
  var observing = false
  
  override func viewDidLoad() {
        super.viewDidLoad()
    
    // インスタンスの生成
    totalXib = XibTotalPhotoView()
    
    totalXib.totalCollectionView.dataSource = self
    totalXib.totalCollectionView.delegate = self
    
    // TextViewにデリゲートを設定する
    dreamTextView.delegate = self
    
    // TextViewの編集を無効にする
    dreamTextView.isEditable = false
    // profielViewに下線を表示する
    let weightBorder = CALayer()
    weightBorder.frame = CGRect(x: 0, y: profielView.frame.height, width: profielView.frame.width, height: 1.0)
    weightBorder.backgroundColor = UIColor.lightGray.cgColor
    // Viewに追加する
    profielView.layer.addSublayer(weightBorder)
    
    // stackViweに下線を表示する
    let weightBorders = CALayer()
    weightBorders.frame = CGRect(x: 0, y: stackView.frame.height, width: stackView.frame.width, height: 1.0)
    weightBorders.backgroundColor = UIColor.lightGray.cgColor
    // Viewに追加する
    stackView.layer.addSublayer(weightBorders)
    
    // 現在ログインしているユーザーの情報を取得する
    let user = Auth.auth().currentUser
    
    // navigationBarのtextにユーザーネームを格納する
    userName.title = user?.displayName
    
    // もしユーザーのphotoURLがなければデフォルトを設定する
    if user?.photoURL == nil {
      profielImageView.image = UIImage(named: "profielImageDefault")
    } else {
      // もしユーザーのphotoURLが設定済みだったら設定する
      profielImageView.sd_setImage(with: user?.photoURL)
    }
    
        // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    if Auth.auth().currentUser != nil {
      if self.observing == false {
        // 要素が追加されたらpostArrayに追加してCollectionViewを再表示する
        let postRef = Database.database().reference().child(Const.PostPath)
        postRef.observe(.childAdded, with: { snapshot in
          print("DEBUG_PRINT: .childAddedイベントが発生しました")
          
          // PostDataクラスを生成して受け取ったデータを設定する
          if let uid = Auth.auth().currentUser?.uid {
            let postData = PostData(snapshot: snapshot, myId: uid)
            self.postArray.insert(postData, at: 0)
            
            self.totalXib.totalCollectionView.reloadData()
          }
        })
        // 要素が変更されたら街灯のデータをpostArrayから一度削除した後に新しいデータを追加してCollectionViewを再表示する
        postRef.observe(.childChanged, with: {snapshot in
          print("DEBUG_PRINT: .childChangedイベントが発生しました。")
          
          if let uid = Auth.auth().currentUser?.uid {
            // PostDataクラスを生成して受け取ったデータを設定する
            let postData = PostData(snapshot: snapshot, myId: uid)
            
            // 保持している配列からidが同じものを探す
            var index: Int = 0
            for post in self.postArray {
              if post.id == postData.id {
                index = self.postArray.index(of: post)!
                break
              }
            }
            
            // 差し変えるため一度削除する
            self.postArray.remove(at: index)
            
            // 削除したところに更新済みのデータを追加する
            self.postArray.insert(postData, at: index)
            
            // TableViewを再表示する
            self.totalXib.totalCollectionView.reloadData()
          }
        })
        
        // DatabaseのobserveEventが上記コードにより登録されたため
        // trueとする
        observing = true
      }
    } else {
      if observing == true {
        // ログアウトを検出したら、一旦テーブルをクリアしてオブザーバーを削除する。
        // テーブルをクリアする
        postArray = []
        totalXib.totalCollectionView.reloadData()
        // オブザーバーを削除する
        Database.database().reference().removeAllObservers()
        
        // DatabaseのobserveEventが上記コードにより解除されたため
        // falseとする
        observing = false
      }
    }
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
  @IBAction func totalPhotoAction(_ sender: Any) {
    print("totalPhotoがタップされました")
    // TotalPhotoViewを表示する
    totalXib.frame = CGRect(x: 0, y: 210, width: self.view.frame.width, height: 400)
    // viewにtotalXibを表示する
    nextView.addSubview(totalXib)
  }
  
  @IBAction func categoryPhoto(_ sender: Any) {
  }
  
  // textViewがフォーカスされたら、Labelを非表示にする
  func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
    focusLabel.isHidden = true
    return true
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return postArray.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = totalXib.totalCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
    cell.setPostData(postArray[indexPath.row])
    
    return cell
    
  }
  
  // textViewからフォーカスが外れて、TextViewが空だったらlabelを再表示する
  func textViewDidEndEditing(_ textView: UITextView) {
    
    // もしtextFieldの値がisEnptyならlabelを表示する
    if let text = dreamTextView.text {
      if text.isEmpty {
        focusLabel.isHidden = false
      }
    }
  }

}
