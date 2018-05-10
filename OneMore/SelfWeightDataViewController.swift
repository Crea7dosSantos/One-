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
import SVProgressHUD

class SelfWeightDataViewController: UIViewController, ChartViewDelegate, IAxisValueFormatter, UITableViewDelegate, UITableViewDataSource {
  
  
  @IBOutlet weak var chartLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var recordLabel: UILabel!
  @IBOutlet weak var startWeightLabel: UILabel!
  @IBOutlet weak var currentWeightLabel: UILabel!
  @IBOutlet weak var differenceWeightLabel: UILabel!
  @IBOutlet weak var weightView: UIView!
  
  @IBOutlet weak var chartView: LineChartView!
  // UIViewのClassをLineChartViewに変更してChartを表示する
  
  
  // Realmのインスタンスを取得する
  let realm = try! Realm()
  
  // Dateformatterクラスのインスタンスを作成する
  let formatter = DateFormatter()
  
  // Db内のタスクが格納されるリスト
  // 以降内容をアップデートするとリスト内は自動的に更新される
  // Realmファイルで作成したAddWeightのデータを全てtimeDoubleの昇順で取り出す
  var addWeightArray = try! Realm().objects(AddWeight.self).sorted(
    byKeyPath: "timeDouble", ascending: true)
  // Realmファイルで作成したAddWeightのデータを全てtimeの昇順で取り出す
  var addWeightArrays = try! Realm().objects(AddWeight.self).sorted(byKeyPath: "time", ascending: true)
  // Realmファイルで作成したAddWeightのデータを全てtimeの降順で取り出す
  var addWeightArraies = try! Realm().objects(AddWeight.self).sorted(byKeyPath: "time", ascending: false)

  // 配列で型をDouble型の値を定義しておく
  var timeArray: [Double] = []
  var weightArray: [Double] = []
  
  // Date型のインスタンスを生成する
  let date = Date()
  
  override func viewDidLoad() {
        super.viewDidLoad()
    
    // weightViewに下線を表示する
    let weightBorder = CALayer()
    // weightBorderのframeプロパティを設定する。xの値は0、yはweightViewの高さを指定、widthはweightViewの幅を選択、heightは1.0。
    weightBorder.frame = CGRect(x: 0, y: weightView.frame.height, width: weightView.frame.width, height: 1.0)
    weightBorder.backgroundColor = UIColor.lightGray.cgColor
    
    // weightViewにweightBorderを追加する
    weightView.layer.addSublayer(weightBorder)
    
    // Realmから全てのデータを取り出す
    let addWeights = realm.objects(AddWeight.self).sorted(byKeyPath: "time", ascending: true)
    
    // もしaddWeightsの配列の数が0なら
    if addWeights.count == 0 {
      
      startWeightLabel.text = nil
      currentWeightLabel.text = nil
      differenceWeightLabel.text = nil
      
      // もしaddweightsの配列の数が1なら
    } else if addWeights.count == 1 {
      
      let startWeight = addWeights.first
    
      let startWeights = startWeight!.weightDouble
      
      print("DEBUG_PRINT: startWeights: \(String(describing: startWeights))")
      
      let startWeightString: String = String("\(startWeights)")
    
    
      startWeightLabel.text = startWeightString
      currentWeightLabel.text = startWeightString
      differenceWeightLabel.text = nil
      
      // addweightsの配列の数が2以上の時
    } else if addWeights.count <= 2 {
      
      let lastWeight = addWeights.last
      
      let lastWeights = lastWeight!.weightDouble
      
      print("DEBUG_PRINT: lastWeights: \(String(describing: lastWeights))")
      
      let lastWeightString: String = String("\(lastWeights)")
      
      currentWeightLabel.text = lastWeightString
    }
    
    tableView.delegate = self
    tableView.dataSource = self
    
    recordLabel.backgroundColor = UIColor.blue
    recordLabel.text = String("記録")
    
      // 定数に配列の値を格納しておく
      // mapを使用し、変数timeArrayにAddWeightファイルからtimeDoubleプロパティの各要素を格納する
      timeArray = addWeightArray.map {$0.timeDouble}
      // mapを使用し、変数weightArrayにAddWeightファイルからweightDoubleプロパティの各要素を格納する
      weightArray = addWeightArray.map {$0.weightDouble}
    
    // chartViewのxAxisのlabelCountにtimeArrayの配列の各要素の数から-1したものを格納する
    // おそらくstringForValueメソッドでtimeArrayをひとつ多く宣言しているから
    chartView.xAxis.labelCount = timeArray.count - 1
    
    // setChartメソッドに値をセットする
    setChart(y: weightArray, x: timeArray)
    
    // chartViewのxAxisのcaluFormatterのデリゲート先をSelfWeightDataViewControllerにセットする
    chartView.xAxis.valueFormatter = self
        // Do any additional setup after loading the view.
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
    
    // Realmから全てのデータを取り出す
    let addWeights = realm.objects(AddWeight.self).sorted(byKeyPath: "time", ascending: true)
    
    // もしaddWeightsの配列の数が0なら
    if addWeights.count == 0 {
      
      startWeightLabel.text = nil
      currentWeightLabel.text = nil
      differenceWeightLabel.text = nil
      
      // もしaddweightsの配列の数が1なら
    } else if addWeights.count == 1 {
      
      let startWeight = addWeights.first
      
      let startWeights = startWeight!.weightDouble
      
      print("DEBUG_PRINT: startWeights: \(String(describing: startWeights))")
      
      let startWeightString: String = String("\(startWeights)")
      
      
      startWeightLabel.text = startWeightString
      currentWeightLabel.text = startWeightString
      differenceWeightLabel.text = nil
      
      tableView.reloadData()
      
      // addweightsの配列の数が2以上の時
    } else if addWeights.count > 1 {
      
      let startWeight = addWeights.first
      let lastWeight = addWeights.last
      
      let startWeights = startWeight!.weightDouble
      let lastWeights = lastWeight!.weightDouble
      
      print("DEBUG_PRINT: startWeights: \(String(describing: startWeights))")
      print("DEBUG_PRINT: lastWeights: \(String(describing: lastWeights))")
      
      let startWeightString: String = String("\(startWeights)")
      let lastWeightString: String = String("\(lastWeights)")
      
      if startWeights > lastWeights {
        let differenceWeights = startWeights - lastWeights
        
        let differenceWeightString: String = String("-\(differenceWeights)")
        
        let differenceString = String(differenceWeightString.prefix(4))
        
        differenceWeightLabel.text = differenceString
        
      } else if startWeights < lastWeights {
        let differenceWeights = lastWeights - startWeights
        let differenceWeightString: String = String("+\(differenceWeights))")
    
        let differenceString = String(differenceWeightString.prefix(4))
        
        differenceWeightLabel.text = differenceString
      } else if startWeights == lastWeights {
        
        differenceWeightLabel.textAlignment = NSTextAlignment.right
        differenceWeightLabel.text = "0"
        
      }
      
      startWeightLabel.text = startWeightString
      currentWeightLabel.text = lastWeightString
      
      // tableViewを再表示する
      tableView.reloadData()
    }
    
    // 定数に配列の値を格納しておく
    // mapを使用し、timeArrayにaddWeightArrayの各要素をtimeDoubleから引き出した各要素を新しい配列timeArrayに格納する
    let timeArray: [Double] = addWeightArray.map {$0.timeDouble}
    let weightArray: [Double] = addWeightArray.map {$0.weightDouble}
    
    // もしtimeArrayの配列の数が3以下の場合はchartViewを非表示にしchartLabelを表示させる
    if timeArray.count < 3 {
      chartView.isHidden = true
      chartLabel.isHidden = false
      self.view.bringSubview(toFront: chartLabel)
      print("DEBUG_PRINT: log1: \(timeArray.count)")
      
    } else if timeArray.count > 2 {
      
      chartView.isHidden = false
      chartLabel.isHidden = true
      
      print("DEBUG_PRINT: log2: \(timeArray.count)")
    
    // setChartメソッドに値をセットする
    setChart(y: weightArray, x: timeArray)
  }
    tableView.reloadData()
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
  
  // UITableViewDataSourceプロトコルのメソッド
  // データの数(=セルの数)を返すメソッド
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return addWeightArray.count
  }
  
  // 各セルの内容を返すメソッド
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // 再利用可能な cell を得る
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    
    // Cellに値を設定する
    // Cellの値にindexPathでアクセスし設定する
    let addWeight = addWeightArraies[indexPath.row]
    
    if addWeightArrays.count < 1 {
      cell.textLabel?.text = nil
      cell.detailTextLabel?.text = nil
    } else if addWeightArrays.count > 0 {
    cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
    cell.textLabel?.text = addWeight.weight
    cell.detailTextLabel?.text = addWeight.time
    }
    return cell
  }
  
  // UITableViewDelegateプロトコルのメソッド
  // 各セルを選択した時に実行されるメソッド
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // セルがタップされた時はcellSegueで画面遷移をする
    performSegue(withIdentifier: "cellSegue", sender: nil)
  }

  // セルが削除可能なことを伝えるメソッド
  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
    return .delete
  }
  
  // Deleteボタンがタップされた時に呼ばれるメソッド
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      // Realmのデータベースから削除する
      try! realm.write {
        self.realm.delete(self.addWeightArraies[indexPath.row])
        tableView.deleteRows(at: [indexPath], with: .fade)
        
        let timeArray: [Double] = addWeightArray.map {$0.timeDouble}
        let weightArray: [Double] = addWeightArray.map {$0.weightDouble}
        
        SVProgressHUD.showSuccess(withStatus: "体重データを削除しました")
        
        // もしtimeArrayの配列の数が3以下の場合はchartViewを非表示にしchartLabelを表示させる
        if timeArray.count < 3 {
          chartView.isHidden = true
          chartLabel.isHidden = false
          self.view.bringSubview(toFront: chartLabel)
          print("DEBUG_PRINT: log1: \(timeArray.count)")
          
        } else if timeArray.count > 2 {
          
          chartView.isHidden = false
          chartLabel.isHidden = true
          
          print("DEBUG_PRINT: log2: \(timeArray.count)")
          
        }
          
        setChart(y: weightArray, x: timeArray)
      
          
          // Realmから全てのデータを取り出す
        let addWeights = realm.objects(AddWeight.self).sorted(byKeyPath: "time", ascending: true)
        
          print("Test: \(addWeights)")
          
          // もしaddWeightsの配列の数が0なら
          if addWeights.count == 0 {
            
            startWeightLabel.text = nil
            currentWeightLabel.text = nil
            differenceWeightLabel.text = nil
            
            
            // もしaddweightsの配列の数が1なら
          } else if addWeights.count == 1 {
            
            let startWeight = addWeights.first
            
            let startWeights = startWeight!.weightDouble
            
            print("DEBUG_PRINT: startWeights: \(String(describing: startWeights))")
            
            let startWeightString: String = String("\(startWeights)")
            
            
            startWeightLabel.text = startWeightString
            currentWeightLabel.text = startWeightString
            differenceWeightLabel.text = nil
            
            // addweightsの配列の数が2以上の時
          } else if addWeights.count >= 2 {
            
            let startWeight = addWeights.first
            
            let startWeights = startWeight!.weightDouble
            
            let lastWeight = addWeights.last
            
            let lastWeights = lastWeight!.weightDouble
            
            print("DEBUG_PRINT: lastWeights: \(String(describing: lastWeights))")
            
            let startWeightString: String = String("\(startWeights)")
            let lastWeightString: String = String("\(lastWeights)")
            
            startWeightLabel.text = startWeightString
            currentWeightLabel.text = lastWeightString
            
            if startWeights > lastWeights {
              let differenceWeights = startWeights - lastWeights
              
              let differenceWeightString: String = String("-\(differenceWeights)")
              
              let differenceString = String(differenceWeightString.prefix(4))
              
              differenceWeightLabel.text = differenceString
              
            } else if startWeights < lastWeights {
              let differenceWeights = lastWeights - startWeights
              let differenceWeightString: String = String("+\(differenceWeights))")
              
              let differenceString = String(differenceWeightString.prefix(4))
              
              differenceWeightLabel.text = differenceString
              
            } else if startWeights == lastWeights {
              differenceWeightLabel.textAlignment = NSTextAlignment.right
              differenceWeightLabel.text = "0"
              
            }
        }
        tableView.reloadData()
        }
      tableView.reloadData()
      }
    }
  
  // segueで画面遷移する際に呼ばれる
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let selfWeightPlusViewController: SelfWeightPulsViewController = segue.destination as! SelfWeightPulsViewController
    
    // もしcellSegueで画面遷移をするとき
    if segue.identifier == "cellSegue" {
      print("DEBUG_PRINT: セルがタップされました")
      let indexPath = self.tableView.indexPathForSelectedRow
      selfWeightPlusViewController.addWeight = addWeightArraies[indexPath!.row]
    } else {
      print("DEBUG_PRINT: +ボタンがタップされました")
      let addWeight = AddWeight()
      // 定数timeに現在の年数、日付を格納する
      let time = Date.timeIntervalSinceReferenceDate
      // Dateformatterクラスのインスタンスを作成する
      let formatter = DateFormatter()
      // dateFormatterプロパティに値を格納する
      formatter.dateFormat = "yyyy年MM月dd日"
      
      // 定数dateにTimeIntervalのクラスのインスタンスを作成し、定数timeに格納された現在の日付をTimeInterval型の値に変換する
      let date = Date(timeIntervalSinceReferenceDate: TimeInterval(time))
      
      // 定数dateStringにdateに格納された値をString型の値に変換して格納する
      let dateString = formatter.string(from: date)
      addWeight.time = dateString
      
      let addWeightArray = realm.objects(AddWeight.self)
      if addWeightArray.count != 0 {
        addWeight.id = addWeightArray.max(ofProperty: "id")! + 1
      }
      
      selfWeightPlusViewController.addWeight = addWeight
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


