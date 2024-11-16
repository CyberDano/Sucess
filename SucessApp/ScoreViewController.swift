import UIKit

class ScoreViewController: UIViewController, UITableViewDataSource {

    var scores: [Score] = [] // Almacena los datos descargados
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
        RankingTable.dataSource = self // Configura la fuente de datos
        RankingTable.reloadData() // Recarga datos cuando estén listos
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if scores.isEmpty {
            let label = UILabel()
            label.text = "No scores available."
            label.textAlignment = .center
            tableView.backgroundView = label
            tableView.separatorStyle = .none
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        }
        return scores.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath)
        let score = scores[indexPath.row]
        cell.textLabel?.text = "\(score.name): \(score.points) points"
        return cell
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
        guard let url = URL(string: "https://qhavrvkhlbmsljgmbknr.supabase.co/rest/v1/scores?select=*") else {
            print("URL inválida")
            return
        }

        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFoYXZydmtobGJtc2xqZ21ia25yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDA3MjY5MTgsImV4cCI6MjAxNjMwMjkxOH0.Ta-lXGGwSiUGh0VC8tAFcFQqsqAvB8vvXJjubeQkx8"
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            if let error = error {
                print("Error al obtener los datos: \(error)")
                return
            }
            
            guard let data = data else {
                print("Datos vacíos")
                return
            }
            
            do {
                let scores = try JSONDecoder().decode([Score].self, from: data)
                DispatchQueue.main.async {
                    self.scores = scores // Actualiza la lista de puntajes
                    self.RankingTable.reloadData() // Refresca la tabla
                }
            } catch {
                print("Error al decodificar los datos: \(error)")
            }
        }.resume()
    }

}
