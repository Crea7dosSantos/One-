//
//  CalfPhotoViewController.swift
//  OneMore
//
//  Created by 池田優作 on 2018/05/16.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseAuth

class CalfPhotoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  @IBOutlet weak var calfCollectionView: UICollectionView!
  
  let realm = try! Realm()
  var calfArray = try! Realm().objects(Calf.self).sorted(byKeyPath: "id", ascending: false).filter("userName == %@", Auth.auth().currentUser?.displayName ?? "")
  var categoryXib: XibCategoryPhotoView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      // もしcalfArrayの数が0だったら遷移先の画面に戻る
      if calfArray.count == 0 {
        self.navigationController?.popViewController(animated: true)
      }
      print("DEBUG_PRINT: calfPhotoViewControllerが表示されました")
      print("DEBUG_PRINT: \(calfArray.count)")
      calfCollectionView.delegate = self
      calfCollectionView.dataSource = self
      categoryXib = XibCategoryPhotoView()
      calfCollectionView.reloadData()
      navigationItem.title = "ヒラメ筋"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  override func viewWillAppear(_ animated: Bool) {
    calfCollectionView.reloadData()
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return calfArray.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = calfCollectionView.dequeueReusableCell(withReuseIdentifier: "CalfCell", for: indexPath) as! CalfPhotoViewCell
    if calfArray.count == 0 {
      print("DEBUG_PRINT: calfArrayのデータが0です")
    } else if calfArray.count > 0 {
      print("DEBUG_PRINT: calfArrayのデータが0以上です")
      // for文でcalfArrayをloopさせ全ての要素を取り出す
      for calfArrayValue in calfArray {
        var image: UIImage
        image = UIImage(data: Data(base64Encoded: calfArrayValue.imageString, options: .ignoreUnknownCharacters)!)!
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
    // セルがタップされた時はcalfSegue2で画面遷移をする
    performSegue(withIdentifier: "calfSegue2", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // 各セルをタップした時calfSegue2で画面遷移をする
    if segue.identifier == "calfSegue2" {
      let calfPhotoUpViewController: CalfPhotoUpViewController = segue.destination as! CalfPhotoUpViewController
      let indexPath = calfCollectionView.indexPathsForSelectedItems
      
      for index in indexPath! {
        calfPhotoUpViewController.photoInformation = calfArray[index.row]
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
