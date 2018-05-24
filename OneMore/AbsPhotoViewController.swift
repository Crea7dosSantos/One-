//
//  AbsPhotoViewController.swift
//  OneMore
//
//  Created by 池田優作 on 2018/05/16.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseAuth

class AbsPhotoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  @IBOutlet weak var absCollectionView: UICollectionView!
  
  let realm = try! Realm()
  var absArray = try! Realm().objects(Abs.self).sorted(byKeyPath: "id", ascending: false)
  var categoryXib: XibCategoryPhotoView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      // もしabsArrayの数が0だったら遷移先の画面に戻る
      if absArray.count == 0 {
        self.navigationController?.popViewController(animated: true)
      }
      print("DEBUG_PRINT: absPhotoViewControllerが表示されました")
      print("DEBUG_PRINT: \(absArray.count)")
      absCollectionView.delegate = self
      absCollectionView.dataSource = self
      categoryXib = XibCategoryPhotoView()
      absCollectionView.reloadData()
      navigationItem.title = "腹筋"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  override func viewWillAppear(_ animated: Bool) {
    absCollectionView.reloadData()
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return absArray.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = absCollectionView.dequeueReusableCell(withReuseIdentifier: "AbsCell", for: indexPath) as! AbsPhotoViewCell
    if absArray.count == 0 {
      print("DEBUG_PRINT: absArrayのデータが0です")
    } else if absArray.count > 0 {
      print("DEBUG_PRINT: absArrayのデータが0以上です")
    // for文でabsArrayをloopさせ全ての要素を取り出す
    for absArrayValue in absArray {
      var image: UIImage
      image = UIImage(data: Data(base64Encoded: absArrayValue.imageString, options: .ignoreUnknownCharacters)!)!
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
    // セルがタップされた時はabsSegue2で画面遷移をする
    performSegue(withIdentifier: "absSegue2", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // 各セルをタップした時absSegue2で画面遷移をする
    if segue.identifier == "absSegue2" {
      let absPhotoUpViewController: AbsPhotoUpViewController = segue.destination as! AbsPhotoUpViewController
      let indexPath = absCollectionView.indexPathsForSelectedItems
      
      for index in indexPath! {
        absPhotoUpViewController.photoInformation = absArray[index.row]
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
