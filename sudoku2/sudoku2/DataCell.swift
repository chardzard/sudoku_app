//
//  DataCell.swift
//  sudoku2
//
//  Created by Richard Sage on 2016-01-25.
//  Copyright © 2016 Richard Sage. All rights reserved.
//

import UIKit

//this custom cell holds a custom textfield and keeps track of location on the grid
class DataCell: UICollectionViewCell {

    @IBOutlet weak var textField: SudokuTextField!
    
    
    var xIndex = 0
    var yIndex = 0
}
