//
//  All.swift
//  OneMore
//
//  Created by 池田優作 on 2018/05/20.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import RealmSwift

class All: Object {
  // 管理用 ID。 プライマリーキー
  @objc dynamic var id = 0
  
  // 投稿ID
  @objc dynamic var postId = ""
  
  // userName
  @objc dynamic var userName = ""
  
  // imageString
  @objc dynamic var imageString: String = ""
  
  // caption
  @objc dynamic var caption = ""
  
  // date
  @objc dynamic var time = Date()
  
  override static func primaryKey() -> String? {
    return "id"
  }

}
