//
//  PostData.swift
//  OneMore
//
//  Created by 池田優作 on 2018/03/22.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//
// このクラスで投稿時のデータを扱う

import UIKit
import Firebase
import FirebaseDatabase

class PostData: NSObject {
  var id: String?
  var image: UIImage?
  var imageString: String?
  var name: String?
  var caption: String?
  var date: Date?
  var likes: [String] = []
  var isLiked: Bool = false
  var commentList: [String] = []
  
  
  // Firebaseはデータの追加や更新があるとDataSnapshotクラスのデータが渡される。keyプロパティがこの要素自身のIDとなる。そしてvalueプロパティにデータが入っている。valueプロパティはキーと値の組み合わせで、辞書型となっている。キーはStringなので、valueDictionary["name"]などで値を取り出す。
  init(snapshot: DataSnapshot, myId: String) {
    // 自身のidにsnapshotのkeyを指定する
    self.id = snapshot.key
    
    // 定数valueDictionryを辞書型で宣言する
    let valueDictionary = snapshot.value as! [String: Any]
    
    // imageStringにvalueDictionaryの["image"]で値を取り出したものを代入する
    // 各変数にPostViewControllerで保存した値を辞書型で取り出す
    imageString = valueDictionary["image"] as? String
    image = UIImage(data: Data(base64Encoded: imageString!, options: .ignoreUnknownCharacters)!)
    
    self.name = valueDictionary["name"] as? String
    
    self.caption = valueDictionary["caption"] as? String
    
    let time = valueDictionary["time"] as? String
    self.date = Date(timeIntervalSinceReferenceDate: TimeInterval(time!)!)
    
    // likesと同じ要領でcommentListも作成する
    if let commentList = valueDictionary["commentList"] as? [String] {
      self.commentList = commentList
    }
    
    // もしlikesに配列としてlikeとして取り出した際に値があった場合、このPostDataクラスで宣言したlikesというString型の配列にlikesを格納する
    if let likes = valueDictionary["likes"] as? [String] {
      self.likes = likes
    }
    
    // for文でlikesの中にliked
    for likeId in self.likes {
      if likeId == myId {
        self.isLiked = true
        break
      }
    }
  }
}
