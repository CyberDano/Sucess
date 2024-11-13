import UIKit

class ScoreViewController: UIViewController {

    var nick: String = ""
    var points: Int = 0
    @IBOutlet weak var NickInput: UITextField!
    @IBOutlet weak var LastScore: UITextView!
    @IBOutlet weak var RankingTable: UITableView!
    @IBOutlet weak var Information: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let score = UserDefaults.standard
        let points = score.integer(forKey: "score")
        LastScore.text = "Your best: \(points)"
        GetRanking()
    }

    /// Guarda el nick del usuario
    @IBAction func ChangedNick(_ sender: UITextField) {if NickInput.text!.count <= 20  || NickInput.text != nil {nick = NickInput.text!}}
    
    /// Subir tu puntaje en API
    @IBAction func UploadScore(_ sender: Any) {
        if nick.count > 0 {
            
        } else {Information.text = "You need a name to upload your score."}
    }
    
    /// Actualizar puntaje en API
    @IBAction func UpdateScore(_ sender: Any) {
    }
    
    /// Obtener ranking en API
    @IBAction func Ranking(_sender: UIButton) {GetRanking()}
    
    /// Obtener ranking en API
    func GetRanking() {
        let url = URL(string: "https://qhavrvkhlbmsljgmbknr.supabase.co/rest/v1/scores?select=*")
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFoYXZydmtobGJtc2xqZ21ia25yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDA3MjY5MTgsImV4cCI6MjAxNjMwMjkxOH0.Ta-lXGGwSiUGh0VC8tAFcFQqsqAvB8vv XJjubeQkx8"
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil {
                // Usar data
            } else {print(error!)}
        }.resume()
    }
}
