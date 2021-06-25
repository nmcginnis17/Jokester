//
//  ViewController.swift
//  Jokester
//
//  Created by Nicholas McGinnis on 6/24/21.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var jokeView: UILabel!
	@IBOutlet weak var newJokeBtn: UIButton!
	
	private var dataTask: URLSessionDataTask?
	
	private var joke: Joke? {
		didSet {
			guard let joke = joke else { return }
			jokeView.text = "\(joke.setup)\n\(joke.punchline)"
			jokeView.sizeToFit()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		jokeView.text = "Want to Hear A Joke?"
		newJokeBtn.setTitle("New Joke", for: .normal)
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
	
	@IBAction func didTapNewJokeBtn(_ sender: Any) {
		loadData()
	}
}

struct Joke: Decodable {
	let id: Int
	let type: String
	let setup: String
	let punchline: String
}
