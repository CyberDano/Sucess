import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var Info: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadScore()
    }
    private func LoadScore() {
        let score = UserDefaults.standard
        let points = score.integer(forKey: "points")
        Info.text = "Your best: \(points)"
    }
}

