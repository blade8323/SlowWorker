//
//  ViewController.swift
//  SlowWorker
//
//  Created by Admin on 26.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var startButton: UIButton!
    @IBOutlet var resultTextView: UITextView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func fetchSomethingFromServer() -> String {
        Thread.sleep(forTimeInterval: 1)
        return "Hi there"
    }
    
    func processData(_ data: String) -> String {
        Thread.sleep(forTimeInterval: 2)
        return data.uppercased()
    }

    func calculatefirstresult(_ data: String) -> String {
        Thread.sleep(forTimeInterval: 3)
        return "Number of chars: \(data.count)"
    }
    
    func calculateSecondResult(_ data: String) -> String {
        Thread.sleep(forTimeInterval: 4)
        return data.replacingOccurrences(of: "E", with: "e")
    }
    
    @IBAction func doWork(_ sender: AnyObject) {
        let startTime = Date()
        resultTextView.text = ""
        startButton.isEnabled = false
        spinner.startAnimating()
        let queue = DispatchQueue.global(qos: .default)
        queue.async {
            let fetchedData = self.fetchSomethingFromServer()
            let processedData = self.processData(fetchedData)
            var firstResult: String!
            var secondResult: String!
            let group = DispatchGroup()
            queue.async(group: group) {
                firstResult = self.calculatefirstresult(processedData)
            }
            queue.async(group: group) {
                secondResult = self.calculateSecondResult(processedData)
            }
            group.notify(queue: queue) {
                let resultSummary = "First [\(firstResult)]\nSecond: [\(secondResult)]"
                DispatchQueue.main.async {
                    self.resultTextView.text = resultSummary
                    self.startButton.isEnabled = true
                    self.spinner.stopAnimating()
                }
                let endTime = Date()
                print("Completed in \(endTime.timeIntervalSince(startTime))")
            }
        }
    }
}

