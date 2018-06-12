//
//  ChestPhotoViewController.swift
//  OneMore
//
//  Created by 池田優作 on 2018/05/16.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseAuth

class ChestPhotoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  @IBOutlet weak var chestCollectionView: UICollectionView!
  
  let realm = try! Realm()
  
  var chestArray = try! Realm().objects(Chest.self).sorted(byKeyPath: "id", ascending: false).filter("userName == %@", Auth.auth().currentUser?.displayName ?? "")
  
  var categoryXib: XibCategoryPhotoView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      if chestArray.count == 0 {
        self.navigationController?.popViewController(animated: true)
      }
      print("DEBUG_PRINT: chestPhotoViewControllerが表示されました")
      print("DEBUG_PRINT: \(chestArray.count)")
      chestCollectionView.delegate = self
      chestCollectionView.dataSource = self
      categoryXib = XibCategoryPhotoView()
      chestCollectionView.reloadData()
      navigationItem.title = "大胸筋"
      
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  override func viewWillAppear(_ animated: Bool) {
    chestCollectionView.reloadData()
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return chestArray.count
  }
  
  var imageArray = [UIImage]()
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = chestCollectionView.dequeueReusableCell(withReuseIdentifier: "ChestCell", for: indexPath) as! ChestPhotoViewCell
   
      // for文でchestArrayをloopさせ全ての要素を取り出す
      for chestArrayValue in chestArray {
        var image: UIImage
        image = UIImage(data: Data(base64Encoded: chestArrayValue.imageString, options: .ignoreUnknownCharacters)!)!
        imageArray.append(image)
    }
    cell.imageView.image = imageArray[indexPath.row]
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
    // セルがタップされた時に実行されるメソッド
    performSegue(withIdentifier: "chestSegue2", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // 各セルをタップしてchestSegue2で画面遷移をする
    if segue.identifier == "chestSegue2" {
      let chestPhotoUpViewController: ChestPhotoUpViewController = segue.destination as! ChestPhotoUpViewController
      
      let indexPath = chestCollectionView.indexPathsForSelectedItems
      
      for index in indexPath! {
        chestPhotoUpViewController.photoInformation = chestArray[index.row]
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
