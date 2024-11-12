import UIKit

class GameViewController: UIViewController {
    let Score = UserDefaults.standard
    var images: [UIImage] = [
        UIImage(named: "Stitch_normal")!,
        UIImage(named: "Stitch_dark")!,
        UIImage(named: "Stitch_light")!,
        UIImage(named: "Stitch_brown")!,
        UIImage(named: "Pink_normal")!,
        UIImage(named: "Pink_dark")!,
        UIImage(named: "Pink_light")!,
        UIImage(named: "Pink_brown")!,
        UIImage(named: "clock")!
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
        startGame()
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
        tempInt = Int.random(in: 0...7)
        print("valor random: \(tempInt)")
        recient.append(tempInt)
        if recient.count == 4 {
            recient.removeLast()
            timer?.invalidate()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.choosing()
            }
            return -1
        } else {
            return tempInt
        }
    }
    /// Elección de la secuencia del jugador
    private func choosing() {
        print(recient)
        TextInfo.text = "Your sequence: \(options)"
        for n in Options! {
            n.isSelected = false
            n.backgroundColor = .gray
        }
        TextInfo.text = "Choose the sequence:"
        ShowHUD(state: true)
        ImageSwitch.image = images[8]
        ImageSwitch.isHidden = true
    }
    /// Secuencia de imagenes
    private func GamePlay() {
        // Iniciar el timer
        timer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.Index = ChangeImage()
            if self.Index != -1 {
                TextInfo.text = "Remember the sequence!\(recient.count)"
                // Actualizar la imagen en el UIImageView
                self.ImageSwitch.image = self.images[self.Index]
            }
        }
    }
    /// Seleccionar el orden de la sucesión (jugador)
    @IBAction func ChoosedOption(_ sender: UIButton) {
        for n in Options! {
            n.isSelected = false
            n.backgroundColor = .gray
        }
        if sender.tag == 8 && options.count > 0{
            options.removeAll()
            TextInfo.text = "Your sequence: \(options)"
            for n in Options! {
                n.isSelected = false
                n.backgroundColor = .gray
            }
        }
        if !sender.isSelected {
            if options.count <= 3 {options.append(sender.tag)}
            sender.backgroundColor = .green
            TextInfo.text = "Your sequence: \(options)"
        }
    }
    /// Comprueba si las secuencias coinciden o no
    /// Permite segiuir jugando o guarda el récord
    @IBAction func CheckResult(_ sender: Any) {
        if recient == options {
            TextInfo.text = "Correct :)"
            points += 1
            startGame()
        } else {
            TextInfo.text = "Oh no. You lose :(\nScore: \(points)"
            let score = Score.integer(forKey: "points")
            if points > score {
                Score.set(points, forKey: "points")
            }
            ChooseButton.isHidden = true
        }
    }
    private func startGame() {
        ImageSwitch.isHidden = false
        ShowHUD(state: false)
        GamePlay()
        recient = []
        options = []
    }
}
