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


class SettingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
  @IBOutlet weak var displayNameTextField: UITextField!
  @IBOutlet weak var profielImageSetting: UIImageView!
  @IBOutlet weak var handleChangerButton: UIButton!
  
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
    
    // 表示名を取得してTextFieldに設定する
    let user = Auth.auth().currentUser
    if let user = user {
      displayNameTextField.text = user.displayName
    }
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      // 現在ログインしているユーザーの情報を取得する
      let user = Auth.auth().currentUser
      
      // もしユーザーのphotoURLが無ければデフォルトを設定する
      if user?.photoURL == nil {
        // もしプロフィール写真が設定されていなかったらデフォルトを設定する
        profielImageSetting.image = UIImage(named: "profielImageDefault")
      } else {
        // もしユーザーのphotoURLが設定済みだったら設定する
        profielImageSetting.sd_setImage(with: user?.photoURL)
        
      }
      
      // ImageViewの枠線を適用する
      self.profielImageSetting.layer.borderColor = UIColor.black.cgColor
      // 枠線の幅を適用する
      self.profielImageSetting.layer.borderWidth = 2
      // 角丸を適用する
      self.profielImageSetting.layer.cornerRadius = 30
      // 角丸に合わせて画像をマスクする
      self.profielImageSetting.layer.masksToBounds = true
      
      // 表示名を変更ボタンの角を取る
      self.handleChangerButton.layer.cornerRadius = 30
      // 角丸に合わせてボタンをマスクする
      self.handleChangerButton.layer.masksToBounds = true
      
      // UIImageViewなどはもともと検知を受け取らない設定なのでユーザーインタラクションを有効に設定する
      profielImageSetting.isUserInteractionEnabled = true
      
      // UITapGestureRecognizerをprofielImageSettingに設定する
      let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SettingViewController.appearanceAlert(_:)))
      
      // SettingViewControllerに追加する
      self.profielImageSetting.addGestureRecognizer(tapGesture)
      
      // デリゲートをセットする
      tapGesture.delegate = self
      
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  // profielImageSettingをタップした時に呼ばれるメソッド
  @objc func appearanceAlert(_ sender: UITapGestureRecognizer) {
    
    print("DEBUG:PRINT: profielImageSettingがタップされました")
    
    // UIAlertControllerのインスタンスを生成
    let alertView: UIAlertController = UIAlertController(title: "アラート",
                                      message: "サンプル",
                                      preferredStyle: UIAlertControllerStyle.actionSheet)
    
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
  
  

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}


