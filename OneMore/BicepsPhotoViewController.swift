//
//  BicepsPhotoViewController.swift
//  OneMore
//
//  Created by 池田優作 on 2018/05/16.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseAuth

class BicepsPhotoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  @IBOutlet weak var bicepsCollectionView: UICollectionView!
  
  let realm = try! Realm()
  var bicepsArray = try! Realm().objects(Biceps.self).sorted(byKeyPath: "id", ascending: false).filter("userName == %@", Auth.auth().currentUser?.displayName ?? "")
  var categoryXib: XibCategoryPhotoView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      // もしbicepsArrayの数が0だったら遷移先の画面に戻る
      if bicepsArray.count == 0 {
        self.navigationController?.popViewController(animated: true)
      }
      print("DEBUG_PRINT: bicepsPhotoViewControllerが表示されました")
      print("DEBUG_PRINT: \(bicepsArray.count)")
      bicepsCollectionView.delegate = self
      bicepsCollectionView.dataSource = self
      categoryXib = XibCategoryPhotoView()
      bicepsCollectionView.reloadData()
      navigationItem.title = "上腕二頭筋"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  override func viewWillAppear(_ animated: Bool) {
    bicepsCollectionView.reloadData()
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return bicepsArray.count
  }
  
  var imageArrray = [UIImage]()
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = bicepsCollectionView.dequeueReusableCell(withReuseIdentifier: "BicepsCell", for: indexPath) as! BicepsPhotoViewCell
      
      // for文でbicepsArrayをloopさせ全ての要素を取り出す
      for bicepsArrayValue in bicepsArray {
        var image: UIImage
        image = UIImage(data: Data(base64Encoded: bicepsArrayValue.imageString, options: .ignoreUnknownCharacters)!)!
        imageArrray.append(image)
      }
   cell.imageView.image = imageArrray[indexPath.row]
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
    // セルがタップされた時はbicepsSegue2で画面遷移をする
    performSegue(withIdentifier: "bicepsSegue2", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // 各セルをタップしてbicepsSegue2で画面遷移をする
    if segue.identifier == "bicepsSegue2" {
      let bicepsPhotoUpViewController: BicepsPhotoUpViewController = segue.destination as! BicepsPhotoUpViewController
      let indexPath = bicepsCollectionView.indexPathsForSelectedItems
      
      for index in indexPath! {
        bicepsPhotoUpViewController.photoInformation = bicepsArray[index.row]
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
