//
//  ConsentCell.swift
//  SurveyLex
//
//  Created by Jia Rui Shan on 2019/6/22.
//  Copyright © 2019 UC Berkeley. All rights reserved.
//

import UIKit

/// A subclass of `SurveyElementCell` that displays a consent form. Consent forms are designed to occupy an *entire* fragment.
class ConsentCell: SurveyElementCell {
    
    /// Shortcut for the completion status of the cell, accessible from the `SurveyElementCell` class.
    override var completed: Bool {
        return consentInfo.completed
    }
    
    /// The `Consent` object which the current cell is presenting.
    var consentInfo: Consent!
    
    private var title: UITextView!
    private var separator: UIView!
    private var bottomSeparator: UIView!
    private var consentText: UITextView!
    private var agreeButton: UIButton!
    private var checkbox: UICheckbox!
    private var prompt: UITextView!

    // MARK: UI setup

    init(consent: Consent) {
        super.init()
        
        self.consentInfo = consent
        
        backgroundColor = .white
        selectionStyle = .none
        
        title = {
            let title = UITextView()
            title.text = consentInfo.title
            if title.text.isEmpty { title.text = "Consent" }
            title.format(as: .title)
            title.textAlignment = .center
            title.translatesAutoresizingMaskIntoConstraints = false
            addSubview(title)
            
            title.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
            title.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: SIDE_PADDING).isActive = true
            title.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -SIDE_PADDING).isActive = true
            
            return title
        }()
        
        separator = makeSeparator(top: true)
        
        consentText = {
            let consent = UITextView()
            consent.text = consentInfo.consentText
            consent.format(as: .consentText)
            consent.translatesAutoresizingMaskIntoConstraints = false
            addSubview(consent)
            
            consent.topAnchor.constraint(equalTo: separator.bottomAnchor,
                                         constant: 20).isActive = true
            consent.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor,
                                          constant: 30).isActive = true
            consent.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor,
                                           constant: -30).isActive = true
            
            return consent
        }()
        
        bottomSeparator = makeSeparator(top: false)
        checkbox = makeCheckbox()
        prompt = makePromptText()
        agreeButton = makeAgreeButton()
    }
    
    private func makeSeparator(top: Bool) -> UIView {
        let separatorLine = UIView()
        separatorLine.backgroundColor = UIColor(white: 0.8, alpha: 1)
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separatorLine)
        
        separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separatorLine.widthAnchor.constraint(equalToConstant: SEPARATOR_WIDTH).isActive = true
        separatorLine.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        if top {
            separatorLine.topAnchor.constraint(equalTo: title.bottomAnchor,
                                               constant: 20).isActive = true
        } else {
            separatorLine.topAnchor.constraint(equalTo: consentText.bottomAnchor,
                                               constant: 20).isActive = true
        }
        
        return separatorLine
    }
    
    // MARK: Prompt & check box
    
    private func makeCheckbox() -> UICheckbox {
        let check = UICheckbox()
        check.format(type: .square)
        check.isChecked = consentInfo.promptChecked
        check.isEnabled = !consentInfo.promptChecked
        check.translatesAutoresizingMaskIntoConstraints = false
        check.widthAnchor.constraint(equalToConstant: 20).isActive = true
        check.heightAnchor.constraint(equalToConstant: 20).isActive = true
        addSubview(check)
        
        check.leftAnchor.constraint(equalTo: consentText.leftAnchor,
                                    constant: 1).isActive = true
        check.topAnchor.constraint(equalTo: bottomSeparator.bottomAnchor,
                                   constant: 24).isActive = true
        
        check.addTarget(self, action: #selector(checkboxPressed), for: .valueChanged)
        
        return check
    }
    
    private func makePromptText() -> UITextView {
        let prompt = UITextView()
        prompt.text = consentInfo.prompt
        prompt.format(as: .subtitle)
        prompt.translatesAutoresizingMaskIntoConstraints = false
        addSubview(prompt)
        
        prompt.topAnchor.constraint(equalTo: checkbox.topAnchor,
                                    constant: -2).isActive = true
        prompt.leftAnchor.constraint(equalTo: checkbox.rightAnchor,
                                     constant: 15).isActive = true
        prompt.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor,
                                      constant: -40).isActive = true
        
        return prompt
    }
    
    private func makeAgreeButton() -> UIButton {
        let button = UIButton()
        button.layer.cornerRadius = 4
        button.backgroundColor = DISABLED_BLUE
        button.setTitleColor(.white, for: .normal)
        button.isUserInteractionEnabled = false

        if consentInfo.completed {
            button.setTitle("Agreed", for: .normal)
        } else {
            button.setTitle("Agree & Continue", for: .normal)
        }
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 49).isActive = true
        button.widthAnchor.constraint(equalToConstant: 220).isActive = true
        
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchDown)
        button.addTarget(self,
                         action: #selector(buttonLifted(_:)),
                         for: [.touchCancel, .touchUpInside, .touchUpOutside, .touchDragExit])
        button.addTarget(self, action: #selector(agreed(_:)), for: .touchUpInside)
        
        addSubview(button)
        
        button.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: prompt.bottomAnchor,
                                    constant: 32).isActive = true
        button.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                       constant: -40).isActive = true
        
        return button
    }
    
    // MARK: Control handlers
    
    @objc private func checkboxPressed() {
        if checkbox.isChecked {
            
            // Enabled color
            agreeButton.backgroundColor = BLUE_TINT
            
            // Enable tap gesture recognition
            agreeButton.isUserInteractionEnabled = true
            
            // Save the check status
            consentInfo.promptChecked = true
        } else {
            
            // Disabled color
            agreeButton.backgroundColor = DISABLED_BLUE
            
            // Disable tap gesture recognition
            agreeButton.isUserInteractionEnabled = false
            
            // Save the check status
            consentInfo.promptChecked = false
        }
        
        
        // Tell the fragment page controller that its information needs to be uploaded again
        surveyPage?.uploaded = false
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        sender.backgroundColor = BUTTON_PRESSED
    }
    
    @objc private func buttonLifted(_ sender: UIButton) {
        UIView.transition(with: sender,
                          duration: 0.15,
                          options: .transitionCrossDissolve,
                          animations: {
                            sender.backgroundColor = BLUE_TINT},
                          completion: nil)
    }
    
    @objc private func agreed(_ sender: UIButton) {
        consentInfo.completed = true
        if consentInfo.parentView!.flipPageIfNeeded() {
            checkbox.isEnabled = false
        }
        
        agreeButton.isUserInteractionEnabled = false
        agreeButton.backgroundColor = DISABLED_BLUE
        agreeButton.setTitle("Agreed", for: .normal)
    }

    
    /// A consent cell should always be focused.
    override func unfocus() {}

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
