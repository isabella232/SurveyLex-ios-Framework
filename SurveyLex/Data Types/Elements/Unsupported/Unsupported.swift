//
//  UnsupportedQuestion.swift
//  SurveyLex
//
//  Created by Jia Rui Shan on 2019/6/30.
//  Copyright © 2019 UC Berkeley. All rights reserved.
//

import UIKit
import SwiftyJSON

/// Represents a generic, unsupported cell in a SurveyLex survey.
class UnsupportedQuestion: Question, CustomStringConvertible {
    
    // Inherited
    
    var fragment: Fragment?
    var completed = true
    var parentView: SurveyViewController?
    var isRequired = false
    var order: (fragment: Int, question: Int)
    
    var type: ResponseType {
        return .unsupported
    }
    
    var description: String {
        return "Unsupported cell <\(title)>"
    }
    
    func makeContentCell() -> SurveyElementCell {
        return UnsupportedCell(unsupportedQuestion: self)
    }
    
    var responseJSON: JSON {
        return JSON() // Need to be replaced
    }
    
    // Custom instance variables
    
    /// The title of the unsupported question.
    let title: String
    
    /// The unsupported type name as a `String`.
    var typeString = ""
    
    required init(json: JSON, order: (Int, Int), fragment: Fragment?) {
        let dictionary = json.dictionaryValue

        guard let title = dictionary["title"]?.string else {
            print(json)
            preconditionFailure("Attribute 'title' is not given")
        }
        
        self.fragment = fragment
        self.order = order
        self.title = title
    }
}