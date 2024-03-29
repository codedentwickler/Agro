//
//  UITextField+ErrorHandling.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 10/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit

private var rightViews = NSMapTable<UITextField, UIView>(keyOptions: NSPointerFunctions.Options.weakMemory, valueOptions: NSPointerFunctions.Options.strongMemory)
private var errorViews = NSMapTable<UITextField, UIView>(keyOptions: NSPointerFunctions.Options.weakMemory, valueOptions: NSPointerFunctions.Options.strongMemory)

extension UITextField {
    // Add/remove error message
    func setError(_ string: String? = nil, show: Bool = true) {
        if let rightView = rightView, rightView.tag != 999 {
            rightViews.setObject(rightView, forKey: self)
        }

        // Remove message
        guard string != nil else {
            if let rightView = rightViews.object(forKey: self) {
                self.rightView = rightView
                rightViews.removeObject(forKey: self)
            } else {
                self.rightView = nil
            }

            if let errorView = errorViews.object(forKey: self) {
                errorView.isHidden = true
                errorViews.removeObject(forKey: self)
            }

            return
        }

        // Create container
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        // Create triangle
        let triagle = TriangleTop()
        triagle.backgroundColor = .clear
        triagle.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(triagle)

        // Create red line
        let line = UIView()
        line.backgroundColor = .red
        line.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(line)

        // Create message
        let label = UILabel()
        label.text = string
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13)
        label.backgroundColor = .transparent
        label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 250), for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let labelContainer = UIView()
        labelContainer.backgroundColor = UIColor.black
        labelContainer.translatesAutoresizingMaskIntoConstraints = false
        labelContainer.addSubview(label)
        container.addSubview(labelContainer)

        // Set constraints for triangle
        triagle.heightAnchor.constraint(equalToConstant: 10).isActive = true
        triagle.widthAnchor.constraint(equalToConstant: 15).isActive = true
        triagle.topAnchor.constraint(equalTo: container.topAnchor, constant: -10).isActive = true
        triagle.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15).isActive = true

        // Set constraints for line
        line.heightAnchor.constraint(equalToConstant: 3).isActive = true
        line.topAnchor.constraint(equalTo: triagle.bottomAnchor, constant: 0).isActive = true
        line.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0).isActive = true
        line.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0).isActive = true
        
        // Set constraints for label container
        labelContainer.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 0).isActive = true
        labelContainer.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 0).isActive = true
        labelContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0).isActive = true
        labelContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0).isActive = true

        // Set constraints for label
        label.topAnchor.constraint(equalTo: labelContainer.topAnchor, constant: 0).isActive = true
        label.bottomAnchor.constraint(equalTo: labelContainer.bottomAnchor, constant: 0).isActive = true
        label.leadingAnchor.constraint(equalTo: labelContainer.leadingAnchor, constant: 4).isActive = true
        label.trailingAnchor.constraint(equalTo: labelContainer.trailingAnchor, constant: -4).isActive = true

        if !show {
            container.isHidden = true
        }
        
        container.cornerRadius = CGFloat(2.0)
        
        self.addSubview(container)

        // Set constraints for container
        container.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 1).isActive = true
        container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        container.topAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true

        // Hide other error messages
        let enumerator = errorViews.objectEnumerator()
        while let view = enumerator!.nextObject() as! UIView? {
            view.isHidden = true
        }

        // Add right button to textField
        let errorButton = UIButton(type: .custom)
        errorButton.tag = 999
        errorButton.setImage(UIImage(named: "ic_error"), for: .normal)
        errorButton.frame = CGRect(x: 0, y: 0, width: frame.size.height, height: frame.size.height)
        errorButton.addTarget(self, action: #selector(errorAction), for: .touchUpInside)
        rightView = errorButton
        rightViewMode = .always

        // Save view with error message
        errorViews.setObject(container, forKey: self)
    }

    // Show error message
    @IBAction
    func errorAction(_ sender: Any) {
        let errorButton = sender as! UIButton
        let textField = errorButton.superview as! UITextField

        let errorView = errorViews.object(forKey: textField)
        if let errorView = errorView {
            errorView.isHidden.toggle()
        }

        let enumerator = errorViews.objectEnumerator()
        while let view = enumerator!.nextObject() as! UIView? {
            if view != errorView {
                view.isHidden = true
            }
        }

        // Don't hide keyboard after click by icon
//        UIViewController.isCatchTappedAround = false
    }
}

class TriangleTop: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        context.beginPath()
        context.move(to: CGPoint(x: (rect.maxX / 2.0), y: rect.minY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        context.addLine(to: CGPoint(x: (rect.minX / 2.0), y: rect.maxY))
        context.closePath()

        context.setFillColor(UIColor.red.cgColor)
        context.fillPath()
    }
}
