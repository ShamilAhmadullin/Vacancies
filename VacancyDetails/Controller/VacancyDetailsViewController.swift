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
            checkImageFromCacheAndSetImage(companyLogo: companyLogo)
        }
    }
    
    private func checkImageFromCacheAndSetImage(companyLogo: String) {
        if let imageFromCache = Cache.imageCache.object(forKey: companyLogo as AnyObject) as? UIImage {
            companyLogoImageView.image = imageFromCache
        } else {
            addCacheAndSetImage(companyLogo: companyLogo)
        }
    }
    
    private func addCacheAndSetImage(companyLogo: String) {
        if let url = URL(string: companyLogo) {
            companyLogoImageView.downloaded(from: url) { image in
                Cache.imageCache.setObject(image, forKey: companyLogo as AnyObject)
            }
        }
    }
}
