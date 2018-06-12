//
//  BackPhotoViewController.swift
//  OneMore
//
//  Created by 池田優作 on 2018/05/16.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseAuth

class BackPhotoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  @IBOutlet weak var backCollectionView: UICollectionView!
  
  let realm = try! Realm()
  var backArray = try! Realm().objects(Back.self).sorted(byKeyPath: "id", ascending: false).filter("userName == %@", Auth.auth().currentUser?.displayName ?? "")
  var categoryXib: XibCategoryPhotoView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      // もしbackArrayの数が0だったら遷移先の画面に戻る
      if backArray.count == 0 {
        self.navigationController?.popViewController(animated: true)
      }
      print("DEBUG_PRINT: backPhotoViewControllerが表示されました")
      print("DEBUG_PRINT: \(backArray.count)")
      backCollectionView.delegate = self
      backCollectionView.dataSource = self
      categoryXib = XibCategoryPhotoView()
      backCollectionView.reloadData()
      navigationItem.title = "広背筋"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  override func viewWillAppear(_ animated: Bool) {
    backCollectionView.reloadData()
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return backArray.count
  }
  
  var imageArray = [UIImage]()
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = backCollectionView.dequeueReusableCell(withReuseIdentifier: "BackCell", for: indexPath) as! BackPhotoViewCell
    
      // for文でbackArrayをloopさせ全ての要素を取り出す
      for backArrayValue in backArray {
        var image: UIImage
        image = UIImage(data: Data(base64Encoded: backArrayValue.imageString, options: .ignoreUnknownCharacters)!)!
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
    // セルがタップされた時はbackSegue2で画面遷移をする
    performSegue(withIdentifier: "backSegue2", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // 各セルをタップしてbackSegue2で画面遷移をする
    if segue.identifier == "backSegue2" {
      let backPhotoUpViewController: BackPhotoUpViewController = segue.destination as! BackPhotoUpViewController
      let indexPath = backCollectionView.indexPathsForSelectedItems
      
      for index in indexPath! {
        backPhotoUpViewController.photoInformation = backArray[index.row]
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
