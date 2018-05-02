//
//  SelfWeightDataViewController.swift
//  OneMore
//
//  Created by 池田優作 on 2018/03/06.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import UIKit
import Charts
import RealmSwift

class SelfWeightDataViewController: UIViewController, ChartViewDelegate, IAxisValueFormatter {
  
  @IBOutlet weak var textLabel: UILabel!
  @IBOutlet weak var startLabel: UILabel!
  @IBOutlet weak var currentLabel: UILabel!
  @IBOutlet weak var changeLabel: UILabel!
  @IBOutlet weak var chartLabel: UILabel!
  // UIViewのClassをLineChartViewに変更してChartを表示する
  @IBOutlet weak var chartView: LineChartView!
  
  // Realmのインスタンスを取得する
  let realm = try! Realm()
  
  // Dateformatterクラスのインスタンスを作成する
  let formatter = DateFormatter()
  
  // Db内のタスクが格納されるリスト
  // 以降内容をアップデートするとリスト内は自動的に更新される
  // Realmファイルで作成したAddWeightのデータを全てtimeDoubleの昇順で取り出す
  var addWeightArray = try! Realm().objects(AddWeight.self).sorted(byKeyPath: "timeDouble", ascending: true)

  // 配列で型をDouble型の値を定義しておく
  var timeArray: [Double] = []
  var weightArray: [Double] = []
  
  // Date型のインスタンスを生成する
  let date = Date()
  
  override func viewDidLoad() {
        super.viewDidLoad()
    
      // 定数に配列の値を格納しておく
      // mapを使用し、変数timeArrayにAddWeightファイルからtimeDoubleプロパティの各要素を格納する
      timeArray = addWeightArray.map {$0.timeDouble}
      // mapを使用し、変数weightArrayにAddWeightファイルからweightDoubleプロパティの各要素を格納する
      weightArray = addWeightArray.map {$0.weightDouble}
    
    // もしtimeArrayの配列の数が3以下の場合はchartViewを非表示にしchartLabelを表示させる
    if timeArray.count < 3 {
      chartView.isHidden = true
      chartLabel.isEnabled = false
      
    } else if timeArray.count > 3 {
      
      chartView.isHidden = false
      chartLabel.isEnabled = true
    
    // chartViewのxAxisのlabelCountにtimeArrayの配列の各要素の数から-1したものを格納する
    // おそらくstringForValueメソッドでtimeArrayをひとつ多く宣言しているから
    chartView.xAxis.labelCount = timeArray.count - 1
    
    // setChartメソッドに値をセットする
    setChart(y: weightArray, x: timeArray)
    
    // chartViewのxAxisのcaluFormatterのデリゲート先をSelfWeightDataViewControllerにセットする
    chartView.xAxis.valueFormatter = self
        // Do any additional setup after loading the view.
    }
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  // setChartメソッドを作成しchartViewにセットする値を格納する
  func setChart(y: [Double], x: [Double]) {
    
    // x軸設定
    // chartのx軸のlabelのpositionを下に表示する
    chartView.xAxis.labelPosition = .bottom
    
    
    // y軸設定
    // 右軸の表示を非表示にする
    chartView.rightAxis.enabled = false
    // 左軸の表示をtrueにする
    chartView.leftAxis.enabled = true
    
    
    // その他のUI設定
    // データがない場合の表示する文字
    chartView.noDataText = "体重を追加してください"
    // chartViewのピンチ・ズームをさせない
    chartView.pinchZoomEnabled = false
    // chartViewのダブルタップをさせない
    chartView.doubleTapToZoomEnabled = false
    // chartViewのドラッグアンドドロップをさせない
    chartView.dragEnabled = false
  
    // 体重(y軸)を保持する配列
    // ChartDataEntryクラスのインスタンスを配列で作成する
    var dataentries = [ChartDataEntry]()
    
    // for文でxの体重の数だけchartDataEntryクラスのインスタンス変数にappendメソッドで追加する
    for i in 0..<x.count {
      dataentries.append(ChartDataEntry(x: Double(i), y: y[i]))
    }
    // グラフをUIViewにセット
    let chartDataSet = LineChartDataSet(values: dataentries, label: "体重")
    chartView.data = LineChartData(dataSet: chartDataSet)
 
  }
  
  
  // 体重管理画面が再び表示される時に呼び出される
  override func viewWillAppear(_ animated: Bool) {
    // もしtimeArrayの配列の数が3以下の場合はchartViewを非表示にしchartLabelを表示させる
    if timeArray.count < 3 {
      chartView.isHidden = true
      chartLabel.isHidden = false
      
    } else if timeArray.count > 3{
      
      chartView.isHidden = false
      chartLabel.isHidden = true
    // 定数に配列の値を格納しておく
    // mapを使用し、timeArrayにaddWeightArrayの各要素をtimeDoubleから引き出した各要素を新しい配列timeArrayに格納する
    let timeArray: [Double] = addWeightArray.map {$0.timeDouble}
    let weightArray: [Double] = addWeightArray.map {$0.weightDouble}
   
    // setChartメソッドに値をセットする
    setChart(y: weightArray, x: timeArray)
  }
  }
  
  
  // stringForValueメソッドでx軸のラベルの表示を変更する
  // valueにはデータのインデックスが入ってくる
  func stringForValue(_ value: Double, axis: AxisBase?) -> String {
    
    timeArray = addWeightArray.map {$0.timeDouble}
    
    if timeArray.count < 3 {
      return ""
    }
    // dateFormatterプロパティに値を格納する
    formatter.dateFormat = "MM/dd"
    // 定数dateにtimeArrayの添字にメソッドの引数valueを格納しTimeInterval型にしたものをDate型で格納する
    let date = Date(timeIntervalSinceReferenceDate: TimeInterval(timeArray[Int(value)]))
    // 定数dateStringにdouble型で取得している引数valueを先ほどのformatterを使用してString型に変換する
    let dateString: String = formatter.string(from: date)
    
     print("DEBUG_PRINT: \(dateString)")
    
        return dateString
  
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
