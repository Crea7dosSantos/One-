//
//  PostViewController.swift
//  OneMore
//
//  Created by 池田優作 on 2018/03/05.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SVProgressHUD
import RealmSwift
import GoogleMobileAds

class PostViewController: UIViewController, UITextViewDelegate, GADInterstitialDelegate {
  var image: UIImage!

  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var textField: UITextView!
  @IBOutlet weak var hiddenLabel: UILabel!
  @IBOutlet weak var morningSwitch: UISwitch!
  @IBOutlet weak var noonSwitch: UISwitch!
  @IBOutlet weak var nightSwitch: UISwitch!
  @IBOutlet weak var upperBodySwitch: UISwitch!
  @IBOutlet weak var lowerBodySwitch: UISwitch!
  @IBOutlet weak var chestSwitch: UISwitch!
  @IBOutlet weak var backSwitch: UISwitch!
  @IBOutlet weak var absSwitch: UISwitch!
  @IBOutlet weak var bicepsSwitch: UISwitch!
  @IBOutlet weak var tricepsSwitch: UISwitch!
  @IBOutlet weak var sholderSwitch: UISwitch!
  @IBOutlet weak var legSwitch: UISwitch!
  @IBOutlet weak var footSwitch: UISwitch!
  @IBOutlet weak var assSwitch: UISwitch!
  @IBOutlet weak var calfSwitch: UISwitch!
  @IBOutlet weak var timeBorderView: UIView!
  @IBOutlet weak var muscleBorderView: UIView!
  
  // Realmのインスタンスを作成する
  // このインスタンスを使用し読み書きのメソッドを呼び出す
  let realm = try! Realm()
  
  let user = Auth.auth().currentUser
 
  var interstitial: GADInterstitial!
  
  @IBAction func handlePostButton(_ sender: Any) {
    print("DEBUG_PRINT: 完了ボタンがタップされました")
      
    // ImageViewから画像を取得する
    // UIImageJPEGRepresentationメソッドでJPEG形式のDataクラスに変換する
    let imageData = UIImageJPEGRepresentation(imageView.image!, 0.5)
    // Dataクラスのbase64EncoeedString(options:)メソッドの引数に.lineLength64Charactersを与えてBase64方式でテキスト形式に変換する
    let imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
    
    // postDataに必要な情報を取得しておく
    // timeIntervalSinceReferenceDataプロパティで投稿の日時を代入する
    let time = Date.timeIntervalSinceReferenceDate
    // 表示名を現在ログインしているUserのdisplayNameプロパティから取得する
    let name = Auth.auth().currentUser?.displayName
    
    // 公開ボタンをタップした時に動作する
    let alertView: UIAlertController = UIAlertController(title: "この投稿を公開しますか？", message: "公開をタップするとこの投稿は公開され、非公開をタップすると公開はされません。", preferredStyle: UIAlertControllerStyle.alert)
    
    let share = UIAlertAction(title: "公開", style: .default) { (action: UIAlertAction) in
    
    // 辞書を作成してFirebaseに保存する
    // postRefを使用してFirebaseサーバ上にある保存先に代入しておく
    // このpostRefを使用して画像やキャプションをDatabaseへ保存する
    // OneMoreのDatabase上にchildメソッドで値を格納するConst.PostPathの場所を格納する
    let postRef = Database.database().reference().child(Const.PostPath)
    // 保存したい値を辞書を作成し、PostDataクラスの変数名に値を格納する
      let postData = ["caption": self.textField.text!, "image": imageString, "time": String(time), "name": name!] 
    // setValue(_:)メソッドでFirebaseに保存した後はHUDで投稿完了をユーザーに伝える。
    postRef.childByAutoId().setValue(postData)
      
      // HUDで投稿完了を表示する
      SVProgressHUD.showSuccess(withStatus: "投稿しました")
      
      // 全てのモーダルを閉じる
      // この時、画像選択画面、画像加工画面、この投稿画面と、3つの画面がモーダルで画面遷移しているため、全てを閉じる必要が出てきます。以下の記述で全てのモーダルを閉じて先頭の画面に戻ることができる。
      UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
    
    // 投稿ボタンをタップした時に各Switchの状態を保存し、各Switchがtrueの状態の時に各Realmファイルに保存をする
    
    // Allファイルにデータを保存する
    let all = All()
    
      let allArray = self.realm.objects(All.self)
    // もしもallArrayのcountプロパティが0じゃなかったら
    if allArray.count != 0 {
      all.id = allArray.max(ofProperty: "id")! + 1
    }
      try! self.realm.write {
      // 投稿された全てのデータをこのAllに保存する
      all.caption = self.textField.text!
      all.userName = (Auth.auth().currentUser?.displayName!)!
      all.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
      // 日付の値を取得する
      all.time = Date()
        self.realm.add(all, update: true)
    }
    
    // もしもMorningSwitchがtrueだったら
    if self.morningSwitch.isOn == true {
      let morning = Morning()

      let morningArray = self.realm.objects(Morning.self)
      // もしもmorningArrayのcountプロパティが0じゃなかったら
      if morningArray.count != 0 {
        morning.id = morningArray.max(ofProperty: "id")! + 1
      }
      try! self.realm.write {
        // タグmorningに投稿情報が保存される時
        morning.caption = self.textField.text!
        morning.userName = (Auth.auth().currentUser?.displayName!)!
        morning.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
        // 日付の値を取得する
        morning.time = Date()
        self.realm.add(morning, update: true)
      }
    }
    
    // もしもNoonSwitchがtrueだったら
      if self.noonSwitch.isOn == true {
      let noon = Noon()
  
        let noonArray = self.realm.objects(Noon.self)
      // もしもnoonArrayのcountプロパティが0じゃなかったら
      if noonArray.count != 0 {
        noon.id = noonArray.max(ofProperty: "id")! + 1
      }
        try! self.realm.write {
        // タグnoonに投稿情報が保存される時
        noon.caption = self.textField.text!
        noon.userName = (Auth.auth().currentUser?.displayName!)!
        noon.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
        // 日付の値を取得する
        noon.time = Date()
          self.realm.add(noon, update: true)
      }
    }
    
    // もしもNightSwitchがtrueだったら
      if self.nightSwitch.isOn == true {
      let night = Night()
      
        let nightArray = self.realm.objects(Night.self)
      // もしもnightArrayのcountプロパティが0じゃなかったら
      if nightArray.count != 0 {
        night.id = nightArray.max(ofProperty: "id")! + 1
      }
        try! self.realm.write {
        // タグnightに投稿情報が保存される時
        night.caption = self.textField.text!
        night.userName = (Auth.auth().currentUser?.displayName!)!
        night.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
        // 日付の値を取得する
        night.time = Date()
          self.realm.add(night, update: true)
      }
    }
    
    // もしもupperBodySwitchがtrueだったら
      if self.upperBodySwitch.isOn == true {
      let upperBody = UpperBody()
      
        let upperBodyArray = self.realm.objects(UpperBody.self)
      // もしもupperBodyのcountプロパティが0じゃなかったら
      if upperBodyArray.count != 0 {
        upperBody.id = upperBodyArray.max(ofProperty: "id")! + 1
      }
        try! self.realm.write {
        // タグupperBodyに投稿情報が保存される時
        upperBody.caption = self.textField.text!
        upperBody.userName = (Auth.auth().currentUser?.displayName!)!
        upperBody.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
        // 日付の値を取得する
        upperBody.time = Date()
          self.realm.add(upperBody, update: true)
      }
    }
    
    // もしもlowerBodySwitchがtrueだったら
      if self.lowerBodySwitch.isOn == true {
      let lowerBody = LowerBody()
      
        let LowerBodyArray = self.realm.objects(LowerBody.self)
      // もしもlowerBodyのcountプロパティが0じゃなかったら
      if LowerBodyArray.count != 0 {
        lowerBody.id = LowerBodyArray.max(ofProperty: "id")! + 1
      }
        try! self.realm.write {
        // タグlowerBodyに投稿情報が保存される時
        lowerBody.caption = self.textField.text!
        lowerBody.userName = (Auth.auth().currentUser?.displayName!)!
        lowerBody.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
        // 日付の値を取得する
        lowerBody.time = Date()
          self.realm.add(lowerBody, update: true)
      }
    }
    
    // もしもchestSwitchがtrueだったら
      if self.chestSwitch.isOn == true {
      let chest = Chest()
      
        let chestArray = self.realm.objects(Chest.self)
      // もしもchestArrayのCountプロパティが0じゃなかったら
      if chestArray.count != 0 {
        chest.id = chestArray.max(ofProperty: "id")! + 1
      }
        try! self.realm.write {
        // タグchestに投稿情報が保存される時
        chest.caption = self.textField.text!
        chest.userName = (Auth.auth().currentUser?.displayName!)!
        chest.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
        // 日付の値を取得する
        chest.time = Date()
          self.realm.add(chest, update: true)
      }
    }
    
    // もしもbackSwitchがtrueだったら
      if self.backSwitch.isOn == true {
      let back = Back()
      
        let backArray = self.realm.objects(Back.self)
      // もしもBackArrayのCountプロパティが0じゃなかったら
      if backArray.count != 0 {
        back.id = backArray.max(ofProperty: "id")! + 1
      }
        try! self.realm.write {
        // タグbackに投稿情報が保存される時
        back.caption = self.textField.text!
        back.userName = (Auth.auth().currentUser?.displayName!)!
        back.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
        // 日付の値を取得する
        back.time = Date()
          self.realm.add(back, update: true)
      }
    }
    
    // もしもabsSwitchがtrueだったら
      if self.absSwitch.isOn == true {
      let abs = Abs()
      
        let absArray = self.realm.objects(Abs.self)
      // もしもabsArraryのcountプロパティが0じゃなかったら
      if absArray.count != 0 {
        abs.id = absArray.max(ofProperty: "id")! + 1
      }
        try! self.realm.write {
        // タグabsに投稿情報が保存される時
        abs.caption = self.textField.text!
        abs.userName = (Auth.auth().currentUser?.displayName!)!
        abs.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
        // 日付の値を取得する
        abs.time = Date()
          self.realm.add(abs, update: true)
      }
    }
    
    // もしもbicepsSwitchがtrueだったら
      if self.bicepsSwitch.isOn == true {
      let biceps = Biceps()
      
        let bicepsArray = self.realm.objects(Biceps.self)
      // もしもbicepsArrayのcountプロパティがじゃなかったら
      if bicepsArray.count != 0 {
        biceps.id = bicepsArray.max(ofProperty: "id")! + 1
      }
        try! self.realm.write {
        // タグbicepsに投稿情報が保存される時
        biceps.caption = self.textField.text!
        biceps.userName = (Auth.auth().currentUser?.displayName!)!
        biceps.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
        // 日付の値を取得する
        biceps.time = Date()
          self.realm.add(biceps, update: true)
      }
    }
    
    // もしもtricepsSwitchがtrueだったら
      if self.tricepsSwitch.isOn == true {
      let triceps = Triceps()
      
        let tricepsArray = self.realm.objects(Triceps.self)
      // もしもTricepsArrayのcountプロパティが0じゃなかったら
      if tricepsArray.count != 0 {
        triceps.id = tricepsArray.max(ofProperty: "id")! + 1
      }
        try! self.realm.write {
        // タグtricepsに投稿情報が保存される時
        triceps.caption = self.textField.text!
        triceps.userName = (Auth.auth().currentUser?.displayName!)!
        triceps.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
        // 日付の値を取得する
        triceps.time = Date()
          self.realm.add(triceps, update: true)
      }
    }
    
    // もしもsholderSwitchがtrueだったら
      if self.sholderSwitch.isOn == true {
      let sholder = Sholder()
      
        let sholderArray = self.realm.objects(Sholder.self)
      // もしもsholderArrayのcountプロパティが0じゃなかったら
      if sholderArray.count != 0  {
        sholder.id = sholderArray.max(ofProperty: "id")! + 1
      }
        try! self.realm.write {
        // タグsholderに投稿情報が保存される時
        sholder.caption = self.textField.text!
        sholder.userName = (Auth.auth().currentUser?.displayName!)!
        sholder.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
        // 日付の値を取得する
        sholder.time = Date()
          self.realm.add(sholder, update: true)
      }
    }
    
    // もしもlegSwitchがtrueだったら
      if self.legSwitch.isOn == true {
      let leg = Leg()
      
        let legArray = self.realm.objects(Leg.self)
      // もしもlegArrayのcountプロパティが0じゃなかったら
      if legArray.count != 0 {
        leg.id = legArray.max(ofProperty: "id")! + 1
      }
        try! self.realm.write {
        // タグlegに投稿情報が保存される時
        leg.caption = self.textField.text!
        leg.userName = (Auth.auth().currentUser?.displayName!)!
        leg.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
        // 日付の値を取得する
        leg.time = Date()
          self.realm.add(leg, update: true)
      }
    }
    
    // もしもfootSwitchがtrueだったら
      if self.footSwitch.isOn == true {
      let foot = Foot()
      
        let footArray = self.realm.objects(Foot.self)
      // もしもfootArrayのcountプロパティが0じゃなかったら
      if footArray.count != 0 {
        foot.id = footArray.max(ofProperty: "id")! + 1
      }
        try! self.realm.write {
        foot.caption = self.textField.text!
        foot.userName =
        (Auth.auth().currentUser?.displayName!)!
        foot.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
        // 日付の値を取得する
        foot.time = Date()
          self.realm.add(foot, update: true)
      }
    }
    
    // もしもassSwitchがtrueだったら
      if self.assSwitch.isOn == true {
      let ass = Ass()
      
        let assArray = self.realm.objects(Ass.self)
      // もしもassArrayのcountプロパティが0じゃなかったら
      if assArray.count != 0 {
        ass.id = assArray.max(ofProperty: "id")! + 1
      }
        try! self.realm.write {
        // タグassに投稿情報が保存される時
        ass.caption = self.textField.text!
        ass.userName = (Auth.auth().currentUser?.displayName!)!
        ass.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
        // 日付の値を取得する
        ass.time = Date()
          self.realm.add(ass, update: true)
      }
    }
    
    // もしもcalfSwitchがtrueだったら
      if self.calfSwitch.isOn == true {
      let calf = Calf()
      
        let calfArray = self.realm.objects(Calf.self)
      // もしもcalfArrayのcountプロパティが0じゃなかったら
      if calfArray.count != 0 {
        calf.id = calfArray.max(ofProperty: "id")! + 1
      }
        try! self.realm.write {
        // タグcalfに投稿情報が保存される時
        calf.caption = self.textField.text!
        calf.userName = (Auth.auth().currentUser?.displayName!)!
        calf.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
        // 日付の値を取得する
        calf.time = Date()
          self.realm.add(calf, update: true)
      }
    }
  }
    // 非公開ボタンをタップした時に動作する
    let noShare = UIAlertAction(title: "非公開", style: .default) { (action: UIAlertAction) in
      
      // HUDで投稿完了を表示する
      SVProgressHUD.showSuccess(withStatus: "投稿しました")
      
      // 全てのモーダルを閉じる
      // この時、画像選択画面、画像加工画面、この投稿画面と、3つの画面がモーダルで画面遷移しているため、全てを閉じる必要が出てきます。以下の記述で全てのモーダルを閉じて先頭の画面に戻ることができる。
      UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
      
      // 投稿ボタンをタップした時に各Switchの状態を保存し、各Switchがtrueの状態の時に各Realmファイルに保存をする
      
      // Allファイルにデータを保存する
      let all = All()
      
      let allArray = self.realm.objects(All.self)
      // もしもallArrayのcountプロパティが0じゃなかったら
      if allArray.count != 0 {
        all.id = allArray.max(ofProperty: "id")! + 1
      }
      try! self.realm.write {
        // 投稿された全てのデータをこのAllに保存する
        all.caption = self.textField.text!
        all.userName = (Auth.auth().currentUser?.displayName!)!
        all.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
        // 日付の値を取得する
        all.time = Date()
        self.realm.add(all, update: true)
      }
      
      // もしもMorningSwitchがtrueだったら
      if self.morningSwitch.isOn == true {
        let morning = Morning()
        
        let morningArray = self.realm.objects(Morning.self)
        // もしもmorningArrayのcountプロパティが0じゃなかったら
        if morningArray.count != 0 {
          morning.id = morningArray.max(ofProperty: "id")! + 1
        }
        try! self.realm.write {
          // タグmorningに投稿情報が保存される時
          morning.caption = self.textField.text!
          morning.userName = (Auth.auth().currentUser?.displayName!)!
          morning.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
          // 日付の値を取得する
          morning.time = Date()
          self.realm.add(morning, update: true)
        }
      }
      
      // もしもNoonSwitchがtrueだったら
      if self.noonSwitch.isOn == true {
        let noon = Noon()
        
        let noonArray = self.realm.objects(Noon.self)
        // もしもnoonArrayのcountプロパティが0じゃなかったら
        if noonArray.count != 0 {
          noon.id = noonArray.max(ofProperty: "id")! + 1
        }
        try! self.realm.write {
          // タグnoonに投稿情報が保存される時
          noon.caption = self.textField.text!
          noon.userName = (Auth.auth().currentUser?.displayName!)!
          noon.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
          // 日付の値を取得する
          noon.time = Date()
          self.realm.add(noon, update: true)
        }
      }
      
      // もしもNightSwitchがtrueだったら
      if self.nightSwitch.isOn == true {
        let night = Night()
        
        let nightArray = self.realm.objects(Night.self)
        // もしもnightArrayのcountプロパティが0じゃなかったら
        if nightArray.count != 0 {
          night.id = nightArray.max(ofProperty: "id")! + 1
        }
        try! self.realm.write {
          // タグnightに投稿情報が保存される時
          night.caption = self.textField.text!
          night.userName = (Auth.auth().currentUser?.displayName!)!
          night.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
          // 日付の値を取得する
          night.time = Date()
          self.realm.add(night, update: true)
        }
      }
      
      // もしもupperBodySwitchがtrueだったら
      if self.upperBodySwitch.isOn == true {
        let upperBody = UpperBody()
        
        let upperBodyArray = self.realm.objects(UpperBody.self)
        // もしもupperBodyのcountプロパティが0じゃなかったら
        if upperBodyArray.count != 0 {
          upperBody.id = upperBodyArray.max(ofProperty: "id")! + 1
        }
        try! self.realm.write {
          // タグupperBodyに投稿情報が保存される時
          upperBody.caption = self.textField.text!
          upperBody.userName = (Auth.auth().currentUser?.displayName!)!
          upperBody.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
          // 日付の値を取得する
          upperBody.time = Date()
          self.realm.add(upperBody, update: true)
        }
      }
      
      // もしもlowerBodySwitchがtrueだったら
      if self.lowerBodySwitch.isOn == true {
        let lowerBody = LowerBody()
        
        let LowerBodyArray = self.realm.objects(LowerBody.self)
        // もしもlowerBodyのcountプロパティが0じゃなかったら
        if LowerBodyArray.count != 0 {
          lowerBody.id = LowerBodyArray.max(ofProperty: "id")! + 1
        }
        try! self.realm.write {
          // タグlowerBodyに投稿情報が保存される時
          lowerBody.caption = self.textField.text!
          lowerBody.userName = (Auth.auth().currentUser?.displayName!)!
          lowerBody.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
          // 日付の値を取得する
          lowerBody.time = Date()
          self.realm.add(lowerBody, update: true)
        }
      }
      
      // もしもchestSwitchがtrueだったら
      if self.chestSwitch.isOn == true {
        let chest = Chest()
        
        let chestArray = self.realm.objects(Chest.self)
        // もしもchestArrayのCountプロパティが0じゃなかったら
        if chestArray.count != 0 {
          chest.id = chestArray.max(ofProperty: "id")! + 1
        }
        try! self.realm.write {
          // タグchestに投稿情報が保存される時
          chest.caption = self.textField.text!
          chest.userName = (Auth.auth().currentUser?.displayName!)!
          chest.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
          // 日付の値を取得する
          chest.time = Date()
          self.realm.add(chest, update: true)
        }
      }
      
      // もしもbackSwitchがtrueだったら
      if self.backSwitch.isOn == true {
        let back = Back()
        
        let backArray = self.realm.objects(Back.self)
        // もしもBackArrayのCountプロパティが0じゃなかったら
        if backArray.count != 0 {
          back.id = backArray.max(ofProperty: "id")! + 1
        }
        try! self.realm.write {
          // タグbackに投稿情報が保存される時
          back.caption = self.textField.text!
          back.userName = (Auth.auth().currentUser?.displayName!)!
          back.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
          // 日付の値を取得する
          back.time = Date()
          self.realm.add(back, update: true)
        }
      }
      
      // もしもabsSwitchがtrueだったら
      if self.absSwitch.isOn == true {
        let abs = Abs()
        
        let absArray = self.realm.objects(Abs.self)
        // もしもabsArraryのcountプロパティが0じゃなかったら
        if absArray.count != 0 {
          abs.id = absArray.max(ofProperty: "id")! + 1
        }
        try! self.realm.write {
          // タグabsに投稿情報が保存される時
          abs.caption = self.textField.text!
          abs.userName = (Auth.auth().currentUser?.displayName!)!
          abs.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
          // 日付の値を取得する
          abs.time = Date()
          self.realm.add(abs, update: true)
        }
      }
      
      // もしもbicepsSwitchがtrueだったら
      if self.bicepsSwitch.isOn == true {
        let biceps = Biceps()
        
        let bicepsArray = self.realm.objects(Biceps.self)
        // もしもbicepsArrayのcountプロパティがじゃなかったら
        if bicepsArray.count != 0 {
          biceps.id = bicepsArray.max(ofProperty: "id")! + 1
        }
        try! self.realm.write {
          // タグbicepsに投稿情報が保存される時
          biceps.caption = self.textField.text!
          biceps.userName = (Auth.auth().currentUser?.displayName!)!
          biceps.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
          // 日付の値を取得する
          biceps.time = Date()
          self.realm.add(biceps, update: true)
        }
      }
      
      // もしもtricepsSwitchがtrueだったら
      if self.tricepsSwitch.isOn == true {
        let triceps = Triceps()
        
        let tricepsArray = self.realm.objects(Triceps.self)
        // もしもTricepsArrayのcountプロパティが0じゃなかったら
        if tricepsArray.count != 0 {
          triceps.id = tricepsArray.max(ofProperty: "id")! + 1
        }
        try! self.realm.write {
          // タグtricepsに投稿情報が保存される時
          triceps.caption = self.textField.text!
          triceps.userName = (Auth.auth().currentUser?.displayName!)!
          triceps.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
          // 日付の値を取得する
          triceps.time = Date()
          self.realm.add(triceps, update: true)
        }
      }
      
      // もしもsholderSwitchがtrueだったら
      if self.sholderSwitch.isOn == true {
        let sholder = Sholder()
        
        let sholderArray = self.realm.objects(Sholder.self)
        // もしもsholderArrayのcountプロパティが0じゃなかったら
        if sholderArray.count != 0  {
          sholder.id = sholderArray.max(ofProperty: "id")! + 1
        }
        try! self.realm.write {
          // タグsholderに投稿情報が保存される時
          sholder.caption = self.textField.text!
          sholder.userName = (Auth.auth().currentUser?.displayName!)!
          sholder.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
          // 日付の値を取得する
          sholder.time = Date()
          self.realm.add(sholder, update: true)
        }
      }
      
      // もしもlegSwitchがtrueだったら
      if self.legSwitch.isOn == true {
        let leg = Leg()
        
        let legArray = self.realm.objects(Leg.self)
        // もしもlegArrayのcountプロパティが0じゃなかったら
        if legArray.count != 0 {
          leg.id = legArray.max(ofProperty: "id")! + 1
        }
        try! self.realm.write {
          // タグlegに投稿情報が保存される時
          leg.caption = self.textField.text!
          leg.userName = (Auth.auth().currentUser?.displayName!)!
          leg.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
          // 日付の値を取得する
          leg.time = Date()
          self.realm.add(leg, update: true)
        }
      }
      
      // もしもfootSwitchがtrueだったら
      if self.footSwitch.isOn == true {
        let foot = Foot()
        
        let footArray = self.realm.objects(Foot.self)
        // もしもfootArrayのcountプロパティが0じゃなかったら
        if footArray.count != 0 {
          foot.id = footArray.max(ofProperty: "id")! + 1
        }
        try! self.realm.write {
          foot.caption = self.textField.text!
          foot.userName =
            (Auth.auth().currentUser?.displayName!)!
          foot.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
          // 日付の値を取得する
          foot.time = Date()
          self.realm.add(foot, update: true)
        }
      }
      
      // もしもassSwitchがtrueだったら
      if self.assSwitch.isOn == true {
        let ass = Ass()
        
        let assArray = self.realm.objects(Ass.self)
        // もしもassArrayのcountプロパティが0じゃなかったら
        if assArray.count != 0 {
          ass.id = assArray.max(ofProperty: "id")! + 1
        }
        try! self.realm.write {
          // タグassに投稿情報が保存される時
          ass.caption = self.textField.text!
          ass.userName = (Auth.auth().currentUser?.displayName!)!
          ass.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
          // 日付の値を取得する
          ass.time = Date()
          self.realm.add(ass, update: true)
        }
      }
      
      // もしもcalfSwitchがtrueだったら
      if self.calfSwitch.isOn == true {
        let calf = Calf()
        
        let calfArray = self.realm.objects(Calf.self)
        // もしもcalfArrayのcountプロパティが0じゃなかったら
        if calfArray.count != 0 {
          calf.id = calfArray.max(ofProperty: "id")! + 1
        }
        try! self.realm.write {
          // タグcalfに投稿情報が保存される時
          calf.caption = self.textField.text!
          calf.userName = (Auth.auth().currentUser?.displayName!)!
          calf.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
          // 日付の値を取得する
          calf.time = Date()
          self.realm.add(calf, update: true)
        }
      }
    }
    
    if interstitial.isReady {
      interstitial.present(fromRootViewController: self)
    } else {
      print("Ad wasn`t ready")
    }
    
    // alertViewにaddActionでそれぞれのactionを追加する
    alertView.addAction(share)
    alertView.addAction(noShare)
    
    self.present(alertView, animated: true, completion: nil)
  }

  // キャンセルボタンをタップした時に呼ばれるメソッド
  @IBAction func handleCancelButton(_ sender: Any) {
    // 画面を閉じる
    dismiss(animated: true, completion: nil)
  }
  
  // 一番最初にこの画面が呼ばれた時に呼び出される
  override func viewDidLoad() {
        super.viewDidLoad()
    
    let timeBorder = CALayer()
    timeBorder.frame = CGRect(x: 0, y: timeBorderView.frame.height, width: timeBorderView.frame.width, height: 0.5)
    timeBorder.backgroundColor = UIColor.lightGray.cgColor
    timeBorderView.layer.addSublayer(timeBorder)
    
    let muscleBorder = CALayer()
    muscleBorder.frame = CGRect(x: 0, y: 0, width: muscleBorderView.frame.width, height: 0.5)
    muscleBorder.backgroundColor = UIColor.lightGray.cgColor
    muscleBorderView.layer.addSublayer(muscleBorder)
    
    textField.delegate = self
    
    // textFieldの枠線を無しにする
    // textField.borderStyle = UITextBorderStyle.none
    // ViewControllerから受け取った画像をImgaViewに設定する
    imageView.image = image
    
    // 全てのSwitchを最初の時点ではOffにしておく
    morningSwitch.isOn = false
    noonSwitch.isOn = false
    nightSwitch.isOn = false
    upperBodySwitch.isOn = false
    lowerBodySwitch.isOn = false
    chestSwitch.isOn = false
    backSwitch.isOn = false
    absSwitch.isOn = false
    bicepsSwitch.isOn = false
    tricepsSwitch.isOn = false
    sholderSwitch.isOn = false
    legSwitch.isOn = false
    footSwitch.isOn = false
    assSwitch.isOn = false
    calfSwitch.isOn = false
    
    // 背景をタップしたらdismissKeyboardメソッドを呼び出す
    let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(dismissKeyboard))
    self.view.addGestureRecognizer(tapGesture)
    
    // Realmファイルの場所を確認するためにコンソールに出力する
    print(Realm.Configuration.defaultConfiguration.fileURL!)
    
    interstitial = GADInterstitial(adUnitID: "ca-app-pub-9687800555774849/6694101791")
    let request = GADRequest()
    interstitial.load(request)
    interstitial.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  @objc func dismissKeyboard() {
    // キーボードを閉じる
    view.endEditing(true)
  }
 
  // textViewがフォーカスされたら、Labelを非表示にする
  func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
    hiddenLabel.isHidden = true
    return true
  }
  
  // textViewからフォーカスが外れて、TextViewが空だったらlabelを再表示する
  func textViewDidEndEditing(_ textView: UITextView) {
    
    // もしtextFieldの値がisEnptyならlabelを表示する
    if let text = textField.text {
      if text.isEmpty {
        hiddenLabel.isHidden = false
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
  
  // AdMobのプロトコルメソッド
  /// Tells the delegate an ad request succeeded.
  func interstitialDidReceiveAd(_ ad: GADInterstitial) {
    print("interstitialDidReceiveAd")
  }
  
  /// Tells the delegate an ad request failed.
  func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
    print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
  }
  
  /// Tells the delegate that an interstitial will be presented.
  func interstitialWillPresentScreen(_ ad: GADInterstitial) {
    print("interstitialWillPresentScreen")
  }
  
  /// Tells the delegate the interstitial is to be animated off the screen.
  func interstitialWillDismissScreen(_ ad: GADInterstitial) {
    print("interstitialWillDismissScreen")
  }
  
  /// Tells the delegate the interstitial had been animated off the screen.
  func interstitialDidDismissScreen(_ ad: GADInterstitial) {
    print("interstitialDidDismissScreen")
  }
  
  /// Tells the delegate that a user click will open another app
  /// (such as the App Store), backgrounding the current app.
  func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
    print("interstitialWillLeaveApplication")
  }

}
