//
//  ViewController.swift
//  sudoku2
//
//  Created by Richard Sage on 2016-01-25.
//  Copyright © 2016 Richard Sage. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate {
    //winning and losing labels
    @IBOutlet weak var winner: UILabel!
    @IBOutlet weak var loser: UILabel!
    
    //attributes
    let len = 9
    var countCells = 0
    let puzzles : SudokuModel = SudokuModel()
    var currentPuzzle : String = ""
    var puzzleArray : [String] = []
    //array of cells
    var cellArray = [[DataCell]] (count: 9, repeatedValue: [DataCell](count: 9, repeatedValue: DataCell()))
    var columnCount = 0
    var rowCount = 0
    
    //view
    @IBOutlet weak var myView: UICollectionView!
    
    //default
    override func viewDidLoad() {
        super.viewDidLoad()
        puzzleArray = puzzles.getPuzzles()
        currentPuzzle = puzzleArray[Int(arc4random_uniform(UInt32(puzzleArray.count)))]
        winner.hidden = true
        loser.hidden = true
        //gesture recognizer
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "endEdit")
        view.addGestureRecognizer(tap)
    }
    
    //gesture function
    func endEdit() {
        view.endEditing(true)
    }
    
    //default
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //number of cells
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 81
    }
    
    //creating the data cells
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DataCell", forIndexPath: indexPath) as! DataCell;
        
        //filling indices
        cell.xIndex = countCells / len;
        cell.yIndex = countCells % len;
        cellArray[cell.xIndex][cell.yIndex] = cell
        cell.textField.xIndex = countCells / len
        cell.textField.yIndex = countCells % len
        
        //changing color
        rowCount = countCells % 9
        columnCount = countCells / 9
        
        //filling text and modifying prefilled cells
        if(currentPuzzle.characters.count > 0) {
            cell.textField.keyboardType = UIKeyboardType.NumberPad
            let stringIndex = currentPuzzle.startIndex.advancedBy(countCells)
            if(stringIndex.distanceTo(currentPuzzle.endIndex) > 0 && currentPuzzle[stringIndex] != ".") {
                cell.textField.text = String(currentPuzzle[stringIndex])
                cell.textField.userInteractionEnabled = false
                cell.backgroundColor = UIColor.grayColor()
            }
            else {
                cell.textField.text = ""
            }
        }
        
        //format the cell
        formatDataCell(cell, indexPath: indexPath, row: rowCount, column: columnCount);
        
        //functions to handle the input when changing and when leaving textfield
        cell.textField.addTarget(self, action: "myTextField:", forControlEvents: UIControlEvents.EditingChanged)
        cell.textField.addTarget(self, action: "editDone:", forControlEvents: UIControlEvents.EditingDidEnd)
        
        countCells++;
        return cell;
    }
    
    //formatting cell initially
    func formatDataCell(cell: DataCell, indexPath: NSIndexPath, row: Int, column: Int) {
        cell.layer.borderWidth = 2;
        if(((rowCount <= 2 || rowCount >= 6) && (columnCount <= 2 || columnCount >= 6)) || (!(rowCount <= 2 || rowCount >= 6) && !(columnCount <= 2 || columnCount >= 6))) {
            cell.layer.borderColor = UIColor.magentaColor().CGColor;
        }
        else {
            cell.layer.borderColor = UIColor.blackColor().CGColor;
        }
        cell.layer.masksToBounds = true;
        cell.layer.cornerRadius = 2;
    }
    
    //reset current puzzle
    @IBAction func resetButton(sender: UIButton) {
        for var i = 0; i < cellArray.count; i++ {
            for var j = 0; j < cellArray[0].count; j++ {
                if(cellArray[i][j].textField.userInteractionEnabled) {
                    cellArray[i][j].textField.text = ""
                    cellArray[i][j].backgroundColor = UIColor.whiteColor()
                }
            }
        }
        winner.hidden = true
        loser.hidden = true
    }
    
    //load new puzzle
    @IBAction func newPuzzle(sender: UIButton) {
        currentPuzzle = puzzleArray[Int(arc4random_uniform(UInt32(puzzleArray.count)))]
        var stringCount = 0
        for var i = 0; i < cellArray.count; i++ {
            for var j = 0; j < cellArray[0].count; j++ {
                let stringIndex = currentPuzzle.startIndex.advancedBy(stringCount)
                if(stringIndex.distanceTo(currentPuzzle.endIndex) > 0 && currentPuzzle[stringIndex] != ".") {
                    cellArray[i][j].textField.text = String(currentPuzzle[stringIndex])
                    cellArray[i][j].textField.userInteractionEnabled = false
                    cellArray[i][j].backgroundColor = UIColor.grayColor()
                }
                else {
                    cellArray[i][j].textField.text = ""
                    cellArray[i][j].textField.keyboardType = UIKeyboardType.NumberPad
                    cellArray[i][j].backgroundColor = UIColor.whiteColor()
                    cellArray[i][j].textField.userInteractionEnabled = true
                }
                stringCount++
            }
        }
        winner.hidden = true
        loser.hidden = true
    }
    
    //this function handles input as it is typed
    func myTextField(textField: SudokuTextField)
    {
        guard let text = textField.text else {return}
        let index = text.startIndex.advancedBy(0)
        if(text == "0") {
            textField.text = ""
        }
        else if(text.characters.count > 1) {
            textField.text = String(text[index])
        }
        else {
            if(!(isValidInput(textField.xIndex, y: textField.yIndex, value: textField.text!)) && textField.text != "") {
                cellArray[textField.xIndex][textField.yIndex].backgroundColor = UIColor.redColor()
                textField.text = ""
            }
            else {
                cellArray[textField.xIndex][textField.yIndex].backgroundColor = UIColor.whiteColor()
            }
        }
    }
    
    //determines if given value at given index is valid in sudoku
    func isValidInput(x: Int, y: Int, value: String) -> Bool {
        for var i = 0; i < 9; i++ {
            if(y != i && cellArray[x][i].textField.text == value) {
                return false
            }
            
            if(x != i && cellArray[i][y].textField.text == value) {
                return false
            }
        }
        
        let r = (x / 3) * 3
        let c = (y / 3) * 3
        for var i = r; i < r + 3; i++ {
            for var j = c; j < c + 3; j++ {
                if ((i != x && j != y) && cellArray[i][j].textField.text == value) {
                    return false
                }
            }
        }
        return true
    }
    
    //handles leaving the cell
    func editDone(textField: SudokuTextField) {
        if(cellArray[textField.xIndex][textField.yIndex].textField.text == "") {
            cellArray[textField.xIndex][textField.yIndex].backgroundColor = UIColor.whiteColor()
        }
        didWin()
        didLose()
    }
    
    //check if the user won by checking if all cells are filled
    func didWin() {
        var didYouWin = true
        
        for var i = 0; i < cellArray.count; i++ {
            for var j = 0; j < cellArray[0].count; j++ {
                if (cellArray[i][j].textField.text == "") {
                    didYouWin = false
                }
            }
        }
        if(didYouWin) {
            winner.hidden = false
        }
    }
    
    //check if the user lost by checking if open cells have valid input
    func didLose() {
        var didYouLose = true
        for var i = 0; i < cellArray.count; i++ {
            for var j = 0; j < cellArray[0].count; j++ {
                if (cellArray[i][j].textField.text == "") {
                    for var k = 1; k <= 9; k++ {
                        if(isValidInput(i, y: j, value: String(k))) {
                            didYouLose = false
                            break
                        }
                    }
                }
            }
        }
        if(didYouLose) {
            loser.hidden = false
        }
    }
}

