//
//  TextCell.swift
//  SurveyLex
//
//  Created by Jia Rui Shan on 2019/6/22.
//  Copyright © 2019 UC Berkeley. All rights reserved.
//

import UIKit

class TextCell: SurveyElementCell, UITextFieldDelegate {
    
    var textQuestion: Text!
    var title: UITextView!
    var textfield: UITextField!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(textQuestion: Text) {
        super.init()
        self.textQuestion = textQuestion
        title = makeTextView()
        textfield = makeTextField()
        makeLine()
    }
    
    private func makeTextView() -> UITextView {
        let textView = UITextView()
        let numbered = "\(textQuestion.order.fragment).\(textQuestion.order.question) " + textQuestion.title
        textView.attributedText = TextFormatter.formatted(numbered, type: .title)
        textView.textAlignment = .left
        textView.textColor = .gray
        textView.isUserInteractionEnabled = false
        textView.dataDetectorTypes = .link
        textView.linkTextAttributes[.foregroundColor] = BLUE_TINT
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textView)
        
        textView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                      constant: 20).isActive = true
        textView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor,
                                       constant: 18).isActive = true
        textView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor,
                                        constant: -18).isActive = true
        return textView
    }
    
    
    private func makeTextField() -> UITextField {
        let textfield = UITextField()
        textfield.delegate = self
        textfield.borderStyle = .none
        textfield.clearButtonMode = .whileEditing
        textfield.returnKeyType = .next
        textfield.placeholder = textQuestion.isRequired ? "Required" : "Optional"
        textfield.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textfield)
        
        textfield.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor,
                                        constant: 22).isActive = true
        textfield.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor,
                                         constant: -22).isActive = true
        textfield.heightAnchor.constraint(equalToConstant: 56).isActive = true
        textfield.topAnchor.constraint(equalTo: title.bottomAnchor,
                                       constant:0).isActive = true
        textfield.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        return textfield
    }
    
    private func makeLine() {
        let line = UIView()
        line.backgroundColor = .init(white: 0.9, alpha: 0.9)
        line.translatesAutoresizingMaskIntoConstraints = false
        addSubview(line)
        
        line.leftAnchor.constraint(equalTo: textfield.leftAnchor).isActive = true
        line.rightAnchor.constraint(equalTo: textfield.rightAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        line.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                     constant: -8).isActive = true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        surveyPage?.focus(cell: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.surveyPage?.focusedRow += 1
        return true
    }
    
    override func focus() {
        super.focus()
        title.textColor = .black
        textfield.delegate = nil
        textfield.becomeFirstResponder()
        textfield.delegate = self
    }
    
    override func unfocus() {
        super.unfocus()
        title.textColor = .gray
        textfield.delegate = nil
        textfield.resignFirstResponder()
        textfield.delegate = self
    }

}
