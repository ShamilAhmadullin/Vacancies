//
//  VacanciesViewController.swift
//  Vacancies
//
//  Created by Shamil on 08/02/2019.
//  Copyright © 2019 ShamCode. All rights reserved.
//

import UIKit

final class VacanciesViewController: UIViewController {
    
    @IBOutlet weak private var vacanciesTableView: UITableView!
    @IBOutlet weak var professionSearchBar: UISearchBar!
    
    private var vacancies: [Vacancy] = []
    private var searchProfession = "java"
    private var page = 1
    private var selectedRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarLargeTitle()
        setDelegateAndDataSource()
        getVacancies(search: searchProfession, page: page)
    }
    
    private func setNavigationBarLargeTitle() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setDelegateAndDataSource() {
        vacanciesTableView.delegate = self
        vacanciesTableView.dataSource = self
        professionSearchBar.delegate = self
    }
    
    // MARK: - API
    
    private func getVacancies(search: String, page: Int) {
        Core.getVacancies(VacanciesParameters(search: search, page: page).parameters) { [weak self] vacancies in
            guard let self = self else { return }
            self.vacancies += vacancies
            DispatchQueue.main.async {
                self.vacanciesTableView.reloadData()
            }
        }
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationController = segue.destination as! VacancyDetailsViewController
        destinationController.vacancy = vacancies[selectedRow]
    }
}

// MARK: - UITableViewDataSourse

extension VacanciesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vacancies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.vacancyСell.rawValue, for: indexPath) as! VacanciesTableViewCell
        cell.vacancyTitle.text = vacancies[indexPath.row].title
        cell.vacancyCity.text = vacancies[indexPath.row].location
        setVacancyComanyLogo(cell: cell, indexPath: indexPath)
        return cell
    }
    
    private func setVacancyComanyLogo(cell: VacanciesTableViewCell, indexPath: IndexPath) {
        if let companyLogo = vacancies[indexPath.row].companyLogo {
            checkImageFromCacheAndSetImage(cell: cell, companyLogo: companyLogo)
        } else {
            cell.vacancyLogo.image = nil
        }
    }
    
    private func checkImageFromCacheAndSetImage(cell: VacanciesTableViewCell, companyLogo: String) {
        if let imageFromCache = Cache.imageCache.object(forKey: companyLogo as AnyObject) as? UIImage {
            cell.vacancyLogo.image = imageFromCache
        } else {
            addCacheAndSetImage(cell: cell, companyLogo: companyLogo)
        }
    }
    
    private func addCacheAndSetImage(cell: VacanciesTableViewCell, companyLogo: String) {
        if let url = URL(string: companyLogo) {
            cell.vacancyLogo.downloaded(from: url) { image in
                Cache.imageCache.setObject(image, forKey: companyLogo as AnyObject)
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension VacanciesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        performSegue(withIdentifier: SegueIdentifiers.vacancyDetailsSegue.rawValue, sender: self)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastItem = vacancies.count - 1
        if lastItem == indexPath.row {
            page += 1
            getVacancies(search: searchProfession, page: page)
        }
    }
}

// MARK: - UISearchBarDelegate

extension VacanciesViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let profession = professionSearchBar.text {
            searchProfession = profession
            page = 1
            vacancies = []
            getVacancies(search: searchProfession, page: page)
        }
        view.endEditing(true)
    }
}
