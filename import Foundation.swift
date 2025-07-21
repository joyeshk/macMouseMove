import Foundation
import AppKit // Required for NSScreen to get screen dimensions
import CoreGraphics // Required for CGEvent and mouse control

// --- Configuration ---
// Minimum delay in seconds before moving the mouse (inclusive)
let minDelaySeconds: UInt32 = 5
// Maximum delay in seconds before moving the mouse (inclusive)
let maxDelaySeconds: UInt32 = 30
// Duration of the mouse movement (in seconds). A smaller value makes it faster.
// Note: CoreGraphics mouse events are typically instantaneous.
// This value is more conceptual for a smooth animation if we were to implement
// a custom animation, but for direct CGEvent, it's about the "jump" speed.
let moveDurationSeconds: TimeInterval = 0.1 // A small duration for a quick move

// --- Main Logic ---
func moveMouseToCenter() {
    // Get the main screen's frame
    guard let screen = NSScreen.main else {
        print("Error: Could not get main screen information.")
        return
    }

    let screenFrame = screen.frame
    let screenWidth = screenFrame.size.width
    let screenHeight = screenFrame.size.height

    // Calculate the center coordinates
    let centerX = screenWidth / 2.0
    let centerY = screenHeight / 2.0

    //print(String(format: "Moving mouse to center: (%.0f, %.0f)", centerX, centerY))

    // Create a mouse move event
    // kCGEventMouseMoved indicates a mouse movement event
    // CGPoint(x: centerX, y: centerY) is the destination point
    // kCGMouseButtonLeft is often used, but for just moving, it doesn't matter much
    // CGEventSource(stateID: .combinedSessionState) gets the current event source
    guard let event = CGEvent(mouseEventSource: CGEventSource(stateID: .combinedSessionState),
                              mouseType: .mouseMoved,
                              mouseCursorPosition: CGPoint(x: centerX, y: centerY),
                              mouseButton: .left) else {
        print("Error: Could not create mouse event.")
        return
    }

    // Post the event to the event queue
    event.post(tap: .cghidEventTap)
    print("Done...")
}

func main() {
    print("Starting battery assesment. Press Ctrl+C to stop.")
    print("Note: You must grant accessibility permissions for this application.")
    // print(String(format: "Mouse will move to the center every %d to %d seconds.", minDelaySeconds, maxDelaySeconds))

    // Loop indefinitely until interrupted
    while true {
        // Generate a random delay within the specified range
        let delay = UInt32.random(in: minDelaySeconds...maxDelaySeconds)
        print("\nWaiting for \(delay) seconds...")

        // Sleep for the random delay.
        // Thread.sleep() is blocking and suitable for simple command-line tools.
        Thread.sleep(forTimeInterval: TimeInterval(delay))

        // Move the mouse after the delay
        moveMouseToCenter()
    }
}

// Call the main function to start the application
main()

