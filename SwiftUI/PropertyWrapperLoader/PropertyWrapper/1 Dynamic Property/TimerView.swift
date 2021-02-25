import SwiftUI

class Box<Value>: ObservableObject {
    @Published var value: Value
    
    init(value: Value) {
        self.value = value
    }
}

@propertyWrapper struct Timer: DynamicProperty {

    @ObservedObject var box = Box(value: 0)
    private var timer: Foundation.Timer?
    
    init() {
        let box = box
        
        timer = Foundation.Timer(fire: Date(), interval: 1, repeats: true) { _ in
            box.value += 1
        }
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    var wrappedValue: Int { box.value }
}

struct TimerView: View {
        
    @Timer var counter: Int
    
    var body: some View {
        Text("Counter \(counter)")
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
