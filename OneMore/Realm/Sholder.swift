//
//  Sholder.swift
//  OneMore
//
//  Created by 池田優作 on 2018/03/22.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import RealmSwift

class Sholder: Object {
  // 管理用 ID。プライマリーキー
  @objc dynamic var id = 0
  
  // 投稿ID
  @objc dynamic var postID = ""
  
  // UserName
  @objc dynamic var userName = ""
  
  // ImageString
  @objc dynamic var imageString = ""
  
  // caption
  @objc dynamic var caption = ""
  
  // date
  @objc dynamic var time = Date()
  

  override static func primaryKey() -> String? {
    return "id"
  }
}
