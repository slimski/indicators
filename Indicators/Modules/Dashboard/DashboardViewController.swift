//
//  DashboardViewController.swift
//  Indicators
//
//  Created by Igor Nabokov on 05/01/2018.
//  Copyright © 2018 Igor Nabokov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DashboardViewController: UIViewController {
    @IBOutlet weak var mainTableView: UITableView!

    // temp models initializer
    var models: Variable<[SensorViewModel]> = Variable([SensorViewModel(sensor: PressureModel()), SensorViewModel(sensor: AccelerometerModel())])

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupTableView()
    }

    private func setupUI() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    private func setupTableView() {
        models
            .asObservable()
            .bind(to: mainTableView.rx.items(cellIdentifier: ChartTableViewCell.identifier, cellType: ChartTableViewCell.self)) { _, model, cell in
            cell.sensorViewModel = model
        }.disposed(by: disposeBag)

        mainTableView.rx.modelSelected(SensorViewModel.self).subscribe { (event) in
            switch event {
            case .next(let model):
                let vc = UIStoryboard.loadDetailViewController()
                vc?.sensorViewModel = model
                self.navigationController?.pushViewController(vc!, animated: true)
            default: break
            }
        }.disposed(by: disposeBag)
    }
}
