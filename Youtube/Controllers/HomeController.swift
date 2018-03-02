//
//  ViewController.swift
//  Youtube
//
//  Created by AI Local Admin on 07/12/17.
//  Copyright © 2017 AI Local Admin. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController {
    
    // MARK: - Properties
    lazy var settingLauncher: SettingsLauncher = {
        let sl = SettingsLauncher()
        sl.homeController = self
        return sl
    }()
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.homeController = self
        mb.translatesAutoresizingMaskIntoConstraints = false
        return mb
    }()
    let titles: [String] = ["Home", "Trending", "Subscriptions", "Account"]
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
    }
    
    // MARK: - Private Methods
    fileprivate func setupNavigationBar() {
        navigationItem.title = "Home"
        navigationController?.navigationBar.isTranslucent = false
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 32, height: self.view.frame.height))
        titleLabel.text = "Home"
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textColor = UIColor.white
        navigationItem.titleView = titleLabel
        
        setupMenuBar()
        setupNavBarButtons()
    }
    
    fileprivate func setupCollectionView() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        collectionView?.backgroundColor = .white
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: Constants.CellId.cellId)
        collectionView?.register(TrendingCell.self, forCellWithReuseIdentifier: Constants.CellId.trendingCellId)
        collectionView?.register(SubcriptionCell.self, forCellWithReuseIdentifier: Constants.CellId.subscriptionCellId)
        collectionView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0) // set collection view top underneath the menuBar.
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0) // set collection Scroll underneath the menuBar.
        
        collectionView?.isPagingEnabled = true
    }
    
    func setupNavBarButtons()  {
        let searchImage = UIImage(named: "search_icon")?.withRenderingMode(.alwaysOriginal)
        let moreImage = UIImage(named: "nav_more_icon")?.withRenderingMode(.alwaysOriginal)
        
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        let moreBarButtonItem = UIBarButtonItem(image: moreImage, style: .plain, target: self, action: #selector(handleMore))
        navigationItem.rightBarButtonItems = [moreBarButtonItem, searchBarButtonItem]
    }
    
    @objc func handleSearch() {
        scrollToMenuIndex(menuIndex: 2)
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: .left, animated: true)
        setTitleForIndex(index: menuIndex)
    }
    private func setTitleForIndex(index: Int) {
        
        if let titleLabel = navigationItem.titleView as? UILabel {
            titleLabel.text = "  \(self.titles[index])"
        }
    }
    @objc func handleMore() {
        // show menu
        settingLauncher.showSettigns()
    }
    func showControllerForSettings(setting: Setting) {
        let viewController = UIViewController()
        viewController.navigationItem.title = setting.name.rawValue
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.pushViewController(viewController, animated: true)
    }
   
     fileprivate func setupMenuBar() {
        navigationController?.hidesBarsOnSwipe = true
        
        let redView = UIView()
        redView.translatesAutoresizingMaskIntoConstraints = false
        redView.backgroundColor = Constants.Color.defaultBarColor
        
        view.addSubview(redView)
        view.addConstriantsWith(format: "H:|[v0]|", views: redView)
        view.addConstriantsWith(format: "V:[v0(50)]", views: redView)
        
        view.addSubview(menuBar)
        view.addConstriantsWith(format: "H:|[v0]|", views: menuBar)
        view.addConstriantsWith(format: "V:[v0(50)]", views: menuBar)
        
        menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    // MARK: Scroll View
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 4
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        
        let indexPath = IndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition())
        
        setTitleForIndex(index: Int(index))
    }
    
    // MARK: - Collection View Data Source.
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var identifier: String = Constants.CellId.cellId
        
        if indexPath.item == 1 {
            identifier = Constants.CellId.trendingCellId
            
        } else if indexPath.item == 1 {
            identifier = Constants.CellId.subscriptionCellId
            
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! FeedCell
        return cell
        
    }
    

    
}
extension HomeController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 50)
    }
}

