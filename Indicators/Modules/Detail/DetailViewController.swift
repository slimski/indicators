//
//  ViewController.swift
//  Indicators
//
//  Created by Igor Nabokov on 17/12/2017.
//  Copyright © 2017 Igor Nabokov. All rights reserved.
//

import UIKit
import CoreMotion
import Charts
import UIColor_Hex_Swift

class DetailViewController: UIViewController {
    
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var unitsLabel: UILabel!
    
    let sensorModel = PressureModel.instance

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        sensorModel.completion = { [weak self] in
            self?.updateValues()
        }
    }
    
    private func setupUI() {
        titleLabel.text = sensorModel.title
        unitsLabel.text = sensorModel.units
        valueLabel.text = "0"
        setupChartView()
    }
    
    private func setupChartView() {
        lineChartView.chartDescription?.enabled = false
        lineChartView.dragEnabled = false
        lineChartView.setScaleEnabled(true)
        lineChartView.pinchZoomEnabled = false
        
        lineChartView.leftAxis.enabled = false
        lineChartView.rightAxis.enabled = false
        lineChartView.xAxis.enabled = false
        
        lineChartView.legend.form = .empty
        lineChartView.drawGridBackgroundEnabled = false
        
        lineChartView.animate(xAxisDuration: 2.5)
    }

    private func updateValues() {
        let values = sensorModel.values
            .sorted(by: { $0.0 < $1.0 })
            .suffix(10)
            .map { ChartDataEntry(x: $0, y: $1) }
        valueLabel.text = "\(Int(values.last?.y ?? 0))"
        let set1 = LineChartDataSet(values: values, label: "")
        set1.drawIconsEnabled = false
        set1.setColor(UIColor("#F04848"))
        set1.lineWidth = 2
        set1.drawCirclesEnabled = false
        set1.drawCircleHoleEnabled = false
        set1.drawValuesEnabled = false
        set1.mode = .horizontalBezier
        
        set1.drawFilledEnabled = false
        
        let data = LineChartData(dataSet: set1)
        
        lineChartView.data = data
    }
}

