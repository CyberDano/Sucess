import UIKit

class GameViewController: UIViewController {
    
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
    @IBOutlet var Options: [UIButton]?
    // Componentes del juego
    @IBOutlet weak var ImageSwitch: UIImageView!
    @IBOutlet weak var TextInfo: UITextView!
    @IBOutlet weak var PlayButton: UIButton!
    var points: Int = 0 // Contador de puntos
    var Index: Int = -1 // Int para seleccionar un UIImage
    var timer: Timer? // Timer
    var started: Bool = false
    var recient: [Int] = [] // Registro para el orden
    var options: [Int] = [] // Orden especificado por el jugador
    
    override func viewDidLoad() {
        super.viewDidLoad()
        started = startedGame()
        ShowHUD(state: false)
    }
    /// Muestra información en pantalla
    private func ShowHUD(state: Bool) {
        PlayButton.isHidden = !state
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
            print("valor random: \(tempInt)")
            has = recient.contains(tempInt)
        }
        recient.append(tempInt)
        if recient.count > 2 {
            timer?.invalidate()
            print(recient)
            TextInfo.text = "Choose the sequence:"
            ShowHUD(state: true)
            //ImageSwitch.isHidden = true
        }
        return tempInt
    }
    /// Secuencia de imagenes
    private func GamePlay(active: Bool) {
        // Iniciar el timer
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: active) { [weak self] _ in
            guard let self = self else { return }
            TextInfo.text = "Remember the sequence!"
            self.Index = ChangeImage()
            // Actualizar la imagen en el UIImageView
            self.ImageSwitch.image = self.images[self.Index]
        }
    }
    private func startedGame() -> Bool {
        GamePlay(active: true)
        recient = []
        return true
    }
}
