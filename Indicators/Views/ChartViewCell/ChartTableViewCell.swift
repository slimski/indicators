//
//  ChartTableViewCell.swift
//  Indicators
//
//  Created by Igor Nabokov on 09/01/2018.
//  Copyright © 2018 Igor Nabokov. All rights reserved.
//

import UIKit
import Charts
import RxSwift

class ChartTableViewCell: UITableViewCell {
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var unitsLabel: UILabel!
    @IBOutlet weak var borderView: UIView!

    static let identifier = "ChartTableViewCell"

    var sensorViewModel: SensorViewModel? {
        didSet {
            guard let svm = sensorViewModel else { return }
            svm.title.bind(to: titleLabel.rx.text).disposed(by: disposeBag)
            svm.units.bind(to: unitsLabel.rx.text).disposed(by: disposeBag)
            svm.values.subscribe { [weak self] (event) in
                guard let `self` = self else { return }
                switch event {
                case .next(let values):
                    self.values[values.0] = values.1
                    self.update(with: self.values)
                default:
                    break
                }
                }.disposed(by: disposeBag)
        }
    }

    private var values = [Double: Double]()
    private let disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
        setupChartView()
    }

    private func setupUI() {
        self.borderView.layer.cornerRadius = 10
    }

    private func setupChartView() {
        lineChartView.chartDescription?.enabled = false
        lineChartView.dragEnabled = false
        lineChartView.setScaleEnabled(true)
        lineChartView.pinchZoomEnabled = false
        lineChartView.highlightPerTapEnabled = false
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
        unitsLabel.text = "\(lastValue.format(using: sensorViewModel.valueFormat))"
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
