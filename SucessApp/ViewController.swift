import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var ScoreButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        ScoreButton.configuration!.subtitle = "Your best: \(LoadScore())"
    }
    private func LoadScore() -> Int{
        let score = UserDefaults.standard
        let points = score.integer(forKey: "score")
        return points
    }
}

