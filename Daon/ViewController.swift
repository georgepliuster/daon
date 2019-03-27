//
//  ViewController.swift
//  Daon
//
//  Created by george liu on 3/27/19.
//  Copyright © 2019 george liu. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITextFieldDelegate {

    
    // MARK: UI Elements --------------------------
    

    @IBOutlet weak var mrzTextField: UITextField!
    
    
    @IBOutlet weak var mrzParsedNameLabel: UILabel!
    
    
    @IBAction func mrzParseButtonTouched(_ sender: Any) {
        var mrz = String()
        mrz = mrzTextField.text!
        
        mrzParsedNameLabel.text = parseMRZ(mrzCode: mrz)

    }
    
    func fizzBuzz() {
        
        for i in 1...100 {
            if ( (i % 15) == 0) {
                print("FizzBuzz")
            }
            else if ( (i % 3) == 0 ) {
                print("fizz")
            }
            else if ( (i % 5) == 0 ) {
                print("buzz")
            }
            else {
                print(i)
            }
        }
        
    }
    
    func parseMRZ(mrzCode: String) -> String {
    
        print( "mzrCode: \(mrzCode)" )
        
        var finalName = String()
        
        // 1. strip off P<USA header
        let end = mrzCode.count - 1 // start counting a zer0
        let mrzNoHeader = mrzCode[5..<end]
        print( "mzrNoHeader: \(mrzNoHeader)" )
        
        // 2. break up mrzNoHeader into two parts: surname & given name
        let result = mrzNoHeader.range(of: "<<",
                                options: NSString.CompareOptions.literal,
                                range: mrzNoHeader.startIndex..<mrzNoHeader.endIndex,
                                locale: nil)
 
        // 3. See if string was found.
        if let range = result {
            
            // 4. Start of range of found string.
            let start = range.lowerBound
            
            // 5. Display string starting at first index.
            let givenName = mrzNoHeader[start..<mrzNoHeader.endIndex]
            print( "givenName: \(givenName)" )
            
            // 6. strip off leading <<
            let newGivenNameStartIndex = givenName.index(start, offsetBy: 2)
            let newGivenName = mrzNoHeader[newGivenNameStartIndex..<mrzNoHeader.endIndex]
            print( "newGivenName: \(newGivenName)" )
            
            // 7. strip off trailing <<<<<<<<
            var counter = 0
            for char in newGivenName.reversed() {

                if (char == "<") {
                    counter += 1
                }
                else {
                    break
                }
            }
            let newGivenNameEnddIndex = givenName.index(newGivenNameStartIndex, offsetBy: (newGivenName.count - counter))
            
            let newerGivenName = mrzNoHeader[newGivenNameStartIndex..<newGivenNameEnddIndex]
            
            // 8. remove any remainng < from given name
            let cleanGivenName = newerGivenName.replacingOccurrences(of: "<", with: " ")
            
            print("cleanGivenName: \(cleanGivenName)")
            
            
            // 9. Display string before first index.
            let surName = mrzNoHeader[mrzNoHeader.startIndex..<start]
            print ( "surName: \(surName)" )
            
            // 10. remmove any < from surname
            let cleanSurName = surName.replacingOccurrences(of: "<", with: " ")
            
            print("cleanSurName: \(cleanSurName)")
            
            // 11. assemble final name.
            print("\nCLEAN FINAL NAME: \(cleanGivenName), \(cleanSurName)")
            
            finalName = cleanGivenName + ", " + cleanSurName
       }
        
        return finalName
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        fizzBuzz()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: TEXTFIELD DELEGATE AND RELATED METHODS ------------------------
    func textFieldShouldReturn(_ mrzTextField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

}   // end class

extension String
{
    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
    
    // for convenience we should include String return
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = self.index(self.startIndex, offsetBy: r.lowerBound)
        let end = self.index(self.startIndex, offsetBy: r.upperBound)
        
        return String(self[start...end])
    }
    
    

}

