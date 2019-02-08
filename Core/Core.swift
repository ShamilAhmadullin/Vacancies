//
//  Core.swift
//  Vacancies
//
//  Created by Shamil on 08/02/2019.
//  Copyright © 2019 ShamCode. All rights reserved.
//

import UIKit

final class Core {
    
    typealias ParametersDictionary = [String: String]
    typealias CallbackVacanciesResponse = ([Vacancy]) -> ()
    
    /*
     После успешного выполнения возвращает массив объектов, описывающих вакансии с сайта jobs.
    */
    
    static func getVacancies(_ parameters: ParametersDictionary, callback: @escaping CallbackVacanciesResponse) {
        guard var url = URLComponents(string: AppContext.getVacanciesUrl) else { return }
        var queryItems: [URLQueryItem] = []
        for (key, value) in parameters {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        url.queryItems = queryItems
        guard let unwrappedUrl = url.url else { return }
        let request =  URLRequest(url: unwrappedUrl)
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let vacancies = try decoder.decode([Vacancy].self, from: data)
                callback(vacancies)
            } catch {
                print(error)
            }
        }.resume()
    }
}
