//
//  MorningPhotoViewController.swift
//  OneMore
//
//  Created by 池田優作 on 2018/05/08.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import UIKit
import RealmSwift
import SVProgressHUD
import FirebaseAuth

class MorningPhotoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  @IBOutlet weak var categoryCollectionView: UICollectionView!
  
  let realm = try! Realm()
  
  var morningArray = try! Realm().objects(Morning.self).sorted(byKeyPath: "id", ascending: false).filter("userName == %@", Auth.auth().currentUser?.displayName ?? "")
  
  var categoryXib: XibCategoryPhotoView!
  
  override func viewDidLoad() {
    
    // もしmorningArrayの数が0だったら遷移元の画面に戻る
    if morningArray.count == 0 {
      self.navigationController?.popViewController(animated: true)
    }
    print("DEBUG_PRINT: morningControllerが表示されました")
    print("DEBUG_PRINT: \(morningArray.count)")
    categoryCollectionView.delegate = self
    categoryCollectionView.dataSource = self
    
    categoryXib = XibCategoryPhotoView()
    categoryCollectionView.reloadData()
    
    // navigationBarのタイトルに朝を設定する
    navigationItem.title = "朝"
    
  }
  
  override func didReceiveMemoryWarning() {
  }
  
  override func viewWillAppear(_ animated: Bool) {
    categoryCollectionView.reloadData()
    print("DEBUG_PRINT: 画面を更新します")
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    print("DEBUG_PRINT: 数を返します")
    return morningArray.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "MorningCell", for: indexPath) as! MorningPhotoViewCell
    if morningArray.count == 0 {
      print("DEBUG_PRINT: morningArrayのデータが0です")
    } else if morningArray.count > 0 {
      print("DEBUG_PRINT: morningArrayのデータが0以上です")
      
      // for文でmorningArrayをloopさせ全ての要素を取り出す
      for morningArrayValue in morningArray {
        var image: UIImage
        image = UIImage(data: Data(base64Encoded: morningArrayValue.imageString, options: .ignoreUnknownCharacters)!)!
      
          cell.imageView.image = image
          print("DEBUG_PRINT: cellのイメージに値をセットしました。")
          print("DEBUG_PRINT: \(String(describing: cell.imageView.image))")
      }
    }
    return cell
  }

  // セルサイズの自動変更を設定する
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    let width: CGFloat = view.frame.width / 3 - 1   // self.viewを/3し、-1は隙間の部分
    let height: CGFloat = width
    
    return CGSize(width: width, height: height)
  }
  
  // 各セルを選択した時に実行されるメソッド
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    // セルがタップされた時はmorningSegue2で画面遷移をする
    performSegue(withIdentifier: "morningSegue2", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // 各セルをタップしてmorningSegue2で画面遷移をする時
    if segue.identifier == "morningSegue2" {
      let morningPhotoUpViewController: MorningPhototUpViewController = segue.destination as! MorningPhototUpViewController
      print("DEBUG_PRTNT: morningPhotoViewのセルがタップされました")
      // 選択した説をIndexPath型の配列で取得する
      let indexPath = categoryCollectionView.indexPathsForSelectedItems
      
      // IndexPath型で取得した値をfor文でloopさせながら各要素を取得する
      for index in indexPath! {
        // 遷移先画面の変数に
        morningPhotoUpViewController.photoInformation = morningArray[index.row]
      }
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

