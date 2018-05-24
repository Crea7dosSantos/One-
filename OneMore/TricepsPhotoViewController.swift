//
//  TricepsPhotoViewController.swift
//  OneMore
//
//  Created by 池田優作 on 2018/05/16.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseAuth

class TricepsPhotoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  @IBOutlet weak var tricepsCollectionView: UICollectionView!
  
  let realm = try! Realm()
  var tricepsArray = try! Realm().objects(Triceps.self).sorted(byKeyPath: "id", ascending: false).filter("userName == %@", Auth.auth().currentUser?.displayName ?? "")
  var categoryXib: XibCategoryPhotoView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      // もしtricepsArrayの数が0だったら遷移先の画面に戻る
      if tricepsArray.count == 0 {
        self.navigationController?.popViewController(animated: true)
      }
      print("DEBUG_PRINT: tricepsPhotoViewControllerが表示されました")
      print("DEBUG_PRINT: \(tricepsArray.count)")
      tricepsCollectionView.delegate = self
      tricepsCollectionView.dataSource = self
      categoryXib = XibCategoryPhotoView()
      tricepsCollectionView.reloadData()
      navigationItem.title = "上腕三頭筋"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  override func viewWillAppear(_ animated: Bool) {
    tricepsCollectionView.reloadData()
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return tricepsArray.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = tricepsCollectionView.dequeueReusableCell(withReuseIdentifier: "TricepsCell", for: indexPath) as! TricepsPhotoViewCell
    if tricepsArray.count == 0 {
      print("DEBUG_PRINT: tricepsArrayのデータが0です")
    } else if tricepsArray.count > 0 {
      print("DEBUG_PRINT: tricepsArrayのデータが0以上です")
      
      // for文でtricepsArrayをloopさせ全ての要素を取り出す
      for tricepsArrayValue in tricepsArray {
        var image: UIImage
        image = UIImage(data: Data(base64Encoded: tricepsArrayValue.imageString, options: .ignoreUnknownCharacters)!)!
        cell.imageView.image = image
      }
    }
    return cell
  }
  
  // セルサイズの自動調整を行う
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    let width: CGFloat = view.frame.width / 3 - 1   // self.viewを/3し、-1は隙間の部分
    let height: CGFloat = width
    
    return CGSize(width: width, height: height)
  }
  
  // 各セルを選択した時に実行されるメソッド
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    // セルがタップされた時はtricepsSegue2で画面遷移をする
    performSegue(withIdentifier: "tricepsSegue2", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // 各セルをタップしてtricepsSegue2で画面遷移をする
    if segue.identifier == "tricepsSegue2" {
      let tricepsPhotoUpViewController: TricepsPhotoUpViewController = segue.destination as! TricepsPhotoUpViewController
      let indexPath = tricepsCollectionView.indexPathsForSelectedItems
      
      for index in indexPath! {
        tricepsPhotoUpViewController.photoInformation = tricepsArray[index.row]
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
