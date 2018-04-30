
//
//  XibDateView.swift
//  OneMore
//
//  Created by 池田優作 on 2018/04/24.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import UIKit

// プロトコルを宣言する
protocol XibDateViewDelegate: class {
  // メソッドを定義する
  // 完了ボタンがタップされたのを伝播するメソッド
  // このプロトコルを継承するクラスはsendPerfectを実装していないとダメ
  func sendPerfect(date: Date)
}

class XibDateView: UIView {

  // プロトコルを型に宣言をする
  weak var delegate: XibDateViewDelegate? = nil
  
  @IBOutlet weak var datePicker: UIDatePicker!
  @IBOutlet weak var stopDate: UIBarButtonItem!
  @IBOutlet var DateView: UIView!
  
  override func awakeFromNib() {
    // datePickerのdatePickerModeに.dateを格納する
    datePicker.datePickerMode = .date
    // localに構造体のLocaleを使用してidentifierに値をString型で格納する
    datePicker.locale = Locale(identifier: "ja")
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    loadNib()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    loadNib()
  }
  
  func loadNib() {
    let view = Bundle.main.loadNibNamed("DatePickerBarView", owner: self, options: nil)?.first as! UIView
    view.frame = self.bounds
    self.addSubview(view)
  }
  
  @IBAction func stopDateAction(_ sender: Any) {
    // print文で出力させる
    print("DEBUG_PRINT: stopDateActionがタップされました。")
    // xibファイルのviewを閉じる
    removeFromSuperview()
  }
  
  @IBAction func perfectAction(_ sender: Any) {
    // print文で出力させる
    print("DEBUG_PRINT: perfectActionがタップされました。")
    // タップされた時にSelfWeightPlusViewControllerのdateButtonのtextを変更し、DatePickerを閉じる
    // DatePicker.dateで現在のdateをsendPerfectの引数として取り出す
    self.delegate?.sendPerfect(date: datePicker.date)
    // removeFromSuperViewで完了ボタンをタップした時に現在表示してるxibファイルを閉じる
    removeFromSuperview()

  }
  /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
