//
//  Utilities.swift
//  Jukeboxd
//
//  Created by Matthew Barker on 2/16/20.
//  Copyright © 2020 Matthew Barker. All rights reserved.
//

import UIKit

func presentErrorAlert(title: String, message: String, on controller: UIViewController) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
    alert.addAction(action)
    controller.present(alert, animated: true)
}

func formattedDateString(for date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle  = .long
    let dateString = formatter.string(from: date)
    return dateString
}
