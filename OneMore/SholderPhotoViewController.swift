//
//  SholderPhotoViewController.swift
//  OneMore
//
//  Created by 池田優作 on 2018/05/16.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseAuth

class SholderPhotoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  @IBOutlet weak var sholderCollectionView: UICollectionView!
  
  let realm = try! Realm()
  var sholderArray = try! Realm().objects(Sholder.self).sorted(byKeyPath: "id", ascending: false).filter("userName == %@", Auth.auth().currentUser?.displayName ?? "")
  var categoryXib: XibCategoryPhotoView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      // もしsholderArrayの数が0だったら遷移先の画面に戻る
      if sholderArray.count == 0 {
        self.navigationController?.popViewController(animated: true)
      }
      print("DEBUG_PRINT: sholderPhotoViewControllerが表示されました")
      print("DEBUG_PRINT: \(sholderArray.count)")
      sholderCollectionView.delegate = self
      sholderCollectionView.dataSource = self
      categoryXib = XibCategoryPhotoView()
      sholderCollectionView.reloadData()
      navigationItem.title = "三角筋"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  override func viewWillAppear(_ animated: Bool) {
    sholderCollectionView.reloadData()
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return sholderArray.count
  }
  
  var imageArray = [UIImage]()
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = sholderCollectionView.dequeueReusableCell(withReuseIdentifier: "SholderCell", for: indexPath) as! SholderPhotoViewCell
    
      // for文でabsArrayをloopさせ全ての要素を取り出す
      for sholderArrayValue in sholderArray {
        var image: UIImage
        image = UIImage(data: Data(base64Encoded: sholderArrayValue.imageString, options: .ignoreUnknownCharacters)!)!
        imageArray.append(image)
    }
    cell.imageView.image = imageArray[indexPath.row]
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
    // セルがタップされた時はsholderSegue2で画面遷移をする
    performSegue(withIdentifier: "sholderSegue2", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // 各セルをタップした時sholderSegue2で画面遷移をする
    if segue.identifier == "sholderSegue2" {
      let sholderPhotoUpViewController: SholderPhotoUpViewController = segue.destination as! SholderPhotoUpViewController
      let indexPath = sholderCollectionView.indexPathsForSelectedItems
      
      for index in indexPath! {
        sholderPhotoUpViewController.photoInformation = sholderArray[index.row]
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
