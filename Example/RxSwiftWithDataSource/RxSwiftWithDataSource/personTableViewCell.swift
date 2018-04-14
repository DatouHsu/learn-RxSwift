//
//  personTableViewCell.swift
//  RxSwiftWithDataSource
//
//  Created by DatouHsu on 9/29/17.
//  Copyright © 2017 polydice. All rights reserved.
//

import UIKit

class personTableViewCell: UITableViewCell {

  @IBOutlet weak var label1: UILabel!
  @IBOutlet weak var label2: UILabel!

  var person: Person! {
    didSet {
      updateUI()
    }
  }

  private func updateUI(){
    self.label1.text = person.name
    self.label2.text = "\(person.age)"
  }

}
