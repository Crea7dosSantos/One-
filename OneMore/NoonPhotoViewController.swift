//
//  NoonPhotoViewController.swift
//  OneMore
//
//  Created by 池田優作 on 2018/05/16.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseAuth

class NoonPhotoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  @IBOutlet weak var noonCollectionView: UICollectionView!
  
  let realm = try! Realm()
  
  var noonArray = try! Realm().objects(Noon.self).sorted(byKeyPath: "id", ascending: false).filter("userName == %@", Auth.auth().currentUser?.displayName ?? "")
  
  var cateogoryXid: XibCategoryPhotoView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      // もしnoonArrayの数が0だったら遷移先の画面に戻る
      if noonArray.count == 0 {
        self.navigationController?.popViewController(animated: true)
      }
      print("DEBUG_PRINT: noonPhotoViewControllerが表示されました")
      print("DEBUG_PRINT: \(noonArray.count)")
      noonCollectionView.delegate = self
      noonCollectionView.dataSource = self
      cateogoryXid = XibCategoryPhotoView()
      noonCollectionView.reloadData()
      
      navigationItem.title = "昼"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  override func viewWillAppear(_ animated: Bool) {
    noonCollectionView.reloadData()
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return noonArray.count
  }
  
  var imageArray = [UIImage]()
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = noonCollectionView.dequeueReusableCell(withReuseIdentifier: "NoonCell", for: indexPath) as! NoonPhotoViewCell

      // for文でnoonArrayをloopさせ全ての要素を取り出す
      for noonArrayValue in noonArray {
        var image: UIImage
        image = UIImage(data: Data(base64Encoded: noonArrayValue.imageString, options: .ignoreUnknownCharacters)!)!
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
    // セルがタップされた時はmorningSegue2で画面遷移をする
    performSegue(withIdentifier: "noonSegue2", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // 各セルをタップしてnoonSegue2で画面遷移をする
    if segue.identifier == "noonSegue2" {
      let noonPhotoUpViewController: NoonPhotoUpViewController = segue.destination as! NoonPhotoUpViewController
      
      let indexPath = noonCollectionView.indexPathsForSelectedItems
      
      for index in indexPath! {
        noonPhotoUpViewController.photoInformation = noonArray[index.row]
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
