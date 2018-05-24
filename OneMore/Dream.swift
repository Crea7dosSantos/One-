//
//  Dream.swift
//  OneMore
//
//  Created by 池田優作 on 2018/05/19.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class Dream: NSObject {
  var id: String?
  var dream: String?
  
  init(snapshot: DataSnapshot, myId: String) {
    self.id = snapshot.key
    
    let valueDictionary = snapshot.value as! [String:Any]
    
    // Dreamの変数dreamにFirebase上のtextsに保存された文字列を辞書型で取得し、格納する
    dream = valueDictionary["texts"] as? String
  }

}
