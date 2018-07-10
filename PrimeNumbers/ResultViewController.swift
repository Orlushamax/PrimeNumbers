//
//  ResultViewController.swift
//  PrimeNumbers
//
//  Created by Орлов Максим on 07.07.2018.
//  Copyright © 2018 Орлов Максим. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var sieveResult = [Int]()
    var primeNumbersSum = 0
    var n: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        guard let n = n else { return }
        resultLabel.text = ("Сумма всех простых чисел до \(n) - \(String(primeNumbersSum))")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupNavigationController()
    }
    
    @objc func backAction() -> Void {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ResultCell")
    }
    
    private func setupNavigationController() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Назад", style: .done, target: self, action: #selector(backAction))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.darkGray
    }
}

extension ResultViewController: UITableViewDataSource { //MARK: TableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sieveResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath)
        cell.textLabel?.text = String(sieveResult[indexPath.row])
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        cell.selectionStyle = .none
        return cell
    }
}
