import UIKit

class ScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var scoreList: [Score] = []
    var nick: String = ""
    var points: Int = 0
    
    @IBOutlet weak var NickInput: UITextField!
    @IBOutlet weak var LastScore: UITextView!
    @IBOutlet weak var RankingTable: UITableView!
    @IBOutlet weak var Information: UITextView!
    
    let baseURL = "https://qhavrvkhlbmsljgmbknr.supabase.co/rest/v1/scores"
    let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFoYXZydmtobGJtc2xqZ21ia25yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDA3MjY5MTgsImV4cCI6MjAxNjMwMjkxOH0.Ta-_lXGGwSiUGh0VC8tAFcFQqsqAvB8vvXJjubeQkx8"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RankingTable.dataSource = self
        RankingTable.delegate = self
        LastScore.text = "Your best: \(UserDefaults.standard.integer(forKey: "score"))"
        GetRanking()
    }
    
    @IBAction func ChangedNick(_ sender: UITextField) {
        if let text = NickInput.text, !text.isEmpty && text.count <= 20 {
            nick = text
        }
    }
    
    @IBAction func UploadScore(_ sender: Any) {
        if nick.isEmpty {
            Information.text = "You need a name to upload your score."
            return
        }
        
        let scoreData: [String: Any] = ["name": nick, "score": points]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: scoreData) else {
            return
        }
        
        var request = URLRequest(url: URL(string: baseURL)!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error uploading score: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                DispatchQueue.main.async {
                    self.Information.text = "Score uploaded successfully!"
                    self.GetRanking()
                }
            }
        }.resume()
    }
    
    @IBAction func UpdateScore(_ sender: Any) {
        if nick.isEmpty {
            Information.text = "You need a name to update your score."
            return
        }
        
        let scoreData: [String: Any] = ["name": nick, "score": points]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: scoreData) else {
            return
        }
        
        let updateURL = "\(baseURL)?name=eq.\(nick)"
        var request = URLRequest(url: URL(string: updateURL)!)
        request.httpMethod = "PATCH"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error updating score: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                DispatchQueue.main.async {
                    self.Information.text = "Score updated successfully!"
                    self.GetRanking()
                }
            }
        }.resume()
    }
    @IBAction func RefreshRanking(_ sender: UIButton) {
        GetRanking()
    }
    
    func GetRanking() {
        // Definimos la URL del endpoint
            guard let url = URL(string: "https://qhavrvkhlbmsljgmbknr.supabase.co/rest/v1/scores") else {
                print("URL no válida")
                return
            }
            
            // Configuración de la solicitud
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            // Cabeceras requeridas
            let apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFoYXZydmtobGJtc2xqZ21ia25yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDA3MjY5MTgsImV4cCI6MjAxNjMwMjkxOH0.Ta-_lXGGwSiUGh0VC8tAFcFQqsqAvB8vvXJjubeQkx8"
            let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFoYXZydmtobGJtc2xqZ21ia25yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDA3MjY5MTgsImV4cCI6MjAxNjMwMjkxOH0.Ta-_lXGGwSiUGh0VC8tAFcFQqsqAvB8vvXJjubeQkx8"
            
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.setValue(apiKey, forHTTPHeaderField: "apiKey")
            
            // Ejecuta la solicitud
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                // Manejo de errores de red
                if let error = error {
                    print("Error en la solicitud: \(error.localizedDescription)")
                    return
                }
                
                // Verifica la respuesta HTTP
                if let httpResponse = response as? HTTPURLResponse {
                    print("Código de estado: \(httpResponse.statusCode)")
                    if httpResponse.statusCode != 200 {
                        print("Error en la solicitud, respuesta: \(httpResponse)")
                        return
                    }
                }
                
                // Asegúrate de que se recibió una respuesta válida con datos
                guard let data = data else {
                    print("No se recibieron datos")
                    return
                }
                
                // Depura la respuesta como texto
                if let responseText = String(data: data, encoding: .utf8) {
                    print("Respuesta recibida: \(responseText)")
                }
                
                // Decodifica los datos en el modelo esperado
                do {
                    let scores = try JSONDecoder().decode([Score].self, from: data)
                    DispatchQueue.main.async {
                        // Actualiza la interfaz con los datos obtenidos
                        self.scoreList = scores
                        self.RankingTable.reloadData()
                    }
                } catch {
                    print("Error al decodificar los datos: \(error.localizedDescription)")
                }
            }
            
            task.resume()
        }
    
    // MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoreList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RankingCell", for: indexPath)
        let score = scoreList[indexPath.row]
        cell.textLabel?.text = "\(score.name): \(score.score)"
        return cell
    }
}
