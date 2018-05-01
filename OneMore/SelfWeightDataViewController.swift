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
  // UIViewのClassをLineChartViewに変更してChartを表示する
  @IBOutlet weak var chartView: LineChartView!
  
  // Realmのインスタンスを取得する
  let realm = try! Realm()
  
  // Dateformatterクラスのインスタンスを作成する
  let formatter = DateFormatter()
  
  // Db内のタスクが格納されるリスト
  // 日付近い順\順でソート: 降順
  // 以降内容をアップデートするとリスト内は自動的に更新される
  // Realmファイルで作成したAddWeightのtimeDoubleから値を全て取り出す
  var addWeightTimeArray = try! Realm().objects(AddWeight.self).sorted(byKeyPath: "timeDouble", ascending: false)
  // Realmファイルで作成したAddWeightのweightDoubleから値を全て取り出す
  var addWeightWeightArray = try! Realm().objects(AddWeight.self).sorted(byKeyPath: "weightDouble", ascending: false)
 
  var timeArray: [Double] = []
  var weightArray: [Double] = []
  let date = Date()
  
  override func viewDidLoad() {
        super.viewDidLoad()
    
    // 定数に配列の値を格納しておく
    // mapを使用し、timeArrayにaddWeightArrayの各要素をtimeDoubleから引き出した各要素を新しい配列timeArrayに格納する
    timeArray = addWeightTimeArray.map {$0.timeDouble}
    weightArray = addWeightWeightArray.map {$0.weightDouble}
    
    chartView.xAxis.labelCount = timeArray.count - 1
    
    // setChartメソッドに値をセットする
    setChart(y: weightArray, x: timeArray)
    
    chartView.xAxis.valueFormatter = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func setChart(y: [Double], x: [Double]) {
    
    // x軸設定
    // chartのx軸のlabelのpositionを下に表示する
    chartView.xAxis.labelPosition = .bottom
    // chartのx軸に表示するラベルの数を設定する
    chartView.xAxis.labelCount = Int(6)
    
    // y軸設定
    // 右軸の表示を非表示にする
    chartView.rightAxis.enabled = false
    // 左軸の表示をtrueにする
    chartView.leftAxis.enabled = true
    
    
    // その他のUI設定
    // データがない場合の表示する文字
    chartView.noDataText = "体重を追加してください"
    chartView.pinchZoomEnabled = false
    chartView.doubleTapToZoomEnabled = false
    chartView.dragEnabled = false
    

    // 体重(y軸)を保持する配列
    // ChartDataEntryクラスのインスタンスを作成する
    var dataentries = [ChartDataEntry]()
    
    // enumeratedメソッドで体重の各要素にindexを与えながらループを回す
    // valに各要素が入りその各要素にiのindexを与えている
    for i in 0..<x.count {
      dataentries.append(ChartDataEntry(x: x[i], y: y[i]))
    }
    // グラフをUIViewにセット
    let chartDataSet = LineChartDataSet(values: dataentries, label: "体重")
    chartView.data = LineChartData(dataSet: chartDataSet)
 
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    // 定数に配列の値を格納しておく
    // mapを使用し、timeArrayにaddWeightArrayの各要素をtimeDoubleから引き出した各要素を新しい配列timeArrayに格納する
    let timeArray: [Double] = addWeightTimeArray.map {$0.timeDouble}
    let weightArray: [Double] = addWeightWeightArray.map {$0.weightDouble}
    
   
    
    // setChartメソッドに値をセットする
    setChart(y: weightArray, x: timeArray)
    
   
  }
  
  func stringForValue(_ value: Double, axis: AxisBase?) -> String {
    
    // dateFormatterプロパティに値を格納する
    formatter.dateFormat = "MM/dd"
    let date = Date(timeIntervalSinceReferenceDate: TimeInterval(value))
    // 定数dateStringにdouble型で取得している引数valueを先ほどのformatterを使用してString型に変換する
    let dateString: String = formatter.string(from: date)
 
 
    let timeArray: [Double] = addWeightTimeArray.map {$0.timeDouble}
 
    
    
    
        return String(timeArray[Int(value)])
  
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
