# StackFollow
A UIKit-based iOS application that displays a list of StackOverflow users, allows following/unfollowing users, and persists follow state between app sessions.

The application was built fully programmatically using UIKit and follows the MVVM architectural pattern.

---

## Features

- Fetch StackOverflow users from API
- Loading state handling
- Error and offline state handling
- Empty state handling
- Async/await networking
- Unit tested networking and business logic

---

## Requirements

- iOS 16+
- Xcode 14.2+

---

## How to Run

1. Open the `.xcodeproj`
2. Build and run the app
3. No additional dependencies required

---

## Architecture

The project follows the MVVM (Model-View-ViewModel) pattern.

### Layers

- **ViewController**
- Handles UI rendering and user interactions

- **ViewModel**
- Contains presentation logic and screen state

- **Services**
- Responsible for fetching and mapping data

- **Network Layer**
- Generic `NetworkClient` handles requests and decoding

---

## Technical Decisions

### UIKit + Programmatic UI

The UI was implemented programmatically using UIKit to keep the implementation explicit, scalable, and easier to review.

### MVVM

MVVM was chosen to separate presentation logic from UI code and improve testability and maintainability.

### Async/Await

Swift concurrency (`async/await`) was used for networking to simplify asynchronous flow handling and improve readability.

### Dependency Injection

Dependencies are injected through initializers to improve modularity and simplify unit testing.

### Protocol-Oriented Design

Protocols were introduced for services, networking, persistence, and monitoring layers to allow mocking during tests.

---

## Networking

The networking layer is built around a reusable generic `NetworkClient`.

Features:
- Generic request handling
- Decodable response parsing
- HTTP response validation
- Error propagation
- Testable through mocked session abstraction

---

## Offline Handling

The app monitors connectivity using `NWPathMonitor`.

If the device is offline, the user sees an inline empty state message instead of a blocking alert.

---

## Testing

The project includes unit tests for:
- NetworkClient
- Services
- ViewModel business logic

Mock objects were used to isolate dependencies and test:
- successful responses
- decoding failures
- invalid responses
- offline scenarios
