import UIKit

class MessageDecryptor: NSObject {
    
    func decryptMessage(_ message: String) -> String {
        guard message.count >= 1 && message.count <= 60,
              message.range(of: "^[a-zA-Z]+\\[][0-9]+$", options: .regularExpression) == nil
        else { return "" }

        var message = message
        while message.contains("[") || message.contains("]") {
            decrypt(&message)
        }
        return message
    }

    func decrypt(_ message: inout String) {
        guard let lastBracket = message.firstIndex(of: "]"),
              let firstBracket = message[...lastBracket].lastIndex(of: "["),
              firstBracket != message.startIndex
        else {
            message = message.replacingOccurrences(of: "[", with: "")
            message = message.replacingOccurrences(of: "]", with: "")
            return
        }

        var firstNumber: String.Index?
        var lastNumber: String.Index?
        if firstBracket > message.startIndex,
           lastBracket > message.startIndex {
            firstNumber = message.index(before: firstBracket)
            lastNumber = message.index(before: firstBracket)
        }

        if var first = firstNumber,
           let lastNumber = lastNumber,
           message[first].isNumber,
           message[lastNumber].isNumber {
            while message[first].isNumber && first > message.startIndex {
                first = message.index(before: first)
            }
            if first != firstNumber {
                firstNumber = message.index(after: first)
            }
        }

        let start = message.index(after: firstBracket)
        let end = message.index(before: lastBracket)
        let string = String(message[start...end])
        if  let firstNumber = firstNumber,
            let lastNumber = lastNumber,
            let occurences = Int(message[firstNumber...lastNumber]) {
            if occurences < 1 || occurences > 300 {
                message = ""
                return
            }
            message.replaceSubrange(firstNumber...lastBracket, with: String(repeating: string, count: occurences))
        } else {
            message.replaceSubrange(firstBracket...lastBracket, with: String(repeating: string, count: 1))
        }
    }
}
