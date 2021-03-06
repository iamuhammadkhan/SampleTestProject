//
//  HomeViewController.swift
//  UXBERT-LABS-Test-Project-MK
//
//  Created by Muhammad Khan on 01/11/2020.
//  Copyright © 2020 Muhammad Khan. All rights reserved.
//

import UIKit

final class HomeViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    private lazy var movieViewModel: MoviesViewModel? = nil
    private var dataSource: TableViewDataSource<MovieTableViewCell, Movie>?
    private let searchController = UISearchController(searchResultsController: nil)
    private lazy var searchTerm = "action"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        movieViewModel = MoviesViewModel(delegate: self)
        movieViewModel?.getMoviesData(searchTerm: searchTerm, page: movieViewModel?.page ?? 1)
        dataSource = TableViewDataSource(items: movieViewModel?.getMovies() ?? [], configureCell: { (cell, vm) in
            cell.configureCell(title: vm.title, imageUrl: vm.poster)
        })
        setupTableView()
        setupSearchController()
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: MovieTableViewCell.identifier, bundle: nil),
                           forCellReuseIdentifier: MovieTableViewCell.identifier)
        tableView.dataSource = dataSource
        tableView.delegate = self
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    @IBAction private func favouriteButtonTapped(_ sender: UIBarButtonItem) {
        let vc: FavouriteMoviesViewController = UIStoryboard(storyboard: .main).instantiateViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: MoviesViewModelDelegate {
    func moviesFetched() {
        dataSource?.updateItems(items: movieViewModel?.getMovies() ?? [], page: movieViewModel?.page ?? 1)
        tableView.reloadData()
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 1.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vm = movieViewModel?.getMovie(index: indexPath.row)
        let vc: MovieDetailsViewController = UIStoryboard(storyboard: .main).instantiateViewController()
        vc.movieId = vm?.id ?? ""
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchTerm = searchController.searchBar.text ?? ""
        movieViewModel?.getMoviesData(searchTerm: searchTerm, page: movieViewModel?.page ?? 1)
    }
}
