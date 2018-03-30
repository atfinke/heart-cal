//
//  AccessTableViewCell.swift
//  Heart Calendar
//
//  Created by Andrew Finke on 3/25/18.
//  Copyright © 2018 Andrew Finke. All rights reserved.
//

import UIKit

class AccessTableViewCell: UITableViewCell {

    // MARK: - Properties

    var buttonPressed: (() -> Void)?

    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 54.0/255.0, green: 54.0/255.0, blue: 54.0/255.0, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false

        let font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: font)
        return label
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        let font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        return label
    }()

    let button: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false

        let font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.titleLabel?.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)

        button.setTitleColor(.white, for: .normal)
        button.setTitle("Grant Access", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true

        button.backgroundColor = UIColor(red: 190/255.0,
                                         green: 100/255.0,
                                         blue: 100/255.0,
                                         alpha: 1.0)
        return button
    }()

    static let reuseIdentifier = "reuseIdentifier"

    // MARK: - Initalization

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        button.addTarget(self, action: #selector(accessButtonPressed), for: .touchUpInside)

        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(button)

        isUserInteractionEnabled = true

        let constraints = [
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            descriptionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),

            button.heightAnchor.constraint(greaterThanOrEqualToConstant: 45),
            button.leftAnchor.constraint(equalTo: descriptionLabel.leftAnchor),
            button.rightAnchor.constraint(equalTo: descriptionLabel.rightAnchor),
            button.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Other

    @objc
    func accessButtonPressed() {
        buttonPressed?()
    }

    func disableButton() {
        button.isEnabled = false
        button.backgroundColor = button.backgroundColor?.withAlphaComponent(0.75)
    }
}