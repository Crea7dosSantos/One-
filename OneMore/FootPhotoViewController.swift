//
//  FootPhotoViewController.swift
//  OneMore
//
//  Created by 池田優作 on 2018/05/25.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseAuth

class FootPhotoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  @IBOutlet weak var footCollectionView: UICollectionView!
  
  let realm = try! Realm()
  
  var footArray = try! Realm().objects(Foot.self).sorted(byKeyPath: "id", ascending: false).filter("userName == %@", Auth.auth().currentUser?.displayName ?? "")
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      // もしassArrayの数が0だったら遷移先の画面に戻る
      if footArray.count == 0 {
        self.navigationController?.popViewController(animated: true)
      }
      print("DEBUG_PRINT: AssPhotoViewControllerが表示されました")
      print("DEBUG_PRINT: \(footArray.count)")
      footCollectionView.delegate = self
      footCollectionView.dataSource = self
      footCollectionView.reloadData()
      
      navigationItem.title = "ハムストリング"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  override func viewWillAppear(_ animated: Bool) {
    footCollectionView.reloadData()
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return footArray.count
  }
  
  var imageArray = [UIImage]()
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = footCollectionView.dequeueReusableCell(withReuseIdentifier: "footCell", for: indexPath) as! FootPhotoViewCell
    
    // for文でassArrayをloopさせ全ての要素を取り出す
    for footArrayValue in footArray {
      var image: UIImage
      image = UIImage(data: Data(base64Encoded: footArrayValue.imageString, options: .ignoreUnknownCharacters)!)!
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
    // セルがタップされた時はfootSegue2で画面遷移をする
    performSegue(withIdentifier: "footSegue2", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // 各セルをタップしてfootSegueで画面遷移をする
    if segue.identifier == "footSegue" {
      let footPhotoUpViewController: FootPhotoUpViewController = segue.destination as! FootPhotoUpViewController
      
      let indexPath = footCollectionView.indexPathsForSelectedItems
      
      for index in indexPath! {
        footPhotoUpViewController.photoInformation = footArray[index.row]
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
