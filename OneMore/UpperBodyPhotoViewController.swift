//
//  UpperBodyPhotoViewController.swift
//  OneMore
//
//  Created by 池田優作 on 2018/05/16.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseAuth

class UpperBodyPhotoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  @IBOutlet weak var upperBodyCollectionView: UICollectionView!
  
  let realm = try! Realm()
  var upperBodyArray = try! Realm().objects(UpperBody.self).sorted(byKeyPath: "id", ascending: false).filter("userName == %@", Auth.auth().currentUser?.displayName ?? "")
  
  var categoryXib: XibCategoryPhotoView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      // もしupperBodyArrayの数が0だったら遷移先の画面に戻る
      if upperBodyArray.count == 0 {
        self.navigationController?.popViewController(animated: true)
      }
      print("DEBUG_PRINT: upperBodyPhotoViewControllerが表示されました")
      print("DEBUG_PRINT: \(upperBodyArray.count)")
      upperBodyCollectionView.delegate = self
      upperBodyCollectionView.dataSource = self
      categoryXib = XibCategoryPhotoView()
      upperBodyCollectionView.reloadData()
      navigationItem.title = "上半身"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  override func viewWillAppear(_ animated: Bool) {
    upperBodyCollectionView.reloadData()
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return upperBodyArray.count
  }
  
  var imageArray = [UIImage]()
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = upperBodyCollectionView.dequeueReusableCell(withReuseIdentifier: "UpperBodyCell", for: indexPath) as! UpperBodyPhotoViewCell
    
      // for文でupperBodyArrayをloopさせ全ての要素を取り出す
      for upperBodyArrayValue in upperBodyArray {
        var image: UIImage
        image = UIImage(data: Data(base64Encoded: upperBodyArrayValue.imageString, options: .ignoreUnknownCharacters)!)!
        imageArray.append(image)
      }
    cell.imageView.image = imageArray[indexPath.row]
    return cell
  }
  
  // セルサイズの自動更新を設定する
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    let width: CGFloat = view.frame.width / 3 - 1   // self.viewを/3し、-1は隙間の部分
    let height: CGFloat = width
    
    return CGSize(width: width, height: height)
  }
  
  // 各セルを選択した時に実行されるメソッド
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    // セルがタップされた時はupperBodySegue2で画面線をする
    performSegue(withIdentifier: "upperBodySegue2", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // 各セルをタップしてupperBodySegue2で画面遷移をする
    if segue.identifier == "upperBodySegue2" {
      let upperBodyPhotoUpViewController: UpperBodyPhotoUpViewController = segue.destination as! UpperBodyPhotoUpViewController
      
      let indexPath = upperBodyCollectionView.indexPathsForSelectedItems
      
      for index in indexPath! {
        upperBodyPhotoUpViewController.photoInformation = upperBodyArray[index.row]
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
