//
//  LegPhotoViewController.swift
//  OneMore
//
//  Created by 池田優作 on 2018/05/16.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseAuth

class LegPhotoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  @IBOutlet weak var legCollectionView: UICollectionView!
  
  let realm = try! Realm()
  var legArray = try! Realm().objects(Leg.self).sorted(byKeyPath: "id", ascending: false).filter("userName == %@", Auth.auth().currentUser?.displayName ?? "")
  var categoryXib: XibCategoryPhotoView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      // もしlegArrayの数が0だったら遷移先の画面に戻る
      if legArray.count == 0 {
        self.navigationController?.popViewController(animated: true)
      }
      print("DEBUG_PRINT: legPhotoViewControllerが表示されました")
      print("DEBUG_PRINT: \(legArray.count)")
      legCollectionView.delegate = self
      legCollectionView.dataSource = self
      categoryXib = XibCategoryPhotoView()
      legCollectionView.reloadData()
      navigationItem.title = "大腿四頭筋"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  override func viewWillAppear(_ animated: Bool) {
    legCollectionView.reloadData()
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return legArray.count
  }
  
  var imageArray = [UIImage]()
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = legCollectionView.dequeueReusableCell(withReuseIdentifier: "LegCell", for: indexPath) as! LegPhotoViewCell
    
      // for文でlegArrayをloopさせ全ての要素を取り出す
      for legArrayValue in legArray {
        var image: UIImage
        image = UIImage(data: Data(base64Encoded: legArrayValue.imageString, options: .ignoreUnknownCharacters)!)!
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
    // セルがタップされた時はlegSegue2で画面遷移をする
    performSegue(withIdentifier: "legSegue2", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // 各セルをタップした時legSegue2で画面遷移をする
    if segue.identifier == "legSegue2" {
      let legPhotoUpViewController: LegPhotoUpViewController = segue.destination as! LegPhotoUpViewController
      let indexPath = legCollectionView.indexPathsForSelectedItems
      
      for index in indexPath! {
        legPhotoUpViewController.photoInformation = legArray[index.row]
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
