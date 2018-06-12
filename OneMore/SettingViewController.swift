//
//  SettingViewController.swift
//  OneMore
//
//  Created by 池田優作 on 2018/03/06.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import UIKit
import ESTabBarController
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SVProgressHUD
import SDWebImage
import RealmSwift


class SettingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate,UITextViewDelegate, UIScrollViewDelegate {
  @IBOutlet weak var profielView: UIView!
  @IBOutlet weak var displayNameTextField: UITextField!
  @IBOutlet weak var profielImageSetting: UIImageView!
  @IBOutlet weak var handleChangerButton: UIButton!
  @IBOutlet weak var textView: UITextView!
  @IBOutlet weak var selfNoteButton: UIButton!
  @IBOutlet weak var handleLogoutButton: UIButton!
  @IBOutlet weak var focusLabel: UILabel!
  @IBOutlet weak var borderView: UIView!
  @IBOutlet weak var selfNoteTextView: UITextView!
  @IBOutlet weak var scrollView: UIScrollView!
  
  let user = Auth.auth().currentUser
  
  let realm = try! Realm()
  
  // textFieldの情報を格納する変数をUITextFiledのインスタンスとして生成しておく
  var textActiveField = UITextView()
  
  let selfNoteArrays = try! Realm().objects(SelfNote.self).sorted(byKeyPath: "id", ascending: true).filter("userName == %@", Auth.auth().currentUser?.displayName ?? "")
  
  @IBAction func handleChangeButton(_ sender: Any) {
    if let displayName = displayNameTextField.text {
      
      // 表示名が入力されていない時はHUDを出して何もしない
      if displayName.isEmpty {
        SVProgressHUD.showError(withStatus: "表示名を入力して下さい")
        // 処理をせずに返す
        return
      }
      
      // 表示名を設定する
      let user = Auth.auth().currentUser
      if let user = user {
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = displayName
        changeRequest.commitChanges { error in
          if let error = error {
            print("DEBUG_PRINT: " + error.localizedDescription)
          }
          print("DEBUG_PRINT: [displayName = \(String(describing: user.displayName))]の設定に成功しました。")
          
          // HUDで完了を知らせる
          SVProgressHUD.showSuccess(withStatus: "表示名を変更しました")
        }
      } else {
        print("DEBUG_PRINT: displayNameの設定に失敗しました。")
      }
    }
    // キーボードを閉じる
    self.view.endEditing(true)
  }
  
  override func viewWillAppear(_ animated: Bool) {
     super.viewWillAppear(animated)
    print("viewWillAppearが表示されました")
    print("DEBUG_PRINT_TEXT: \(textView.text)")
    
    // 表示名を取得してTextFieldに設定する
    let user = Auth.auth().currentUser
    if let user = user {
      displayNameTextField.text = user.displayName
      print("DEBUG_PRINT: 表示名を設定しました")
    
      if selfNoteArrays.count == 0 {
        
        focusLabel.isHidden = false
        
      } else if selfNoteArrays.count > 0 {
        
        focusLabel.isHidden = true
        
        let selfNoteArrayLast = selfNoteArrays.last
        let selfNoteLastText = selfNoteArrayLast?.text
        selfNoteTextView.text = selfNoteLastText
        
      }
    // もしFirebase上のGoalDreamのtextsにデータが存在すればfocusLabelを非表示にする
    if let text = self.textView.text {
      if text.isEmpty {
        self.focusLabel.isHidden = false
      } else {
        self.focusLabel.isHidden = true
      }
    }
    print("DEBUG_PRINT_TEXT2: \(textView.text)")
  }
}
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      // もしユーザーのphotoURLが無ければデフォルトを設定する
      if user?.photoURL == nil {
        // もしプロフィール写真が設定されていなかったらデフォルトを設定する
        profielImageSetting.image = UIImage(named: "human128.png")
      } else {
        // もしユーザーのphotoURLが設定済みだったら設定する
        profielImageSetting.sd_setImage(with: user?.photoURL)
        
      }
      
      navigationItem.title = "設定"
      
      // profielViewに下線を表示する
      let weightBorder = CALayer()
      weightBorder.frame = CGRect(x: 0, y: profielView.frame.height, width: profielView.frame.width, height: 1.0)
      weightBorder.backgroundColor = UIColor.lightGray.cgColor
      profielView.layer.addSublayer(weightBorder)
      // borderViewに下線を表示する
      let displayBorder = CALayer()
      displayBorder.frame = CGRect(x: 0, y: borderView.frame.height, width: borderView.frame.width, height: 1.0)
      displayBorder.backgroundColor = UIColor.lightGray.cgColor
      borderView.layer.addSublayer(displayBorder)

      // UIImageViewなどはもともと検知を受け取らない設定なのでユーザーインタラクションを有効に設定する
      profielImageSetting.isUserInteractionEnabled = true
      
      // UITapGestureRecognizerをprofielImageSettingに設定する
      let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SettingViewController.appearanceAlert(_:)))
      
      // SettingViewControllerに追加する
      self.profielImageSetting.addGestureRecognizer(tapGesture)
      
      // デリゲートをセットする
      tapGesture.delegate = self
      textView.delegate = self
      scrollView.delegate = self
      
      // 背景をタップしたらdismissKeyboardメソッドを呼び出す
      let tapGesture2: UITapGestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(dismissKeyboard))
      self.view.addGestureRecognizer(tapGesture2)
      
        // Do any additional setup after loading the view.
    }
  
  @objc func dismissKeyboard() {
    // キーボードを閉じる
    view.endEditing(true)
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  // profielImageSettingをタップした時に呼ばれるメソッド
  @objc func appearanceAlert(_ sender: UITapGestureRecognizer) {
    
    print("DEBUG:PRINT: profielImageSettingがタップされました")
    
    // UIAlertControllerのインスタンスを生成
    let alertView: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
    
    let action1 = UIAlertAction(title: "ライブラリ",
                                    style: .default) { (action: UIAlertAction) in
                                      print("ライブラリがタップされた")
                                      // ライブラリ(カメラロール)を指定してピッカーを開く
                                      if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                                        // pickerControllerにUIImagePickerControllerを生成する
                                        let pickerController = UIImagePickerController()
                                        // sourceTypeにphotoLibraryを指定する
                                        pickerController.sourceType = .photoLibrary
                                        // pickerControllerにdelegateを指定する
                                        pickerController.delegate = self
                                        pickerController.allowsEditing = true
                                        // presentメソッドでpickerControllerを開く
                                        self.present(pickerController, animated:  true, completion: nil)
                                      }
    }
                                      
    let action2 = UIAlertAction(title: "カメラ",
                                    style: .default) { (action: UIAlertAction) in
                                      print("カメラがタップされた")
                                      // カメラを指定してピッカーを開く
                                      if UIImagePickerController.isSourceTypeAvailable(.camera) {
                                        // pickerControllerにUIImagePickerControlleのインスタンスを生成する
                                        let pickerController = UIImagePickerController()
                                        //pickerControllerにdelegateを実装する
                                        pickerController.delegate = self
                                        // pickerControllerのallowsEditingプロパティにtrueを格納する
                                        // こうすることで編集画面を挟むことができる
                                        // コードの記述場所はpickerControllerの設定時に設定する
                                        pickerController.allowsEditing = true
                                        // pickerControllerのsourceTypeにcameraを指定する
                                        pickerController.sourceType = .camera
                                        // presentメソッドでpickerControllerを開く
                                        self.present(pickerController, animated: true, completion: nil)
                                       }
    }
                                      
                                      
    let action3 = UIAlertAction(title: "キャンセル",
                                style: .cancel) { (action: UIAlertAction) in
                                  print("キャンセルがタップされた")
                 }
    
    // alertViewにaddActionでそれぞれのactionを追加する
    alertView.addAction(action1)
    alertView.addAction(action2)
    alertView.addAction(action3)
    
    self.present(alertView, animated: true, completion: nil)
       }
  
  
  // 写真を撮影/選択した時に呼ばれるメソッド
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if info [UIImagePickerControllerOriginalImage] != nil {
      // 撮影/選択された画像を取得する
      // 編集画面から取り出したimageを取り出す。
      // pickerControllerで取得した画像を編集しUIImagePickerControllerEditedImageからimageを取り出す
      let image = info[UIImagePickerControllerEditedImage] as! UIImage
      
      // imagePickerControllerで取得した写真をデータ型で取得する
      let data = UIImagePNGRepresentation(image)
      
      // ストレージ サービスへの参照を取得
      let storage = Storage.storage()
      // ストレージへの参照を取得
      let storageRef = storage.reference(forURL: "gs://onemore-3dfbf.appspot.com/")
      // ツリーの下位への参照を作成
      // childメソッドでimage.jpgを作成
      let imageRef = storageRef.child("image.jpg/")
      // putDataメソッドでData型の値をFirebaseにアップロードを実行する
      imageRef.putData(data!, metadata: nil) { metadata, error in
        if (error != nil) {
          // errorが起きた場合
          print("Uh-on, on error occurred!")
        } else {
          // アップロードが出来た場合
          // downloadURL()メソッドでstorageRefのchildメソッドで作成したimage.jpgの参照にアップロードした写真のURLを取得する
          let downloadURL = metadata!.downloadURL()!
          print("downloadURL:", downloadURL)
          
          // 現在ログインしているユーザーの情報を格納する
          let user = Auth.auth().currentUser
          // もしuserがログインをしていたら
          if let user = user {
            // changeRequestにユーザーのプロフィール情報を変更するメソッドのインスタンスを生成する
            let changeRequest = user.createProfileChangeRequest()
            // userのphotoURLにアップロードした写真のURLを格納する
            changeRequest.photoURL = downloadURL
            changeRequest.commitChanges { error in
              if let error = error {
                print("DEBUG_PRINT: " + error.localizedDescription)
              }
              print("DEBUG_PRINT: [photoURL = \(String(describing: user.photoURL))]の設定に成功しました。")
              
              // HUDで完了を知らせる
              SVProgressHUD.showSuccess(withStatus: "プロフィール写真を変更しました。")
              
              // profielImageSettingに画像を表示する
              self.profielImageSetting.image = image
              
              // dismissメソッドで表示している画面を閉じる
              self.dismiss(animated: true, completion: nil)
              
            }
          } else {
            print("DEBUG_PRINT: photoURLの設定に失敗しました。")
        }
      }
    }
    
    }
  }

  // キャンセルした時に呼ばれる
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    // 閉じる
    picker.dismiss(animated:  true, completion: nil)
  }
  
  @IBAction func handleLogoutButtonAction(_ sender: Any) {
    // ログアウトする
    try! Auth.auth().signOut()
    
    // HUDで完了を知らせる
    SVProgressHUD.showSuccess(withStatus: "ログアウトに成功しました")
    
    // ログイン画面を表示する
    let loginViewControlelr = self.storyboard?.instantiateViewController(withIdentifier: "Login")
    self.present(loginViewControlelr!, animated: true, completion: nil)
    
    // ログイン画面から戻ってきた時のためにSelf管理画面(index = 0)を選択している状態にしておく
    //let tabBarController = parent as! ESTabBarController
    //tabBarController.setSelectedIndex(0, animated: true)
  }
  

  @IBAction func selfNoteButtonAction(_ sender: Any) {
    let selfNote = SelfNote()
    
    let selfNoteArray = self.realm.objects(SelfNote.self)
    // もしもselfNoteArrayのcountプロパティが0じゃなかったら
    if selfNoteArray.count != 0 {
      selfNote.id = selfNoteArray.max(ofProperty: "id")! + 1
    }
    try! self.realm.write {
      // 入力されたテキストをこのSelfNoteに保存する
      selfNote.text = self.selfNoteTextView.text!
      selfNote.userName = (Auth.auth().currentUser?.displayName!)!
      self.realm.add(selfNote, update: true)
    }
    
    SVProgressHUD.showSuccess(withStatus: "SelfNoteの変更を保存しました")
    // SelfNoteのキーボードを閉じる
    selfNoteTextView.resignFirstResponder()
  }
  
  // textViewがフォーカスされたら、Labelを非表示にする
  func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
    focusLabel.isHidden = true
    
    textActiveField = textView
    return true
  }
  
  // textViewからフォーカスが外れて、TextViewが空だったらlabelを再表示する
  func textViewDidEndEditing(_ textView: UITextView) {
    // もしtextFieldの値がisEmptyならlabelを表示する
    if let text = textView.text {
      if text.isEmpty {
        focusLabel.isHidden = false
      }
      focusLabel.isHidden = true
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


