//
//  SudokuTextField.swift
//  sudoku2
//
//  Created by Richard Sage on 2016-02-07.
//  Copyright © 2016 Richard Sage. All rights reserved.
//

import UIKit

//this custom textfield also keeps track of the location on the grid and does some minor formatting
class SudokuTextField: UITextField {

    var xIndex = 0
    var yIndex = 0
     
    override func awakeFromNib() {
        super.awakeFromNib()        
        borderStyle = UITextBorderStyle.None
    }
}
