//
//  NightPhotoViewController.swift
//  OneMore
//
//  Created by 池田優作 on 2018/05/16.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseAuth

class NightPhotoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  @IBOutlet weak var nightCollectionView: UICollectionView!
  
  let realm = try! Realm()
  
  var nightArray = try! Realm().objects(Night.self).sorted(byKeyPath: "id", ascending: false).filter("userName == %@", Auth.auth().currentUser?.displayName ?? "")
  
  var categoryXib: XibCategoryPhotoView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      // もしnightArrayの数が0だったら遷移先の画面に戻る
      if nightArray.count == 0 {
        self.navigationController?.popViewController(animated: true)
      }
      print("DEBUG_PRINT: nightPhotoViewControllerが表示されました")
      print("DEBUG_PRINT: \(nightArray.count)")
      nightCollectionView.delegate = self
      nightCollectionView.dataSource = self
      categoryXib = XibCategoryPhotoView()
      nightCollectionView.reloadData()
      navigationItem.title = "夜"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  override func viewWillAppear(_ animated: Bool) {
    nightCollectionView.reloadData()
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return nightArray.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = nightCollectionView.dequeueReusableCell(withReuseIdentifier: "NightCell", for: indexPath) as! NightPhotoViewCell
    if nightArray.count == 0 {
      print("DEBUG_PRINT: nightArrayのデータが0です")
    } else if nightArray.count > 0 {
      print("DEBUG_PRINT: nightArrayのデータが0以上です")
      
      // for文でnightArrayをloopさせ全ての要素を取り出す
      for nightArrayValue in nightArray {
        var image: UIImage?
        image = UIImage(data: Data(base64Encoded: nightArrayValue.imageString, options: .ignoreUnknownCharacters)!)!
        cell.imageView.image = image
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
    // セルがタップされた時はnightSegue2で画面遷移をする
    performSegue(withIdentifier: "nightSegue2", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // 各セルをタップしてnightSegue2で画面遷移をする
    if segue.identifier == "nightSegue2" {
      let nightPhotoUpViewController: NightPhotoUpViewController = segue.destination as! NightPhotoUpViewController
      
      let indexPath = nightCollectionView.indexPathsForSelectedItems
      
      for index in indexPath! {
        nightPhotoUpViewController.photoInformation = nightArray[index.row]
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
