//
//  VacancyDetailsViewController.swift
//  Vacancies
//
//  Created by Shamil on 08/02/2019.
//  Copyright © 2019 ShamCode. All rights reserved.
//

import UIKit

final class VacancyDetailsViewController: UIViewController {
    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var companyLabel: UILabel!
    @IBOutlet weak private var locationLabel: UILabel!
    @IBOutlet weak private var companyUrlTextView: UITextView!
    @IBOutlet weak private var descriptionTextView: UITextView!
    @IBOutlet weak private var companyLogoImageView: UIImageView!
    
    var vacancy: Vacancy?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setVacancyDetails()
    }
    
    private func setVacancyDetails() {
        guard let vacancy = vacancy else { return }
        titleLabel.text = vacancy.title
        companyLabel.text = vacancy.company
        locationLabel.text = vacancy.location
        descriptionTextView.text = vacancy.description.stripOutHtml()
        if let companyUrl = vacancy.companyUrl {
            companyUrlTextView.text = companyUrl
        }
        if let companyLogo = vacancy.companyLogo {
            companyLogoImageView.kf.setImage(with: URL(string: companyLogo))
        }
    }
}
