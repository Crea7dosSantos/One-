//
//  ShareViewController.swift
//  OneMore
//
//  Created by 池田優作 on 2018/05/23.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SDWebImage
import SVProgressHUD
import SDWebImage

class ShareViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  @IBOutlet weak var shareCollectionView: UICollectionView!
  
  // postDataの値を格納する配列を作成する
  var postArray: [PostData] = []
  
  // DatabaseのobserveEventの登録状態を表す
  var observing = false
  
  var url: URL?
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      self.shareCollectionView.delegate = self
      self.shareCollectionView.dataSource = self
      
        // Do any additional setup after loading the view.
    }
  
  override func viewWillAppear(_ animated: Bool) {
    // もしもcurrentUserがnilじゃなかったら
    if Auth.auth().currentUser != nil {
      if self.observing == false {
        // 要素が追加されたらpostArrayに追加してCollectionViewを再表示する
        // 投稿データが保存されているデータの保存場所をpostRefに格納しておく
        let postRef = Database.database().reference().child(Const.PostPath)
        // observeメソッドでイベントを指定しておく事で、指定イベントが発生したときにクロージャが呼び出される
        // obseerveイベントでDataSnapshotに保存されているデータを取得する
        postRef.observe(.childAdded, with: { snapShot in
          print("DEBUG_PRINT: .childイベントが発生しました")
          
          // PostDataクラスを生成して受け取ったデータを設定する
          if let uid = Auth.auth().currentUser?.uid {
            let postData = PostData(snapshot: snapShot, myId: uid)
            self.postArray.insert(postData, at: 0)
            
            //shareCollectionViewを更新する
            self.shareCollectionView.reloadData()
          }
        })
        // 要素が変更されたら該当のデータをpostArrayから一度削除した後に新しいデータを追加してCollectionViewを再表示する
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
            
            // 差し替えるため一度削除する
            self.postArray.remove(at: index)
            
            // 削除したところに更新済みのデータを追加する
            self.postArray.insert(postData, at: index)
            
            // CollectionViewを再表示する
            self.shareCollectionView.reloadData()
          }
        })
        // DatabasのobserveEventが上記コードにより登録されたためtrueとする
        observing = true
      }
    } else {
      if observing == true {
        // ログアウトを検出したら、一旦デーブルをクリアしてオブザーバーを削除する
        // テーブルをクリアにする
        postArray = []
        shareCollectionView.reloadData()
        // オブザーバーを削除する
        Database.database().reference().removeAllObservers()
        
        // DatabaseのobserveEnentが上記コードにより解除されたため
        // falseとする
        observing = false
      }
    }
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  // collectionViewのCellの数を返す
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return postArray.count
  }
  
  // collectionViewのCellの内容を返す
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = shareCollectionView.dequeueReusableCell(withReuseIdentifier: "ShareCell", for: indexPath) as! ShareCollectionViewCell
    cell.setPostData(postArray[indexPath.row])
    
    return cell
  }
  
  // 各セルを選択した時に実行されるメソッド
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    // セルがタップされた時はshareUpPhotoで画面遷移をする
    performSegue(withIdentifier: "shareUpPhoto", sender: nil)
  }
  
  // セルサイズの自動変更を設定する
  // セルサイズの自動変更を設定する
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    let width: CGFloat = view.frame.width / 3 - 1   // self.viewを/3し、-1は隙間の部分
    let height: CGFloat = width
    
    return CGSize(width: width, height: height)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // もしshreUpPhotoで画面遷移をするとき
    if segue.identifier == "shareUpPhoto" {
      let sharePhotoUpViewController: SharePhotoUpViewController = segue.destination as! SharePhotoUpViewController
      
      print("DEBUG_PRINT: sharePhotoUpViewControlelrが表示されました")
      
      // 選択したセルをindexPathで取得する
      let indexPath = shareCollectionView.indexPathsForSelectedItems
      // ndexPath型で取得した値をfor文でloopさせながら各要素を取得する
      for index in indexPath! {
        // 遷移先画面の変数に
        sharePhotoUpViewController.photoInformation = postArray[index.row]
      }
      
      print("DEBUG_PRINT: \(String(describing: sharePhotoUpViewController.photoInformation))")
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
