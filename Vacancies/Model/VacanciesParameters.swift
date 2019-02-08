//
//  VacanciesParameters.swift
//  Vacancies
//
//  Created by Shamil on 08/02/2019.
//  Copyright © 2019 ShamCode. All rights reserved.
//

struct VacanciesParameters {
    
    let parameters: [String: String]
    
    /*
     search - запрос по которому хотите найти вакансии (например "java").
     page -  номер страницы, начиная с которой выдается ответ.
    */
    
    init(search: String, page: Int) {
        
        let parameters = ["search": search, "page": String(page)]
        
        self.parameters = parameters
    }
}
