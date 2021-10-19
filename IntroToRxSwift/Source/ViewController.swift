//
//  ViewController.swift
//  IntroToRxSwift
//
//  Created by Gabriel on 18/10/21.
//

import UIKit
import RxSwift
import RxCocoa


struct ProductModel {
    let imageName: String
    let title: String
}

struct ProductViewModel {
    var items = PublishSubject<[ProductModel]>()
    
    func fetchItems() {
        let products = [
            ProductModel(imageName: "house", title: "Home"),
            ProductModel(imageName: "gear", title: "Settings"),
            ProductModel(imageName: "person.circle", title: "Profile"),
            ProductModel(imageName: "airplane", title: "Fligths"),
            ProductModel(imageName: "bell", title: "Activity"),
        ]
        
        items.onNext(products)
        items.onCompleted()
    }
}
class ViewController: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell" )
        return table
    }()
    
    private var viewModel = ProductViewModel()
    private var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindTableData()
    }
    
    func setupTableView(){
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
    
    func bindTableData() {
        //Bind items to table
        viewModel.items.bind(to:
            tableView.rx.items(
                cellIdentifier: "cell",
                cellType: UITableViewCell.self)
        ) { row, model, cell in
            cell.textLabel?.text = model.title
            cell.imageView?.image = UIImage(systemName: model.imageName)
        }.disposed(by: bag)
        
        
        //Bind a model selected handler
        tableView.rx.modelSelected(ProductModel.self).bind { product in
            print(product.title)
        }.disposed(by: bag)
        
        
        //Fetch Items
        viewModel.fetchItems()
    }
    
}

