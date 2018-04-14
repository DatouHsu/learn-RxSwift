//
//  Protocol.swift
//  LoginWithRxSwift
//
//  Created by DatouHsu on 9/3/17.
//  Copyright © 2017 datouHsu. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

enum Result {
  case ok(message: String)
  case empty
  case failed(message: String)
}

extension Result {
  var isValid: Bool {
    switch self {
    case .ok:
      return true
    default:
      return false
    }
  }

  var textColor: UIColor {
    switch self {
    case .ok:
      return UIColor.green
    case .empty:
      return UIColor.black
    case .failed:
      return UIColor.red
    }
  }

  var description: String {
    switch self {
    case let .ok(message):
      return message
    case .empty:
      return ""
    case let .failed(message):
      return message
    }
  }

}

extension Reactive where Base: UILabel {
  var validationResult: UIBindingObserver<Base, Result> {
    return UIBindingObserver(UIElement: base) { label, result in
      label.textColor = result.textColor
      label.text = result.description
    }
  }
}

extension Reactive where Base: UITextField {
  var inputEnabled: UIBindingObserver<Base, Result> {
    return UIBindingObserver(UIElement: base) { textFiled, result in
      textFiled.isEnabled = result.isValid
    }
  }
}


