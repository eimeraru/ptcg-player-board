import PTCGBattlePokemon
import PTCGCard

struct PTCGPlayerBoard {
    var text = "Hello, World!"
    
    func sandbox() -> PTCGBattlePokemon {
        let bp = PTCGBattlePokemon.init(with: PTCGPokemonCard.init(
                                            id: "",
                                            name: "",
                                            type: .colorLess,
                                            maxHitPoint: 0,
                                            evolutionType: .basic,
                                            ability: nil))
        return bp
    }
}
