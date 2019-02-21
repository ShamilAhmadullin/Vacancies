//
//  VacanciesViewController.swift
//  Vacancies
//
//  Created by Shamil on 08/02/2019.
//  Copyright © 2019 ShamCode. All rights reserved.
//

import UIKit
import Kingfisher

final class VacanciesViewController: UIViewController {
    
    @IBOutlet weak private var vacanciesTableView: UITableView!
    @IBOutlet weak var professionSearchBar: UISearchBar!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    private var vacancies: [Vacancy] = []
    private var searchProfession = "java"
    private var page = 1
    private var selectedRow = 0
    private var isThereAreVacancies = true
    private var isSearchProfessionChanged = false
    
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
            if vacancies.count == 0 {
                self.isThereAreVacancies.toggle()
            } else {
               self.vacancies += vacancies
            }
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
                self.activityIndicatorView.isHidden = true
                self.vacanciesTableView.reloadData()
                if self.isSearchProfessionChanged {
                    self.isSearchProfessionChanged.toggle()
                    self.vacanciesTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
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
            cell.vacancyLogo.kf.setImage(with: URL(string: companyLogo))
        } else {
            cell.vacancyLogo.image = nil
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
        if isThereAreVacancies {
            checkLastItemAndGetVacancies(lastItem, indexPath)
        }
    }
    
    private func checkLastItemAndGetVacancies(_ lastItem: Int, _ indexPath: IndexPath) {
        if lastItem == indexPath.row {
            page += 1
            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimating()
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
            isThereAreVacancies = true
            isSearchProfessionChanged = true
            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimating()
            getVacancies(search: searchProfession, page: page)
        }
        view.endEditing(true)
    }
}
