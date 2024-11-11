import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var ScoreButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadScore()
    }
    private func LoadScore() {
        let score = UserDefaults()
        let points = score.integer(forKey: "points")
        ScoreButton.subtitleLabel?.text = "Your best: \(points)"
    }
}

