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
        let score = UserDefaults.standard
        RankingTable.dataSource = self
        RankingTable.delegate = self
        LastScore.text = "Your best: \(score.integer(forKey: "score"))"
        GetRanking()
    }
    
    @IBAction func ChangedNick(_ sender: UITextField) {
        if let text = NickInput.text, !text.isEmpty && text.count <= 20 {
            nick = text
        }
    }
    
    /// Implementa un puntaje en API
    @IBAction func UploadScore(_ sender: Any) {
        guard !nick.isEmpty else {
            DispatchQueue.main.async {
                self.Information.text = "You need a name to upload your score."
            }
            return
        }
        let score = UserDefaults.standard
        points = score.integer(forKey: "score")

        let apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFoYXZydmtobGJtc2xqZ21ia25yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDA3MjY5MTgsImV4cCI6MjAxNjMwMjkxOH0.Ta-_lXGGwSiUGh0VC8tAFcFQqsqAvB8vvXJjubeQkx8"
        // Datos a enviar en el cuerpo de la solicitud
        let scoreData: [String: Any] = ["name": nick, "score": points]

        // Serializar los datos a formato JSON
        guard let jsonData = try? JSONSerialization.data(withJSONObject: scoreData) else {
            DispatchQueue.main.async {
                self.Information.text = "Error creating JSON body."
            }
            return
        }

        // Asegurarse de que la URL sea válida
        guard let url = URL(string: "https://qhavrvkhlbmsljgmbknr.supabase.co/rest/v1/scores") else {
            DispatchQueue.main.async {
                self.Information.text = "Invalid URL."
            }
            return
        }

        // Configurar la solicitud
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") // Token Bearer
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // Tipo de contenido
        request.setValue(apiKey, forHTTPHeaderField: "apiKey") // Clave API si es necesaria
        request.httpBody = jsonData // Cuerpo de la solicitud

        // Realizar la solicitud
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self.Information.text = "Error uploading score: \(error.localizedDescription)"
                }
                print("Error uploading score: \(error.localizedDescription)")
                return
            }

            // Verificar la respuesta HTTP
            if let httpResponse = response as? HTTPURLResponse {
                DispatchQueue.main.async {
                    switch httpResponse.statusCode {
                    case 201:
                        self.Information.text = "Score uploaded successfully!"
                        self.GetRanking()
                    case 401:
                        self.Information.text = "Unauthorized: Invalid token or API key."
                        print("Error 401: Unauthorized.")
                    default:
                        self.Information.text = "Unexpected response: \(httpResponse.statusCode)."
                        print("Unexpected response: \(httpResponse.statusCode)")
                    }
                }
            }
        }.resume()
    }


    /// Modifica un puntaje en API
    @IBAction func UpdateScore(_ sender: Any) {
        // Verificar que el campo de nombre no esté vacío
        if nick.isEmpty {
            Information.text = "You need a name to update your score."
            return
        }
        let score = UserDefaults.standard
        points = score.integer(forKey: "score")
        let apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFoYXZydmtobGJtc2xqZ21ia25yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDA3MjY5MTgsImV4cCI6MjAxNjMwMjkxOH0.Ta-_lXGGwSiUGh0VC8tAFcFQqsqAvB8vvXJjubeQkx8"
        // Crear el cuerpo JSON con el nuevo puntaje
        let scoreData: [String: Any] = ["score": points] // Solo se incluye el campo 'score'
        print(points)
        guard let jsonData = try? JSONSerialization.data(withJSONObject: scoreData) else {
            print("Error creating JSON body.")
            return
        }
        
        // Construir la URL con el nombre como parámetro de consulta
        let updateURL = "\(baseURL)?name=eq.\(nick)"
        guard let url = URL(string: updateURL) else {
            print("Invalid URL.")
            return
        }
        
        // Configurar la solicitud
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH" // Método HTTP PATCH
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") // Token Bearer
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // Tipo de contenido
        request.setValue(apiKey, forHTTPHeaderField: "apiKey") // Clave API si es necesaria
        request.httpBody = jsonData // Cuerpo de la solicitud
        
        // Enviar la solicitud
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error updating score: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.Information.text = "Error updating score."
                }
                return
            }
            
            // Verificar la respuesta HTTP
            if let httpResponse = response as? HTTPURLResponse {
                DispatchQueue.main.async {
                    switch httpResponse.statusCode {
                    case 204: // Respuesta exitosa: No Content
                        self.Information.text = "Score updated successfully!"
                        self.GetRanking()
                    case 401: // Token o clave API inválida
                        self.Information.text = "Unauthorized: Invalid token or API key."
                    case 404: // Usuario no encontrado
                        self.Information.text = "User not found."
                    default: // Otros errores
                        self.Information.text = "Unexpected response: \(httpResponse.statusCode)."
                    }
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
                    print("Respuesta recibida") // \(responseText)
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
