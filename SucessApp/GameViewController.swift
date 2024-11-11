import UIKit

class GameViewController: UIViewController {
    let Score = UserDefaults()
    var images: [UIImage] = [
        UIImage(named: "Stitch_normal")!,
        UIImage(named: "Stitch_dark")!,
        UIImage(named: "Stitch_light")!,
        UIImage(named: "Stitch_brown")!,
        UIImage(named: "Pink_normal")!,
        UIImage(named: "Pink_dark")!,
        UIImage(named: "Pink_light")!,
        UIImage(named: "Pink_brown")!
    ]
    // Botones de elección
    @IBOutlet weak var ClearList: UIButton!
    @IBOutlet var Options: [UIButton]?
    // Componentes del juego
    @IBOutlet weak var ImageSwitch: UIImageView!
    @IBOutlet weak var TextInfo: UITextView!
    @IBOutlet weak var ChooseButton: UIButton!
    var points: Int = 0 // Contador de puntos
    var Index: Int = -1 // Int para seleccionar un UIImage
    var timer: Timer? // Timer
    var started: Bool = false
    var recient: [Int] = [] // Registro para el orden
    var options: [Int] = [] // Orden especificado por el jugador
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startedGame()
        ShowHUD(state: false)
    }
    /// Muestra información en pantalla
    private func ShowHUD(state: Bool) {
        ChooseButton.isHidden = !state
        ClearList.isHidden = !state
        for n in Options! {
            n.isHidden = !state
        }
    }
    /// Actualiza el el registro de imagen
    private func ChangeImage() -> Int {
        var tempInt: Int = -1
        var has: Bool = true // recient contiene el Int
        while has {
            tempInt = Int.random(in: 0...7)
            has = recient.contains(tempInt)
            print("valor random: \(tempInt)")
        }
        if recient.count == 3 {
            timer?.invalidate()
            choosing()
        } else {
            recient.append(tempInt)
        }
        return tempInt
    }
    /// Elección de la secuencia del jugador
    private func choosing() {
        print(recient)
        TextInfo.text = "Choose the sequence:"
        ShowHUD(state: true)
        ImageSwitch.isHidden = true
    }
    /// Secuencia de imagenes
    private func GamePlay() {
        // Iniciar el timer
        timer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            TextInfo.text = "Remember the sequence!"
            self.Index = ChangeImage()
            // Actualizar la imagen en el UIImageView
            self.ImageSwitch.image = self.images[self.Index]
        }
    }
    /// Seleccionar el orden de la sucesión (jugador)
    @IBAction func ChoosedOption(_ sender: UIButton) {
        for n in Options! {
            n.isSelected = false
            n.backgroundColor = .gray
        }
        print("Entras en la selección")
        if sender.tag == 8 {
            do {
                options.removeAll()
                for n in Options! {
                    n.isSelected = false
                    n.backgroundColor = .gray
                }
            } catch {
              print("list is empty")
            }
        }
        if !sender.isSelected {
            print("Botón pulsado: \(sender.tag)")
            if options.count <= 3 {options.append(sender.tag)}
            sender.backgroundColor = .green
        }
        print(options)
    }
    /// Comprueba si las secuencias coinciden o no
    /// Permite segiuir jugando o guarda el récord
    @IBAction func CheckResult(_ sender: Any) {
        if recient == options {
            points += 1
            startedGame()
        } else {
            TextInfo.text = "Oh no. You lose :(\nScore: \(points)"
            let score = Score.integer(forKey: "points")
            if points > score {
                Score.setValue(points, forKey: "points")
            }
            ChooseButton.isHidden = true
        }
    }
    private func startedGame() {
        ImageSwitch.isHidden = false
        GamePlay()
        recient = []
        options = []
    }
}
