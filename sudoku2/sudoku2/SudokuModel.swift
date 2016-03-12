//
//  SudokuModel.swift
//  sudoku2
//
//  Created by Richard Sage on 2016-02-03.
//  Copyright © 2016 Richard Sage. All rights reserved.
//

import Foundation

//this class handles loading the puzzle database
class SudokuModel {
    
    var content : [String]!
    
    init() {
       self.readDatabase("sudoku")
    }
    
    func readDatabase(fileName: String) {
        guard let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "db")
            else {return}
        var toReturn : [String] = []
        
        do {
            let content = try String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            toReturn = content.componentsSeparatedByString("\n")
        }
        catch _ as NSError{
            
        }
        
        self.content = toReturn
        
    }
    
    func getPuzzles() -> [String] {
        return content
    }
    
}