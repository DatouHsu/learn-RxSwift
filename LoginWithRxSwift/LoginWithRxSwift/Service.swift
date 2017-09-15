//
//  Service.swift
//  LoginWithRxSwift
//
//  Created by DatouHsu on 9/3/17.
//  Copyright © 2017 datouHsu. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ValidationService {
  static let instance = ValidationService()
  let minCharactersCount = 6
  private init() {}

  func validateUserName(_ username: String) -> Observable<Result> {
    if username.characters.count == 0 {
      return .just(.empty)
    }

    if username.characters.count < minCharactersCount {
      return .just(.failed(message:"帳號長度至少6個字元"))
    }
    return .just(.ok(message:"帳號可用"))
  }

  func validatePassword(_ password: String) -> Result {
    if password.characters.count == 0 {
      return .empty
    }
    if password.characters.count < minCharactersCount {
      return .failed(message:"密碼長度至少6個字元")
    }
    return .ok(message:"密碼可用")
  }

  func validateRepeatedPassword(_ password: String, repeatedPasswordword: String) -> Result {
    if repeatedPasswordword.characters.count == 0 {
      return .empty
    }
    if repeatedPasswordword == password {
      return .ok(message:"密碼可用")
    }
    return .failed(message:"密碼不一樣, 驗證失敗")
  }

  func register(_ username: String, password: String) -> Observable<Result> {
    let userDic = [username: password]
    let filePath = NSHomeDirectory() + "/Documents/users.plist"
    if (userDic as NSDictionary).write(toFile: filePath, atomically: true) {
      return .just(.ok(message: "註冊成功"))
    }
    return .just(.failed(message: "註冊失敗"))
  }

}
