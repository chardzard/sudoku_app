//
//  SudokuTextFieldDelegate.swift
//  sudoku2
//
//  Created by Richard Sage on 2016-02-07.
//  Copyright © 2016 Richard Sage. All rights reserved.
//

import UIKit

@objc protocol SudokuDelegate : UITextFieldDelegate, NSObjectProtocol {
    optional func textField(textField: SudokuTextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    optional func textFieldDidEndEditing(textField: SudokuTextField)
}

class SudokuTextFieldDelegate : UIViewController {
    
    var delegate: SudokuDelegate! {
        get { return self.delegate as SudokuDelegate }
        set { self.delegate = newValue }
    }
    
}
