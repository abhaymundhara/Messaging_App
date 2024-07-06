import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct WhatsappDummyApp: App {
    // Register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @State private var isUnlocked = false
    
    var body: some Scene {
        WindowGroup {
            ContentView(isUnlocked: $isUnlocked)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    isUnlocked = false
                }
        }
    }
}

struct ContentView: View {
    @Binding var isUnlocked: Bool
    
    var body: some View {
        if isUnlocked {
            RootScreen()
        } else {
            FakeCalculatorView(isUnlocked: $isUnlocked)
        }
    }
}

struct FakeCalculatorView: View {
    @State private var display = "0"
    @State private var inputSequence = ""
    @Binding var isUnlocked: Bool
    
    let secretCode = "1234" // Secret code to unlock the main content
    
    @State private var currentOperation: String? = nil
    @State private var previousValue: Double? = nil
    @State private var shouldClearDisplay = false
    
    let buttons: [[CalculatorButton]] = [
        [.clear, .plusMinus, .percent, .operation("/")],
        [.digit("7"), .digit("8"), .digit("9"), .operation("*")],
        [.digit("4"), .digit("5"), .digit("6"), .operation("-")],
        [.digit("1"), .digit("2"), .digit("3"), .operation("+")],
        [.digit("0"), .decimal, .equals]
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            HStack {
                Spacer()
                Text(display)
                    .font(.system(size: 72))
                    .foregroundColor(.white)
                    .padding()
            }
            .background(Color.black)
            .cornerRadius(10)
            .padding(.horizontal)
            
            ForEach(buttons, id: \.self) { row in
                HStack(spacing: 12) {
                    ForEach(row, id: \.self) { button in
                        Button(action: {
                            self.handleInput(button)
                        }) {
                            Text(button.label)
                                .font(.system(size: 32))
                                .frame(width: self.buttonWidth(button: button), height: self.buttonHeight)
                                .background(button.backgroundColor)
                                .foregroundColor(button.foregroundColor)
                                .cornerRadius(self.buttonHeight / 2)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.bottom)
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
    
    private func handleInput(_ button: CalculatorButton) {
        switch button {
        case .digit(let value):
            if display == "0" || shouldClearDisplay {
                display = value
                shouldClearDisplay = false
            } else {
                display += value
            }
            inputSequence += value
        case .operation(let operation):
            currentOperation = operation
            previousValue = Double(display)
            shouldClearDisplay = true
        case .equals:
            if let operation = currentOperation, let previousValue = previousValue, let currentValue = Double(display) {
                var result: Double?
                switch operation {
                case "+":
                    result = previousValue + currentValue
                case "-":
                    result = previousValue - currentValue
                case "*":
                    result = previousValue * currentValue
                case "/":
                    result = previousValue / currentValue
                default:
                    break
                }
                if let result = result {
                    display = String(result)
                }
                self.previousValue = nil
                self.currentOperation = nil
                shouldClearDisplay = true
            }
        case .clear:
            display = "0"
            previousValue = nil
            currentOperation = nil
            inputSequence = ""
        case .plusMinus:
            if display != "0" {
                if display.hasPrefix("-") {
                    display.removeFirst()
                } else {
                    display = "-" + display
                }
            }
        case .percent:
            if let value = Double(display) {
                display = String(value / 100)
            }
        case .decimal:
            if !display.contains(".") {
                display += "."
            }
        }
        
        if inputSequence.hasSuffix(secretCode) {
            isUnlocked = true
        }
    }
    
    private var buttonHeight: CGFloat {
        return (UIScreen.main.bounds.width - 5 * 12) / 4
    }
    
    private func buttonWidth(button: CalculatorButton) -> CGFloat {
        if button == .digit("0") {
            return (UIScreen.main.bounds.width - 5 * 12) / 2
        }
        return (UIScreen.main.bounds.width - 5 * 12) / 4
    }
}

enum CalculatorButton: Hashable {
    case digit(String)
    case operation(String)
    case equals
    case clear
    case plusMinus
    case percent
    case decimal
    
    var label: String {
        switch self {
        case .digit(let value):
            return value
        case .operation(let operation):
            return operation
        case .equals:
            return "="
        case .clear:
            return "C"
        case .plusMinus:
            return "±"
        case .percent:
            return "%"
        case .decimal:
            return "."
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .digit:
            return Color(.darkGray)
        case .operation, .equals:
            return Color(.orange)
        case .clear, .plusMinus, .percent:
            return Color(.lightGray)
        case .decimal:
            return Color(.darkGray)
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .digit, .operation, .equals, .decimal:
            return .white
        case .clear, .plusMinus, .percent:
            return .black
        }
    }
}

struct MainContentView: View {
    var body: some View {
        MainAppScreen()
    }
}

struct MainAppScreen: View {
    var body: some View {
        Text("Main App Content")
            .font(.largeTitle)
            .padding()
    }
}




//import SwiftUI
//import Firebase
//
//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(_ application: UIApplication,
//                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        FirebaseApp.configure()
//        return true
//    }
//}
//
//@main
//struct WhatsappDummyApp: App {
//    // Register app delegate for Firebase setup
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//    
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}
//
//struct ContentView: View {
//    @State private var isUnlocked = false
//    
//    var body: some View {
//        if isUnlocked {
//            RootScreen()
//        } else {
//            FakeCalculatorView(isUnlocked: $isUnlocked)
//        }
//    }
//}
//
//struct FakeCalculatorView: View {
//    @State private var display = "0"
//    @State private var inputSequence = ""
//    @Binding var isUnlocked: Bool
//    
//    let secretCode = "1234" // Secret code to unlock the main content
//    
//    @State private var currentOperation: String? = nil
//    @State private var previousValue: Double? = nil
//    @State private var shouldClearDisplay = false
//    
//    let buttons: [[CalculatorButton]] = [
//        [.clear, .plusMinus, .percent, .operation("/")],
//        [.digit("7"), .digit("8"), .digit("9"), .operation("*")],
//        [.digit("4"), .digit("5"), .digit("6"), .operation("-")],
//        [.digit("1"), .digit("2"), .digit("3"), .operation("+")],
//        [.digit("0"), .decimal, .equals]
//    ]
//    
//    var body: some View {
//        VStack(spacing: 12) {
//            Spacer()
//            HStack {
//                Spacer()
//                Text(display)
//                    .font(.system(size: 72))
//                    .foregroundColor(.white)
//                    .padding()
//            }
//            .background(Color.black)
//            .cornerRadius(10)
//            .padding(.horizontal)
//            
//            ForEach(buttons, id: \.self) { row in
//                HStack(spacing: 12) {
//                    ForEach(row, id: \.self) { button in
//                        Button(action: {
//                            self.handleInput(button)
//                        }) {
//                            Text(button.label)
//                                .font(.system(size: 32))
//                                .frame(width: self.buttonWidth(button: button), height: self.buttonHeight)
//                                .background(button.backgroundColor)
//                                .foregroundColor(button.foregroundColor)
//                                .cornerRadius(self.buttonHeight / 2)
//                        }
//                    }
//                }
//            }
//            .padding(.horizontal)
//        }
//        .padding(.bottom)
//        .background(Color.black)
//        .edgesIgnoringSafeArea(.all)
//    }
//    
//    private func handleInput(_ button: CalculatorButton) {
//        switch button {
//        case .digit(let value):
//            if display == "0" || shouldClearDisplay {
//                display = value
//                shouldClearDisplay = false
//            } else {
//                display += value
//            }
//            inputSequence += value
//        case .operation(let operation):
//            currentOperation = operation
//            previousValue = Double(display)
//            shouldClearDisplay = true
//        case .equals:
//            if let operation = currentOperation, let previousValue = previousValue, let currentValue = Double(display) {
//                var result: Double?
//                switch operation {
//                case "+":
//                    result = previousValue + currentValue
//                case "-":
//                    result = previousValue - currentValue
//                case "*":
//                    result = previousValue * currentValue
//                case "/":
//                    result = previousValue / currentValue
//                default:
//                    break
//                }
//                if let result = result {
//                    display = String(result)
//                }
//                self.previousValue = nil
//                self.currentOperation = nil
//                shouldClearDisplay = true
//            }
//        case .clear:
//            display = "0"
//            previousValue = nil
//            currentOperation = nil
//            inputSequence = ""
//        case .plusMinus:
//            if display != "0" {
//                if display.hasPrefix("-") {
//                    display.removeFirst()
//                } else {
//                    display = "-" + display
//                }
//            }
//        case .percent:
//            if let value = Double(display) {
//                display = String(value / 100)
//            }
//        case .decimal:
//            if !display.contains(".") {
//                display += "."
//            }
//        }
//        
//        if inputSequence.hasSuffix(secretCode) {
//            isUnlocked = true
//        }
//    }
//    
//    private var buttonHeight: CGFloat {
//        return (UIScreen.main.bounds.width - 5 * 12) / 4
//    }
//    
//    private func buttonWidth(button: CalculatorButton) -> CGFloat {
//        if button == .digit("0") {
//            return (UIScreen.main.bounds.width - 5 * 12) / 2
//        }
//        return (UIScreen.main.bounds.width - 5 * 12) / 4
//    }
//}
//
//enum CalculatorButton: Hashable {
//    case digit(String)
//    case operation(String)
//    case equals
//    case clear
//    case plusMinus
//    case percent
//    case decimal
//    
//    var label: String {
//        switch self {
//        case .digit(let value):
//            return value
//        case .operation(let operation):
//            return operation
//        case .equals:
//            return "="
//        case .clear:
//            return "C"
//        case .plusMinus:
//            return "±"
//        case .percent:
//            return "%"
//        case .decimal:
//            return "."
//        }
//    }
//    
//    var backgroundColor: Color {
//        switch self {
//        case .digit:
//            return Color(.darkGray)
//        case .operation, .equals:
//            return Color(.orange)
//        case .clear, .plusMinus, .percent:
//            return Color(.lightGray)
//        case .decimal:
//            return Color(.darkGray)
//        }
//    }
//    
//    var foregroundColor: Color {
//        switch self {
//        case .digit, .operation, .equals, .decimal:
//            return .white
//        case .clear, .plusMinus, .percent:
//            return .black
//        }
//    }
//}
//
//struct MainContentView: View {
//    var body: some View {
//        MainAppScreen()
//    }
//}
//
//struct MainAppScreen: View {
//    var body: some View {
//        Text("Main App Content")
//            .font(.largeTitle)
//            .padding()
//    }
//}
