//
//  ViewController.swift
//  Jokester
//
//  Created by Nicholas McGinnis on 6/24/21.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var jokeView: UILabel!
	@IBOutlet weak var answerView: UILabel!
	@IBOutlet weak var showAnswerBtn: UIButton!
	@IBOutlet weak var newJokeBtn: UIButton!
	@IBOutlet weak var otherAppsBtn: UIButton!
	
	private var dataTask: URLSessionDataTask?
	
	private var joke: Joke? {
		didSet {
			guard let joke = joke else { return }
			jokeView.text = "\(joke.setup)"
			jokeView.sizeToFit()
			answerView.text = "\(joke.punchline)"
			answerView.sizeToFit()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		jokeView.text = "Want to Hear A Joke?"
		answerView.isHidden = true
		showAnswerBtn.isHidden = true
		newJokeBtn.setTitle("New Joke", for: .normal)
		otherAppsBtn.setTitle("Check Out Our Other Apps", for: .normal)
	}

	@objc private func loadData() {
		guard let url = URL(string: "https://official-joke-api.appspot.com/jokes/random") else {
			return
		}
		dataTask?.cancel()
		dataTask = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
			guard let data = data else { return }
			if let decodedData = try? JSONDecoder().decode(Joke.self, from: data) {
				DispatchQueue.main.async {
					self.joke = decodedData
				}
			}
		})
		dataTask?.resume()
	}
	
	@IBAction func didTapShowAnswerBtn(_ sender: Any) {
		answerView.isHidden = false
		showAnswerBtn.isHidden = true
	}
	
	@IBAction func didTapNewJokeBtn(_ sender: Any) {
		answerView.isHidden = true
		loadData()
		showAnswerBtn.isHidden = false
		showAnswerBtn.setTitle("Show Answer", for: .normal)
	}
	
	@IBAction func didTapOtherAppsBtn(_ sender: Any) {
		UIApplication.shared.open(URL(string: "https://apps.apple.com/us/developer/sinnig-media-llc/id1541775279")!)
	}
}

struct Joke: Decodable {
	let id: Int
	let type: String
	let setup: String
	let punchline: String
}
