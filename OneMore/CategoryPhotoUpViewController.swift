//
//  CategoryPhotoUpViewController.swift
//  OneMore
//
//  Created by 池田優作 on 2018/05/08.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryPhotoUpViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  @IBOutlet weak var categoryCollectionView: UICollectionView!
  
  let realm = try! Realm()
  
  var morningArray = try! Realm().objects(Morning.self).sorted(byKeyPath: "id", ascending: false)
  
  override func viewDidLoad() {
    categoryCollectionView.delegate = self
    categoryCollectionView.dataSource = self
  }
  
  override func didReceiveMemoryWarning() {
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return morningArray.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell2", for: indexPath) as! CategoryCollectionViewCell
    
    for morningArrayValue in morningArray {
      for imageStringer in morningArrayValue.imageString {
        var image: UIImage?
        image = UIImage(data: Data(base64Encoded: imageStringer, options: .ignoreUnknownCharacters)!)
        cell.imageView.image = image!
      }
    }
    return cell
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


