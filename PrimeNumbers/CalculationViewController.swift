//
//  ViewController.swift
//  PrimeNumbers
//
//  Created by Орлов Максим on 06.07.2018.
//  Copyright © 2018 Орлов Максим. All rights reserved.
//

import UIKit

class CalculationViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var sieveTextField: UITextField!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var resutLabel: UILabel!
    @IBOutlet weak var seePrimeNumbersList: UIButton!
    
    var sieveResult = [Int]()
    var primeNumbersSum = 0
    var n: Int?
    let digitsLimit = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTextField()
        setupGestureRecognizer()
    }
    
    private func setupView() {
        activityIndicator.isHidden = true
        calculateButton.layer.cornerRadius = 15
        seePrimeNumbersList.layer.cornerRadius = 15
    }
    
    private func setupTextField() {
        sieveTextField.delegate = self
        sieveTextField.keyboardType = .decimalPad
    }
    
    private func setupGestureRecognizer() { //MARK: Скрываем клавиатуру по нажатию на экран
        let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func activityIndicatorStartAnimating() { //MARK: Запускаем активити индикатор
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func activityIndicatorStopAnimating() { //MARK: Выключаем активити индикатор
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }

    @IBAction func calculate(_ sender: UIButton) {
        guard let n = Int((sieveTextField.text)!) else { //MARK: Если числа нет - показыаве алерт
            showNoDigitsAlert()
            return
        }
        self.n = n
        activityIndicatorStartAnimating()
        resutLabel.isHidden = true
          DispatchQueue.global(qos: .userInteractive).async {
            let sieveResult = self.sieveOfEratosthenes(n: n)
            let primeNumbersSum = self.sieveSum(primeArr: sieveResult)
            DispatchQueue.main.async {
                self.activityIndicatorStopAnimating()
                self.resutLabel.isHidden = false
                self.sieveResult = sieveResult
                self.primeNumbersSum = primeNumbersSum
                self.resutLabel.text = ("Сумма всех простых чисел до \(n) - \(String(primeNumbersSum))")
            }
        }
    }
    
    @IBAction func showPrimeNumbersList(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let resultVC = storyBoard.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
        let navController = UINavigationController(rootViewController: resultVC)
        resultVC.primeNumbersSum = primeNumbersSum
        resultVC.sieveResult = sieveResult
        resultVC.n = n
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    private func showNoDigitsAlert() {
        let ac = UIAlertController(title: "Необходимо ввести число", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        ac.addAction(okAction)
        self.present(ac, animated: true, completion: nil)
    }
}

extension CalculationViewController { //MARK: Поиск простых чисел по алгоритму - Решето Эратосфена
    
    private func sieveOfEratosthenes(n: Int) -> [Int] {
        
        if n <= 1 {
            return []
        }
        
        var sieve = [Int]()
        var boolArray = [Bool](repeating: false, count: n + 1)
        for i in 2...n {
            if !boolArray[i] {
                sieve.append(i)
                for multiple in stride(from: i * i, through: n, by: i) {
                    boolArray[multiple] = true
                }
            }
        }
        return sieve
    }
    
    private func sieveSum(primeArr: [Int])  -> Int {
        return primeArr.reduce(0, +)
    }
}

extension CalculationViewController: UITextFieldDelegate { //MARK: TextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let allowedCharacters = CharacterSet.decimalDigits
        let charactersSet = CharacterSet(charactersIn: string)
        let newLength = text.count + string.count - range.length
        return allowedCharacters.isSuperset(of: charactersSet) && newLength < digitsLimit
    }
}
