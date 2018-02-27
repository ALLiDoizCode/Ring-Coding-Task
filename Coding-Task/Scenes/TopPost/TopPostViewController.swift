//
//  TopPostViewController.swift
//  Coding-Task
//
//  Created by Jonathan on 2/26/18.
//  Copyright (c) 2018 Jonathan. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol TopPostDisplayLogic: class {
    func displayTopPost(viewModel: [TopPost.Listing.ListingModel])
}

class TopPostViewController: UIViewController, TopPostDisplayLogic, UITableViewDelegate, UITableViewDataSource {
    var interactor: TopPostBusinessLogic?
    var router: (NSObjectProtocol & TopPostRoutingLogic & TopPostDataPassing)?
    
    var top50:[TopPost.Listing.ListingModel] = []
    @IBOutlet weak var tableView: UITableView!
    // MARK: Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: Setup

    private func setup() {
        let viewController = self
        let interactor = TopPostInteractor()
        let presenter = TopPostPresenter()
        let router = TopPostRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: Routing

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.estimatedRowHeight = 100.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        getTopPost(after:"")
    }

    // MARK: DataSource Methods

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return top50.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt index: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Post") as! PostTableViewCell
        let url = URL(string: top50[index.row].thumbnail)
        let createdDate = Date(timeIntervalSince1970: Double(top50[index.row].created))
        let dateOffset = Date().offsetFrom(date: createdDate)
        cell.author.text = top50[index.row].author
        cell.comments.text = "\(top50[index.row].num_comments ?? 0) comments"
        cell.title.text = top50[index.row].title
        cell.timeCreated.text = "\(dateOffset) Ago"
        cell.preview = top50[index.row].preview
        cell.parentController = self
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                if let imageData = data {
                    cell.thumbNail.image = UIImage(data: imageData)
                }
                
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = top50.count - 1
        if indexPath.row == lastElement {
            getTopPost(after:top50.last?.after ?? "")
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func getTopPost(after:String) {
        var request = TopPost.Listing.Request()
        request.after = after
        interactor?.getTopPost(request: request)
    }

    func displayTopPost(viewModel: [TopPost.Listing.ListingModel]) {
        
        if viewModel.count == 50 {
            top50 += viewModel
            print(viewModel.count)
        }
        DispatchQueue.main.async { // Correct
            self.tableView.reloadData()
        }
        
        
    }
}
