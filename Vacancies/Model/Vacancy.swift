//
//  Vacancy.swift
//  Vacancies
//
//  Created by Shamil on 08/02/2019.
//  Copyright © 2019 ShamCode. All rights reserved.
//

struct Vacancy: Decodable {
    
    let id: String
    let type: String
    let url: String
    let createdAt: String
    let company: String
    let location: String
    let title: String
    let description: String
    let howToApply: String
    
    let companyUrl: String?
    let companyLogo: String?
}
