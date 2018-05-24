//
//  SelfManagementViewController.swift
//  OneMore
//
//  Created by 池田優作 on 2018/03/06.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SDWebImage
import RealmSwift
import SVProgressHUD

class SelfManagementViewController: UIViewController, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
  @IBOutlet weak var userName: UINavigationItem!
  @IBOutlet weak var profielView: UIView!
  @IBOutlet weak var dreamTextView: UITextView!
  @IBOutlet weak var profielImageView: UIImageView!
  @IBOutlet weak var recordLabel: UILabel!
  @IBOutlet weak var focusLabel: UILabel!
  @IBOutlet weak var nextView: UIView!
  @IBOutlet weak var stackView: UIStackView!
  @IBOutlet weak var totalPhotoButton: UIButton!
  @IBOutlet weak var categoryPhotoButton: UIButton!
  
  // XibTotalPhotoViewの型にして変数を宣言する
  var totalXib: XibTotalPhotoView!
  // XibCategoryPhotoViewを型にして変数を宣言する
  var categoryXib: XibCategoryPhotoView!
  

  var postArray: [PostData] = []
  
  // OneMoreのDatabase上にchildメソッドで値を格納するGoalDreamを作成する
  var goalRef = Database.database().reference().child(Goal.Setting)
  
  // DatabaseのobserveEventの登録状態を表す
  var observing = false
  
  let realm = try! Realm()
  
  let morningArray = try! Realm().objects(Morning.self).sorted(byKeyPath: "id", ascending: false).filter("userName == %@", Auth.auth().currentUser?.displayName ?? "")
  let noonArray = try! Realm().objects(Noon.self).sorted(byKeyPath: "id",ascending: false).filter("userName == %@", Auth.auth().currentUser?.displayName ?? "")
  let nightArray = try! Realm().objects(Night.self).sorted(byKeyPath: "id", ascending: false).filter("userName == %@", Auth.auth().currentUser?.displayName ?? "")
  let upperBodyArray = try! Realm().objects(UpperBody.self).sorted(byKeyPath: "id", ascending: false).filter("userName == %@", Auth.auth().currentUser?.displayName ?? "")
  let lowerBodyArray = try! Realm().objects(LowerBody.self).sorted(byKeyPath: "id", ascending: false).filter("userName == %@", Auth.auth().currentUser?.displayName ?? "")
  let chestArray = try! Realm().objects(Chest.self).sorted(byKeyPath: "id", ascending: false).filter("userName == %@", Auth.auth().currentUser?.displayName ?? "")
  let backArray = try! Realm().objects(Back.self).sorted(byKeyPath: "id", ascending: false).filter("userName == %@", Auth.auth().currentUser?.displayName ?? "")
  let absArray = try! Realm().objects(Abs.self).sorted(byKeyPath: "id", ascending: false).filter("userName == %@", Auth.auth().currentUser?.displayName ?? "")
  let bicepsArray = try! Realm().objects(Biceps.self).sorted(byKeyPath: "id", ascending: false).filter("userName == %@", Auth.auth().currentUser?.displayName ?? "")
  let tricepsArray = try! Realm().objects(Triceps.self).sorted(byKeyPath: "id", ascending: false).filter("userName == %@", Auth.auth().currentUser?.displayName ?? "")
  let sholderArray = try! Realm().objects(Sholder.self).sorted(byKeyPath: "id", ascending: false).filter("userName == %@", Auth.auth().currentUser?.displayName ?? "")
  let legArray = try! Realm().objects(Leg.self).sorted(byKeyPath: "id", ascending: false).filter("userName == %@", Auth.auth().currentUser?.displayName ?? "")
  let calfArray = try! Realm().objects(Calf.self).sorted(byKeyPath: "id", ascending: false).filter("userName == %@", Auth.auth().currentUser?.displayName ?? "")
  let allArray = try! Realm().objects(All.self).sorted(byKeyPath: "id", ascending: false).filter("userName == %@", Auth.auth().currentUser?.displayName ?? "")
  
  override func viewDidLoad() {
        super.viewDidLoad()
  
    // インスタンスの生成
    totalXib = XibTotalPhotoView()
    categoryXib = XibCategoryPhotoView()
    
    // totalXibのcollectionViewにdelegateとdataSourceを設定する
    totalXib.totalCollectionView.dataSource = self
    totalXib.totalCollectionView.delegate = self
    
    // totalXibに表示するcellを登録する
    let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
    totalXib.totalCollectionView.register(nib, forCellWithReuseIdentifier: "Cell")
    
    // 最初に画面が呼び出された時はtotalPhotoButtonをタップ状態にする
    totalPhotoButton.isSelected = true
    let totalPhotoTappedImage = UIImage(named: "totalPhotoBlue.png")
    totalPhotoButton.setImage(totalPhotoTappedImage, for: .normal)
    
    // アプリを起動した時にnextViewにTotalPhotoViewを表示させる
    totalXib.frame = CGRect(x: 0, y: 203, width: self.view.frame.width, height: 400)
    // viewにtotalXibを表示する
    nextView.addSubview(totalXib)
    
    // TextViewにデリゲートを設定する
    dreamTextView.delegate = self
    // TextViewの編集を無効にする
    dreamTextView.isEditable = false
    
    // profielImageViewを丸く表示する
    self.profielImageView.layer.cornerRadius = 40
    // 角丸に合わせて画像をマスクする
    self.profielImageView.layer.masksToBounds = true
    
    // profielViewに下線を表示する
    let weightBorder = CALayer()
    weightBorder.frame = CGRect(x: 0, y: profielView.frame.height, width: profielView.frame.width, height: 1.0)
    weightBorder.backgroundColor = UIColor.lightGray.cgColor
    // Viewに追加する
    profielView.layer.addSublayer(weightBorder)
    // stackViweに下線を表示する
    let weightBorders = CALayer()
    weightBorders.frame = CGRect(x: 0, y: stackView.frame.height, width: stackView.frame.width, height: 1.0)
    weightBorders.backgroundColor = UIColor.lightGray.cgColor
    stackView.layer.addSublayer(weightBorders)
    // timeViewに下線をつける
    let timeViewBorder = CALayer()
    timeViewBorder.frame = CGRect(x: 0, y: categoryXib.timeView.frame.height, width: categoryXib.timeView.frame.width, height: 1.0)
    timeViewBorder.backgroundColor = UIColor.lightGray.cgColor
   categoryXib.timeView.layer.addSublayer(timeViewBorder)
    // timeViewに横線をつける
    let timeViewSideBorder = CALayer()
    timeViewSideBorder.frame = CGRect(x: 100, y: 10, width: 1.0, height: 100)
    timeViewSideBorder.backgroundColor = UIColor.lightGray.cgColor
    categoryXib.timeView.layer.addSublayer(timeViewSideBorder)
    // muscleViewに横線をつける
    let muscleSideBorder = CALayer()
    muscleSideBorder.frame = CGRect(x: 100, y: 10, width: 1.0, height: 370)
    muscleSideBorder.backgroundColor = UIColor.lightGray.cgColor
    categoryXib.muscleView.layer.addSublayer(muscleSideBorder)
    // morningButtonに下線をつける
    let morningBorder = CALayer()
    morningBorder.frame = CGRect(x: 0, y: categoryXib.morningButton.frame.height, width: categoryXib.morningButton.frame.width, height: 1.0)
    morningBorder.backgroundColor = UIColor.lightGray.cgColor
    categoryXib.morningButton.layer.addSublayer(morningBorder)
    // noonButtonに下線をつける
    let noonBorder = CALayer()
    noonBorder.frame = CGRect(x: 0, y: categoryXib.noonButton.frame.height, width: categoryXib.noonButton.frame.width, height: 1.0)
    noonBorder.backgroundColor = UIColor.lightGray.cgColor
    categoryXib.noonButton.layer.addSublayer(noonBorder)
    // upperBodyButtonに下線をつける
    let upperBodyBorder = CALayer()
    upperBodyBorder.frame = CGRect(x: 0, y: categoryXib.upperBodyButton.frame.height, width: categoryXib.upperBodyButton.frame.width, height: 1.0)
    upperBodyBorder.backgroundColor = UIColor.lightGray.cgColor
    categoryXib.upperBodyButton.layer.addSublayer(upperBodyBorder)
    // lowerBodyButtonに下線をつける
    let lowerBodyBorder = CALayer()
    lowerBodyBorder.frame = CGRect(x: 0, y: categoryXib.lowerBodyButton.frame.height, width: categoryXib.lowerBodyButton.frame.width, height: 1.0)
    lowerBodyBorder.backgroundColor = UIColor.lightGray.cgColor
    categoryXib.lowerBodyButton.layer.addSublayer(lowerBodyBorder)
    // chestButtonに下線をつける
    let chestBorder = CALayer()
    chestBorder.frame = CGRect(x: 0, y: categoryXib.chestButton.frame.height, width: categoryXib.chestButton.frame.width, height: 1.0)
    chestBorder.backgroundColor = UIColor.lightGray.cgColor
    categoryXib.chestButton.layer.addSublayer(chestBorder)
    // backButtonに下線をつける
    let backBorder = CALayer()
    backBorder.frame = CGRect(x: 0, y: categoryXib.backButton.frame.height, width: categoryXib.backButton.frame.width, height: 1.0)
    backBorder.backgroundColor = UIColor.lightGray.cgColor
    categoryXib.backButton.layer.addSublayer(backBorder)
    // absButtonに下線をつける
    let absBorder = CALayer()
    absBorder.frame = CGRect(x: 0, y: categoryXib.absButton.frame.height, width: categoryXib.absButton.frame.width, height: 1.0)
    absBorder.backgroundColor = UIColor.lightGray.cgColor
    categoryXib.absButton.layer.addSublayer(absBorder)
    // bicepsButtonに下線をつける
    let bicepsBorder = CALayer()
    bicepsBorder.frame = CGRect(x: 0, y: categoryXib.bicepsButton.frame.height, width: categoryXib.bicepsButton.frame.width, height: 1.0)
    bicepsBorder.backgroundColor = UIColor.lightGray.cgColor
    categoryXib.bicepsButton.layer.addSublayer(bicepsBorder)
    // tricepsButtonに下線をつける
    let tricepsBorder = CALayer()
    tricepsBorder.frame = CGRect(x: 0, y: categoryXib.tricepsButton.frame.height, width: categoryXib.tricepsButton.frame.width, height: 1.0)
    tricepsBorder.backgroundColor = UIColor.lightGray.cgColor
    categoryXib.tricepsButton.layer.addSublayer(tricepsBorder)
    // sholderButtonに下線をつける
    let sholderBorder = CALayer()
    sholderBorder.frame = CGRect(x: 0, y: categoryXib.sholderButton.frame.height, width: categoryXib.sholderButton.frame.width, height: 1.0)
    sholderBorder.backgroundColor = UIColor.lightGray.cgColor
    categoryXib.sholderButton.layer.addSublayer(sholderBorder)
    // legButtonに下線をつける
    let legBorder = CALayer()
    legBorder.frame = CGRect(x: 0, y: categoryXib.legButton.frame.height, width: categoryXib.legButton.frame.width, height: 1.0)
    legBorder.backgroundColor = UIColor.lightGray.cgColor
    categoryXib.legButton.layer.addSublayer(legBorder)
    
    // 現在ログインしているユーザーの情報を取得する
    let user = Auth.auth().currentUser
    
    // navigationBarのtextにユーザーネームを格納する
    userName.title = user?.displayName
    
    // もしユーザーのphotoURLがなければデフォルトを設定する
    if user?.photoURL == nil {
      profielImageView.image = UIImage(named: "SelfHuman128.png")
    } else {
      // もしユーザーのphotoURLが設定済みだったら設定する
      profielImageView.sd_setImage(with: user?.photoURL)
    }
    
    categoryXib.morningButton.addTarget(self, action: #selector(handleMorning), for: .touchUpInside)
    categoryXib.noonButton.addTarget(self, action: #selector(handleNoon), for: .touchUpInside)
    categoryXib.nightButton.addTarget(self, action: #selector(handleNight), for: .touchUpInside)
    categoryXib.upperBodyButton.addTarget(self, action: #selector(handleUpperBody), for: .touchUpInside)
    categoryXib.lowerBodyButton.addTarget(self, action: #selector(handleLowerBody), for: .touchUpInside)
    categoryXib.chestButton.addTarget(self, action: #selector(handleChest), for: .touchUpInside)
    categoryXib.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
    categoryXib.absButton.addTarget(self, action: #selector(handleAbs), for: .touchUpInside)
    categoryXib.bicepsButton.addTarget(self, action: #selector(handleBiceps), for: .touchUpInside)
    categoryXib.tricepsButton.addTarget(self, action: #selector(handleTriceps), for: .touchUpInside)
    categoryXib.sholderButton.addTarget(self, action: #selector(handleSholder), for: .touchUpInside)
    categoryXib.legButton.addTarget(self, action: #selector(handleLeg), for: .touchUpInside)
    categoryXib.calfButton.addTarget(self, action: #selector(handleCalf), for: .touchUpInside)
        // Do any additional setup after loading the view.
  }
  
  // 画面が表示される直前
  override func viewWillAppear(_ animated: Bool) {
    let allCountString: String = String("\(allArray.count)")
    recordLabel.text = allCountString
    
    let defaultPlace = goalRef.child("texts")
    defaultPlace.observe(.value) { (snapshot: DataSnapshot) in self.dreamTextView.text = (snapshot.value! as AnyObject).description
      print("DEBUG_PRINT: dreamTextViewに文字が表示されました")
    }
    
    // もしFirebase上のGoalDreamのtextsにデータが存在すればfocusLabelを非表示にする
    if let text = self.dreamTextView.text {
      if text.isEmpty {
        self.focusLabel.isHidden = false
      } else {
        self.focusLabel.isHidden = true
      }
    }
    
    // もしもcurrentUserがnilじゃなかったら
    if Auth.auth().currentUser != nil {
      if self.observing == false {
        // 要素が追加されたらpostArrayに追加してCollectionViewを再表示する
        let postRef = Database.database().reference().child(Const.PostPath)
        // observeメソッドでイベントを指定しておくことで、指定イベントが発生した時にクロージャが呼び出される
        postRef.observe(.childAdded, with: { snapshot in
          print("DEBUG_PRINT: .childAddedイベントが発生しました")
          
          // PostDataクラスを生成して受け取ったデータを設定する
          if let uid = Auth.auth().currentUser?.uid {
            let postData = PostData(snapshot: snapshot, myId: uid)
            self.postArray.insert(postData, at: 0)
            
            self.totalXib.totalCollectionView.reloadData()
          }
        })
        // 要素が変更されたら街灯のデータをpostArrayから一度削除した後に新しいデータを追加してCollectionViewを再表示する
        postRef.observe(.childChanged, with: {snapshot in
          print("DEBUG_PRINT: .childChangedイベントが発生しました。")
          
          if let uid = Auth.auth().currentUser?.uid {
            // PostDataクラスを生成して受け取ったデータを設定する
            let postData = PostData(snapshot: snapshot, myId: uid)
            
            // 保持している配列からidが同じものを探す
            var index: Int = 0
            for post in self.postArray {
              if post.id == postData.id {
                index = self.postArray.index(of: post)!
                break
              }
            }
            
            // 差し変えるため一度削除する
            self.postArray.remove(at: index)
            
            // 削除したところに更新済みのデータを追加する
            self.postArray.insert(postData, at: index)
            
            // TableViewを再表示する
            self.totalXib.totalCollectionView.reloadData()
          }
        })
        
        // DatabaseのobserveEventが上記コードにより登録されたため
        // trueとする
        observing = true
      }
    } else {
      if observing == true {
        // ログアウトを検出したら、一旦テーブルをクリアしてオブザーバーを削除する。
        // テーブルをクリアする
        postArray = []
        totalXib.totalCollectionView.reloadData()
        // オブザーバーを削除する
        Database.database().reference().removeAllObservers()
        
        // DatabaseのobserveEventが上記コードにより解除されたため
        // falseとする
        observing = false
      }
    }
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  @IBAction func totalPhotoAction(_ sender: Any) {
    totalXib.isHidden = false
    let totalButtonTappedImage = UIImage(named: "totalPhotoBlue.png")
    totalPhotoButton.setImage(totalButtonTappedImage, for: .normal)
    let categoryButtonNormalTappedImage = UIImage(named: "categoryPhotoNormal.png")
    categoryPhotoButton.setImage(categoryButtonNormalTappedImage, for: .normal)
    print("totalPhotoがタップされました")
    // TotalPhotoViewを表示する
    totalXib.frame = CGRect(x: 0, y: 203, width: self.view.frame.width, height: 400)
    // viewにtotalXibを表示する
    nextView.addSubview(totalXib)
    
    categoryXib.isHidden = true
    totalXib.totalCollectionView.reloadData()
    categoryPhotoButton.isSelected = false
  }
  
  @IBAction func categoryPhotoAction(_ sender: Any) {
    categoryXib.isHidden = false
    let categoryButtonTappedImage = UIImage(named: "categoryPhotoBlue.png")
    categoryPhotoButton.setImage(categoryButtonTappedImage, for: .normal)
    let totalPhotoButtonNormalTappedImage = UIImage(named: "totalPhotoNormal.png")
    totalPhotoButton.setImage(totalPhotoButtonNormalTappedImage, for: .normal)
    print("categoryPhotoActionがタップされました")
    // CategoryPhotoViewを表示する
    categoryXib.frame = CGRect(x: 0, y: 203, width: self.view.frame.width, height: 400)
    // viewにcategoryXibを追加する
    nextView.addSubview(categoryXib)
    
    totalXib.isHidden = true
    totalPhotoButton.isSelected = false
  }
  
  // textViewがフォーカスされたら、Labelを非表示にする
  func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
    focusLabel.isHidden = true
    return true
  }
  
  // CollectionViewのCellの数を返す
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return postArray.count
  }
  
  // collectionViewのCellの内容を返す
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = totalXib.totalCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
    cell.setPostData(postArray[indexPath.row])
    
    return cell
    
  }
  
  // 各セルを選択した時に実行されるメソッド
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    // セルがタップされた時はcellSegue2で画面遷移をする
    performSegue(withIdentifier: "cellSegue2", sender: nil)
  }
  
  // セルサイズの自動変更を設定する
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    let width: CGFloat = view.frame.width / 3 - 1   // self.viewを/3し、-1は隙間の部分
    let height: CGFloat = width
    
    return CGSize(width: width, height: height)
  }
  
  // textViewからフォーカスが外れて、TextViewが空だったらlabelを再表示する
  func textViewDidEndEditing(_ textView: UITextView) {
    
    // もしtextFieldの値がisEnptyならlabelを表示する
    if let text = dreamTextView.text {
      if text.isEmpty {
        focusLabel.isHidden = false
      }
      focusLabel.isHidden = true
    }
  }
  
  // morningButtonがタップされた時に呼ばれるメソッド
  @objc func handleMorning() {
    performSegue(withIdentifier: "morningSegue", sender: nil)
  }
  // noonButtonがタップされた時に呼ばれるメソッド
  @objc func handleNoon() {
    performSegue(withIdentifier: "noonSegue", sender: nil)
  }
  // nightButtonがタップされた時に呼ばれるメソッド
  @objc func handleNight() {
    performSegue(withIdentifier: "nightSegue", sender: nil)
  }
  @objc func handleUpperBody() {
    performSegue(withIdentifier: "upperBodySegue", sender: nil)
  }
  @objc func handleLowerBody() {
    performSegue(withIdentifier: "lowerBodySegue", sender: nil)
  }
  @objc func handleChest() {
    performSegue(withIdentifier: "chestSegue", sender: nil)
  }
  @objc func handleBack() {
    performSegue(withIdentifier: "backSegue", sender: nil)
  }
  @objc func handleAbs() {
    performSegue(withIdentifier: "absSegue", sender: nil)
  }
  @objc func handleBiceps() {
    performSegue(withIdentifier: "bicepsSegue", sender: nil)
  }
  @objc func handleTriceps() {
    performSegue(withIdentifier: "tricepsSegue", sender: nil)
  }
  @objc func handleSholder() {
    performSegue(withIdentifier: "sholderSegue", sender: nil)
  }
  @objc func handleLeg() {
    performSegue(withIdentifier: "legSegue", sender: nil)
  }
  @objc func handleCalf() {
    performSegue(withIdentifier: "calfSegue", sender: nil)
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // もしcellSegue2で画面遷移をするとき
    if segue.identifier == "cellSegue2" {
      let totalPhotoUpViewController: TotalPhotoUpViewController = segue.destination as! TotalPhotoUpViewController
      
      print("DEBUG_PRINT: セル2がタップされました")
      // 選択したセルをIndexPath型の配列で取得する
      let indexPath = totalXib.totalCollectionView.indexPathsForSelectedItems
      
      print("DEBUG_PRINT+\(String(describing: indexPath))")
      
      // IndexPath型で取得した値をfor文でloopしながら各要素を取得する
      for index in indexPath! {
        // 遷移先画面の変数に
        totalPhotoUpViewController.photoInformation = postArray[index.row]
      }
    
      print("DEBUG_PRINT: \(totalPhotoUpViewController.photoInformation)")
  
    } else if segue.identifier == "settingSegue" {
      print("DEBUG_PRINT: 設定ボタンがタップされました")
      
    } else if segue.identifier == "morningSegue" {
      if morningArray.count == 0 {
        SVProgressHUD.showError(withStatus: "データがありません")
      }
      print("morningButtonがタップされました")
    } else if segue.identifier == "noonSegue" {
      if noonArray.count == 0 {
        SVProgressHUD.showError(withStatus: "データがありません")
      }
      print("noonButtonがタップされました")
    } else if segue.identifier == "nightArray" {
      if nightArray.count == 0 {
        SVProgressHUD.showError(withStatus: "データがありません")
      }
      print("nightButtonがタップされました")
    } else if segue.identifier == "upperBodySegue" {
      if upperBodyArray.count == 0 {
        SVProgressHUD.showError(withStatus: "データがありません")
      }
      print("upperBodyButtonがタップされました")
    } else if segue.identifier == "lowerBodySegue" {
      if lowerBodyArray.count == 0 {
        SVProgressHUD.showError(withStatus: "データがありません")
      }
      print("lowerBodyButtonがタップされました")
    } else if segue.identifier == "chestSegue" {
      if chestArray.count == 0 {
        SVProgressHUD.showError(withStatus: "データがありません")
      }
      print("chestButtonがタップされました")
    } else if segue.identifier == "backSegue" {
      if backArray.count == 0 {
        SVProgressHUD.showError(withStatus: "データがありません")
      }
      print("backButtonがタップされました")
    } else if segue.identifier == "absSegue" {
      if absArray.count == 0 {
        SVProgressHUD.showError(withStatus: "データがありません")
      }
      print("absButtonがタップされました")
    } else if segue.identifier == "bicepsSegue" {
      if bicepsArray.count == 0 {
        SVProgressHUD.showError(withStatus: "データがありません")
      }
      print("bicepsButtonがタップされました")
    } else if segue.identifier == "tricepsSegue" {
      if tricepsArray.count == 0 {
        SVProgressHUD.showError(withStatus: "データがありません")
      }
      print("tricepsButtonがタップされました")
    } else if segue.identifier == "sholderSegue" {
      if sholderArray.count == 0 {
        SVProgressHUD.showError(withStatus: "データがありません")
      }
      print("sholderButtonがタップされました")
    } else if segue.identifier == "legSegue" {
      if legArray.count == 0 {
        SVProgressHUD.showError(withStatus: "データがありません")
      }
      print("legButtonがタップされました")
    } else if segue.identifier == "calfSegue" {
      if calfArray.count == 0 {
        SVProgressHUD.showError(withStatus: "データがありません")
      }
      print("calfButtonがタップされました")
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
