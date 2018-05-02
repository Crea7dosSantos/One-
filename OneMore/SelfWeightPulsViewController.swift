//
//  SelfWeightPulsViewController.swift
//  OneMore
//
//  Created by 池田優作 on 2018/04/22.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import UIKit
import RealmSwift
import SVProgressHUD
import Firebase
import FirebaseAuth

class SelfWeightPulsViewController: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate, UIPickerViewDelegate, XibDateViewDelegate {
  @IBOutlet weak var saveCode: UITextField!
  @IBOutlet weak var dateButton: UIButton!
  @IBOutlet weak var weightView: UIView!
  @IBOutlet weak var dateView: UIView!
  
  // Realmのインスタンスを作成する
  // このインスタンスを使用し読み書きのメソッドを呼び出す
  let realm = try! Realm()
  
  // XibDateViewクラスの型を宣言する
  var xib: XibDateView!
  
  // 定数timeに現在の年数、日付を格納する
  let time = Date.timeIntervalSinceReferenceDate
  
  // 画面が表示される前に呼び出されるメソッド
  override func viewDidAppear(_ animated: Bool) {
    if saveCode.isEditing == false {
      self.saveCode.resignFirstResponder()
    }
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()
      // navgationBarのプロパティを変更する
      // rightButtonItemを指定して、プロパティを変更する
      navigationItem.rightBarButtonItem = UIBarButtonItem(title: "追加",
                                                          style: .plain,
                                                          target: self,
                                                          action: #selector(perfectAction))
      navigationItem.title = "体重を追加"
      
      
      // XibDateViewクラスのインスタンスを設定する
      xib = XibDateView()
      // delegateを自身に設定する
      xib.delegate = self
      
      // textFieldにdelegateをセットする
      saveCode.delegate = self
    
      // textFieldにユーザーイントラクションを実装する
      saveCode.isUserInteractionEnabled = true
      
      // この体重プラス画面に遷移した時にTextFieldを入力状態にする
      // もしもTextFieldが編集中でなければ、TextFieldを入力状態にする
      if saveCode.isEditing == false {
        self.saveCode.becomeFirstResponder()
      }
      
      // weightViewに下線を作成する
      // 定数weightBorderにCALayerクラスのインスタンスを作成する
      let weightBorder = CALayer()
      // weightBorderのframeプロパティを設定する。xの値は0、yはweightViewの高さを指定、widthはweightViewの幅を選択、heightは1.0。
      weightBorder.frame = CGRect(x: 0, y: weightView.frame.height, width: weightView.frame.width, height: 1.0)
      weightBorder.backgroundColor = UIColor.lightGray.cgColor
      
      // weightViewにweightBorderを追加する
      weightView.layer.addSublayer(weightBorder)
      
      
      // dateViewに下線を作成する
      let dateBorder = CALayer()
      dateBorder.frame = CGRect(x: 0, y: dateView.frame.height, width: dateView.frame.width, height: 1.0)
      dateBorder.backgroundColor = UIColor.lightGray.cgColor
      
      dateView.layer.addSublayer(dateBorder)
      
      
      // Dateformatterクラスのインスタンスを作成する
      let formatter = DateFormatter()
      // dateFormatterプロパティに値を格納する
      formatter.dateFormat = "yyyy年MM月dd日"
      
      // 定数dateにTimeIntervalのクラスのインスタンスを作成し、定数timeに格納された現在の日付をTimeInterval型の値に変換する
      let date = Date(timeIntervalSinceReferenceDate: TimeInterval(time))
      
      // 定数dateStringにdateに格納された値をString型の値に変換して格納する
      let dateString = formatter.string(from: date)
      
      // dateButtonのtitleに現在の日付を表示させる
      dateButton.setTitle(dateString, for: .normal)
      // dateLabelのテキストをタップ出来るとユーザーにわかりやすくする為に青文字で表示させる
      self.dateButton.setTitleColor(UIColor.blue, for: .normal)
      

      // SaveCodeから入力される文字は数字だけにする
      self.saveCode.keyboardType = UIKeyboardType.numberPad
      // TextFieldの枠線を非表示にする
      self.saveCode.borderStyle = UITextBorderStyle.none

      
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  // xibファイルで作成した完了ボタンがタップされた時に呼び出されるメソッド
  func sendPerfect(date: Date) {
    // print文でデバックエリアにdateが取得できているかの確認をする
    print("DEBUG_PRINT: \(date)")
    // 定数formatterにDateFormatterのインスタンスを作成する
    let formatter = DateFormatter()
    // 表示するデータのフォーマットを指定する
    formatter.dateFormat = "yyyy年MM月dd日"
 
    // dateStringにdate型で取得している引数dateを先ほどのformatterを使用してString型に変換をする
    let dateString = formatter.string(from: date)
    // dateButtonのタイトルにUIDatePickerで表示されている値を取得したdateをString型に変換したものを格納する
    dateButton.setTitle(dateString, for: .normal)

  }

  // dateButtonがタップされた時の処理
  @IBAction func tappedDate(_ sender: Any) {
    
    // UITextFieldのキーボードを閉じる
    saveCode.resignFirstResponder()
    
    xib.frame = CGRect(x: 0, y: 300, width: self.view.frame.width, height: 230)
    xib.tag = 100
    xib.datePicker.datePickerMode = .date
    xib.datePicker.locale = Locale(identifier: "ja")
    
    // Viewにxibを表示する
    view.addSubview(xib)
  }
  
  // タッチイベントの際にタッチした座標を取得したいのでtouchesBeganメソッドで取り出す
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    // もしsaveCodeが編集中なら
    if (self.saveCode.isFirstResponder) {
      // saveCodeに表示されているキーボードを閉じる
      self.saveCode.resignFirstResponder()
    }
    
    // このタッチイベントの場合確実に一つ以上タッチてんがあるから'！'をつける
    // タップされたタイミングでメソッド内の引数を定数touchに格納する
    let touch = touches.first!
    // 定数locationにSelfWeightPlusViewControllerのViweの値を格納する
    let location = touch.location(in: self.view)
    // DEBUGエリアにlocationに格納されている値を表示する
    print("DEBUG_PRINT: \(location)")
    // もしviewWithTagにViewのタグ100が格納されていれば
    if let viewWithTag = self.view.viewWithTag(100) {
      print("DEBUG_PRINT:Tag 100")
      // removeFromSuperViewメソッドで対象のViewを削除する
      viewWithTag.removeFromSuperview()
    } else {
      print("DEBUG_PRINT:tag 100じゃない")
    }
    
  }
  
  
  @objc func perfectAction() {
    print("DEBUG_PRINT: 体重を追加するボタンがタップされました。")
    // 定数nameに現在ログインしているユーザーのdisplayNameを格納する
    let name = Auth.auth().currentUser?.displayName
    
    if let weight = saveCode.text, let date = dateButton.title(for: .normal) {
      
      // 空の場合何もしない
      if weight.isEmpty || date.isEmpty {
        SVProgressHUD.showError(withStatus: "体重と日付を入力、または選択してください")
        return
      } else {
        // もしsaveCodeとUIDateOickerの値が入力されているなら
        // HUDで処理中を表示
        SVProgressHUD.show()
        print("DEBUG_PRINT: 体重を保存中")
        
        // Realmに書き込んでいく
        // 新たな体重の場合すでに存在しているAddWeightのidに+1を追加して他のidと重ならないidを作成する
        // ファイルAddWeightのインスタンスを作成する
        let addWeight = AddWeight()
        let addWeightArray = realm.objects(AddWeight.self)
 
        if addWeight.time == dateButton.title(for: .normal) {
          SVProgressHUD.showError(withStatus: "既にこの日の体重は入力されています")
          
          print("DEBUG_PRINT: addWeightの数: \(addWeight.time)")
          
          // 何もせずに返す
          return
          
        } else {
        // もしもaddWeightArrayのcountプロパティが0じゃなかったら
        if addWeightArray.count != 0 {
          // idに+1をして新しいidを作成して保存する
          addWeight.id = addWeightArray.max(ofProperty: "id")! + 1
        }
        // writeメソッドで書き込む
        try! realm.write {
          addWeight.weight = self.saveCode.text!
          addWeight.time = self.dateButton.title(for: .normal)!
          addWeight.userName = name!
          
          
          // 日付をDouble型で取得するためにString型からDate型に変換をし、Date型からTimeIntervalSinceDateメソッドを使用しTimeInterval(Double)型に変換をする
          // DateFormatterクラスのインスタンスを作成する
          let formatter = DateFormatter()
          // タイムゾーンをそれぞれの端末の言語設定に合わせる
          formatter.locale = Locale(identifier: Locale.current.identifier)
          formatter.dateFormat = "yyyy年MM月dd日"
          // 上記の形式の日付文字列から日付データを取得する
          let d: Date = formatter.date(from: dateButton.title(for: .normal)!)!
          // TimeInterval(Double)を求める
          let data = d.timeIntervalSinceReferenceDate
         
          // 実数でRealmに保存をするためにString型からDouble型に変換するための変数を作成する
          // 実数で体重を保存するための変数
          let doubleNumWeight: Double = atof(self.saveCode.text)
          
          // String型からDouble型に変換した値をRealmで保存する
          // 体重をDouble型でRealmに保存する
          addWeight.weightDouble = doubleNumWeight
          // 日付をDouble型でRealmで保存する
          addWeight.timeDouble = data
          realm.add(addWeight, update: true)
          
          // HUDを消す
          SVProgressHUD.dismiss()
          
          // HUDで追加完了を表示する
          SVProgressHUD.showSuccess(withStatus: "入力された体重が保存されました")
          
          // NavigationControllerで画面遷移する前に戻る
          self.navigationController?.popViewController(animated: true)
          
          print("DEBUG_PRINT: 体重が正しく保存されました。")
        }
        }
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
