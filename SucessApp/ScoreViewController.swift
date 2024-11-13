import UIKit

class ScoreViewController: UIViewController {

    var nick: String = ""
    var points: Int = 0
    @IBOutlet weak var NickInput: UITextField!
    @IBOutlet weak var LastScore: UITextView!
    @IBOutlet weak var RankingTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let score = UserDefaults.standard
        let points = score.integer(forKey: "score")
        LastScore.text = "Your  best: \(points)"
        GetRanking()
    }

    /// Guarda el nick del usuario
    @IBAction func ChangedNick(_ sender: UITextField) {if NickInput.text!.count <= 20  || NickInput.text != nil {nick = NickInput.text!}}
    /// Subir tu puntaje en API
    @IBAction func UploadScore(_ sender: Any) {
    }
    /// Actualizar puntaje en API
    @IBAction func UpdateScore(_ sender: Any) {
    }
    /// Obtener ranking en API
    @IBAction func Ranking(_sender: UIButton) {GetRanking()}
    /// Obtener ranking en API
    func GetRanking() {
        let url = URL(string: "https://qhavrvkhlbmsljgmbknr.supabase.co/rest/v1/scores?select=*")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil {
                // Usar data
            } else {
                print(error!)
            }
        }.resume()
    }
}
