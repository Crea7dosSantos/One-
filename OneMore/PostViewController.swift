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

class PostViewController: UIViewController, UITextViewDelegate {
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
  @IBOutlet weak var calfSwitch: UISwitch!
  
  // Realmのインスタンスを作成する
  // このインスタンスを使用し読み書きのメソッドを呼び出す
  let realm = try! Realm()
  
 
  @IBAction func handlePostButton(_ sender: Any) {
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
    
    // 辞書を作成してFirebaseに保存する
    // postRefを使用してFirebaseサーバ上にある保存先に代入しておく
    // このpostRefを使用して画像やキャプションをDatabaseへ保存する
    // OneMoreのDatabase上にchildメソッドで値を格納するConst.PostPathの場所を格納する
    let postRef = Database.database().reference().child(Const.PostPath)
    // 保存したい値を辞書を作成し、PostDataクラスの変数名に値を格納する
    let postData = ["caption": textField.text!, "image": imageString, "time": String(time), "name": name!]
    // setValue(_:)メソッドでFirebaseに保存した後はHUDで投稿完了をユーザーに伝える。
    postRef.childByAutoId().setValue(postData)
    
    // HUDで投稿完了を表示する
    SVProgressHUD.showSuccess(withStatus: "投稿しました")
    
    // 全てのモーダルを閉じる
    // この時、画像選択画面、画像加工画面、この投稿画面と、3つの画面がモーダルで画面遷移しているため、全てを閉じる必要が出てきます。以下の記述で全てのモーダルを閉じて先頭の画面に戻ることができる。
    UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
    
    let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "Management") as! UINavigationController
    
    self.present(navigationController, animated: true, completion: nil)
    
    // 投稿ボタンをタップした時に各Switchの状態を保存し、各Switchがtrueの状態の時に各Realmファイルに保存をする
    
    // Date.timeIntervalSinceReferenceDateメソッドだけを取り出し、コードの量を減らす
    let timer = Date.timeIntervalSinceReferenceDate
    
    // もしもMorningSwitchがtrueだったら
    if morningSwitch.isOn == true {
      let morning = Morning()
      morning.time = String(timer)

      let morningArray = realm.objects(Morning.self)
      // もしもmorningArrayのcountプロパティが0じゃなかったら
      if morningArray.count != 0 {
        morning.id = morningArray.max(ofProperty: "id")! + 1
      }
      try! realm.write {
        // タグmorningに投稿情報が保存される時
        morning.caption = self.textField.text!
        morning.userName = (Auth.auth().currentUser?.displayName!)!
        morning.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
        // 日付の値を取得する
        morning.time = String(timer)
        realm.add(morning, update: true)
      }
    }
    
    // もしもNoonSwitchがtrueだったら
    if noonSwitch.isOn == true {
      let noon = Noon()
      noon.time = String(timer)
  
      let noonArray = realm.objects(Noon.self)
      // もしもnoonArrayのcountプロパティが0じゃなかったら
      if noonArray.count != 0 {
        noon.id = noonArray.max(ofProperty: "id")! + 1
      }
      try! realm.write {
        // タグnoonに投稿情報が保存される時
        noon.caption = self.textField.text!
        noon.userName = (Auth.auth().currentUser?.displayName!)!
        noon.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
        // 日付の値を取得する
        noon.time = String(timer)
        realm.add(noon, update: true)
      }
    }
    
    // もしもNightSwitchがtrueだったら
    if nightSwitch.isOn == true {
      let night = Night()
      night.time = String(timer)
      
      let nightArray = realm.objects(Night.self)
      // もしもnightArrayのcountプロパティが0じゃなかったら
      if nightArray.count != 0 {
        night.id = nightArray.max(ofProperty: "id")! + 1
      }
      try! realm.write {
        // タグnightに投稿情報が保存される時
        night.caption = self.textField.text!
        night.userName = (Auth.auth().currentUser?.displayName!)!
        night.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
        // 日付の値を取得する
        night.time = String(timer)
        realm.add(night, update: true)
      }
    }
    
    // もしもupperBodySwitchがtrueだったら
    if upperBodySwitch.isOn == true {
      let upperBody = UpperBody()
      upperBody.time = String(timer)
      
      let upperBodyArray = realm.objects(UpperBody.self)
      // もしもupperBodyのcountプロパティが0じゃなかったら
      if upperBodyArray.count != 0 {
        upperBody.id = upperBodyArray.max(ofProperty: "id")! + 1
      }
      try! realm.write {
        // タグupperBodyに投稿情報が保存される時
        upperBody.caption = self.textField.text!
        upperBody.userName = (Auth.auth().currentUser?.displayName!)!
        upperBody.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
        // 日付の値を取得する
        upperBody.time = String(timer)
        realm.add(upperBody, update: true)
      }
    }
    
    // もしもlowerBodySwitchがtrueだったら
    if lowerBodySwitch.isOn == true {
      let lowerBody = UpperBody()
      lowerBody.time = String(timer)
      
      let LowerBodyArray = realm.objects(LowerBody.self)
      // もしもlowerBodyのcountプロパティが0じゃなかったら
      if LowerBodyArray.count != 0 {
        lowerBody.id = LowerBodyArray.max(ofProperty: "id")! + 1
      }
      try! realm.write {
        // タグlowerBodyに投稿情報が保存される時
        lowerBody.caption = self.textField.text!
        lowerBody.userName = (Auth.auth().currentUser?.displayName!)!
        lowerBody.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
        // 日付の値を取得する
        lowerBody.time = String(timer)
        realm.add(lowerBody, update: true)
      }
    }
    
    // もしもchestSwitchがtrueだったら
    if chestSwitch.isOn == true {
      let chest = Chest()
      chest.time = String(timer)
      
      let chestArray = realm.objects(Chest.self)
      // もしもchestArrayのCountプロパティが0じゃなかったら
      if chestArray.count != 0 {
        chest.id = chestArray.max(ofProperty: "id")! + 1
      }
      try! realm.write {
        // タグchestに投稿情報が保存される時
        chest.caption = self.textField.text!
        chest.userName = (Auth.auth().currentUser?.displayName!)!
        chest.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
        // 日付の値を取得する
        chest.time = String(timer)
        realm.add(chest, update: true)
      }
    }
    
    // もしもbackSwitchがtrueだったら
    if backSwitch.isOn == true {
      let back = Back()
      back.time = String(timer)
      
      let backArray = realm.objects(Back.self)
      // もしもBackArrayのCountプロパティが0じゃなかったら
      if backArray.count != 0 {
        back.id = backArray.max(ofProperty: "id")! + 1
      }
      try! realm.write {
        // タグbackに投稿情報が保存される時
        back.caption = self.textField.text!
        back.userName = (Auth.auth().currentUser?.displayName!)!
        back.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
        // 日付の値を取得する
        back.time = String(timer)
        realm.add(back, update: true)
      }
    }
    
    // もしもabsSwitchがtrueだったら
    if absSwitch.isOn == true {
      let abs = Abs()
      abs.time = String(timer)
      
      let absArray = realm.objects(Abs.self)
      // もしもabsArraryのcountプロパティが0じゃなかったら
      if absArray.count != 0 {
        abs.id = absArray.max(ofProperty: "id")! + 1
      }
      try! realm.write {
        // タグabsに投稿情報が保存される時
        abs.caption = self.textField.text!
        abs.userName = (Auth.auth().currentUser?.displayName!)!
        abs.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
        // 日付の値を取得する
        abs.time = String(timer)
        realm.add(abs, update: true)
      }
    }
    
    // もしもbicepsSwitchがtrueだったら
    if bicepsSwitch.isOn == true {
      let biceps = Biceps()
      biceps.time = String(timer)
      
      let bicepsArray = realm.objects(Biceps.self)
      // もしもbicepsArrayのcountプロパティがじゃなかったら
      if bicepsArray.count != 0 {
        biceps.id = bicepsArray.max(ofProperty: "id")! + 1
      }
      try! realm.write {
        // タグbicepsに投稿情報が保存される時
        biceps.caption = self.textField.text!
        biceps.userName = (Auth.auth().currentUser?.displayName!)!
        biceps.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
        // 日付の値を取得する
        biceps.time = String(timer)
        realm.add(biceps, update: true)
      }
    }
    
    // もしもtricepsSwitchがtrueだったら
    if tricepsSwitch.isOn == true {
      let triceps = Triceps()
      triceps.time = String(timer)
      
      let tricepsArray = realm.objects(Triceps.self)
      // もしもTricepsArrayのcountプロパティが0じゃなかったら
      if tricepsArray.count != 0 {
        triceps.id = tricepsArray.max(ofProperty: "id")! + 1
      }
      try! realm.write {
        // タグtricepsに投稿情報が保存される時
        triceps.caption = self.textField.text!
        triceps.userName = (Auth.auth().currentUser?.displayName!)!
        triceps.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
        // 日付の値を取得する
        triceps.time = String(timer)
        realm.add(triceps, update: true)
      }
    }
    
    // もしもsholderSwitchがtrueだったら
    if sholderSwitch.isOn == true {
      let sholder = Sholder()
      sholder.time = String(timer)
      
      let sholderArray = realm.objects(Sholder.self)
      // もしもsholderArrayのcountプロパティが0じゃなかったら
      if sholderArray.count != 0  {
        sholder.id = sholderArray.max(ofProperty: "id")! + 1
      }
      try! realm.write {
        // タグsholderに投稿情報が保存される時
        sholder.caption = self.textField.text!
        sholder.userName = (Auth.auth().currentUser?.displayName!)!
        sholder.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
        // 日付の値を取得する
        sholder.time = String(timer)
        realm.add(sholder, update: true)
      }
    }
    
    // もしもlegSwitchがtrueだったら
    if legSwitch.isOn == true {
      let leg = Leg()
      leg.time = String(timer)
      
      let legArray = realm.objects(Leg.self)
      // もしもlegArrayのcountプロパティが0じゃなかったら
      if legArray.count != 0 {
        leg.id = legArray.max(ofProperty: "id")! + 1
      }
      try! realm.write {
        // タグlegに投稿情報が保存される時
        leg.caption = self.textField.text!
        leg.userName = (Auth.auth().currentUser?.displayName!)!
        leg.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
        // 日付の値を取得する
        leg.time = String(timer)
        realm.add(leg, update: true)
      }
    }
    
    // もしもcalfSwitchがtrueだったら
    if calfSwitch.isOn == true {
      let calf = Calf()
      calf.time = String(timer)
      
      let calfArray = realm.objects(Calf.self)
      // もしもcalfArrayのcountプロパティが0じゃなかったら
      if calfArray.count != 0 {
        calf.id = calfArray.max(ofProperty: "id")! + 1
      }
      try! realm.write {
        // タグcalfに投稿情報が保存される時
        calf.caption = self.textField.text!
        calf.userName = (Auth.auth().currentUser?.displayName!)!
        calf.imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
        // 日付の値を取得する
        calf.time = String(timer)
        realm.add(calf, update: true)
      }
    }
  }
  
  
  @IBAction func handleCancelButton(_ sender: Any) {
    // 画面を閉じる
    dismiss(animated: true, completion: nil)
  }
  
  
  // 一番最初にこの画面が呼ばれた時に呼び出される
  override func viewDidLoad() {
        super.viewDidLoad()
    
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
    calfSwitch.isOn = false
    
    // 背景をタップしたらdismissKeyboardメソッドを呼び出す
    let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(dismissKeyboard))
    self.view.addGestureRecognizer(tapGesture)
    
    // Realmファイルの場所を確認するためにコンソールに出力する
    print(Realm.Configuration.defaultConfiguration.fileURL!)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  
  
  // 別の画面に遷移する直前に呼び出される
  override func viewWillDisappear(_ animated: Bool) {
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

}
