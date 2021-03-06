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
import RxSwift
import RxCocoa

class DetailViewController: UIViewController {

    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var unitsLabel: UILabel!

    static let identifier = "DetailViewController"

    var sensorViewModel: SensorViewModel? {
        didSet {
            if self.isViewLoaded {
                setupViewModel()
            }
        }
    }

    private var disposeBag = DisposeBag()
    private var values = [Double: Double]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
    }

    private func setupUI() {
        valueLabel.text = "0"
        setupChartView()
    }

    private func setupViewModel() {
        guard let svm = sensorViewModel else { return }
        svm.values.subscribe { [weak self] (event) in
            guard let `self` = self else { return }
            switch event {
            case .next(let values):
                self.values[values.0] = values.1
                if self.isViewLoaded {
                    self.update(with: self.values)
                }
            default:
                break
            }
            }.disposed(by: disposeBag)
        svm.title.bind(to: self.titleLabel.rx.text).disposed(by: disposeBag)
        svm.units.bind(to: self.unitsLabel.rx.text).disposed(by: disposeBag)
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

    private func update(with values: [Double: Double]) {
        guard let sensorViewModel = self.sensorViewModel else { return }
        let values = values
            .sorted(by: { $0.0 < $1.0 })
            .suffix(10)
            .map { ChartDataEntry(x: $0, y: $1) }
        let lastValue = values.last?.y ?? 0
        valueLabel.text = "\(lastValue.format(using: sensorViewModel.valueFormat))"
        let set1 = LineChartDataSet(values: values, label: "")
        set1.drawIconsEnabled = false
        set1.setColor(UIColor(sensorViewModel.mainColorHex))
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
