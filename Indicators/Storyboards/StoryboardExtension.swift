//
//  StoryboardExtension.swift
//  Indicators
//
//  Created by Igor Nabokov on 10/01/2018.
//  Copyright © 2018 Igor Nabokov. All rights reserved.
//

import UIKit

extension UIStoryboard {
    static func loadDetailViewController() -> DetailViewController? {
        return getMainStoryboard().instantiateViewController(withIdentifier: DetailViewController.identifier) as? DetailViewController
    }

    private static func getMainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
}
