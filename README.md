# MatchMate App

MatchMate is a SwiftUI-based iOS application that allows users to browse and manage user profiles fetched from a remote API. The app leverages SwiftData for local storage, Combine for reactive programming, and Network framework for monitoring network connectivity. Users can accept or decline profiles, and the app works seamlessly both online and offline.

## Features

- **Fetch User Profiles**: Fetches user profiles from the [Random User API](https://randomuser.me/).
- **Profile Management**: Users can accept or decline profiles, which are then stored locally using SwiftData.
- **Offline Support**: The app works offline by displaying cached profiles and syncing changes when the network is restored.
- **Filter Profiles**: Users can filter profiles by status (All, Accepted, Declined).
- **Network Monitoring**: The app monitors network connectivity and adjusts its behavior accordingly.
- **Modern UI**: Built with SwiftUI, the app features a clean and responsive user interface.
- **Robust Networking**: Utilizes a custom `NetworkService` for handling API requests, retries, and caching.

## Technologies Used

- **SwiftUI**: For building the user interface.
- **SwiftData**: For local storage and data persistence.
- **Combine**: For reactive programming and handling asynchronous events.
- **Network Framework**: For monitoring network connectivity.
- **Async/Await**: For handling asynchronous API calls.
- **Custom Networking Layer**: A reusable `NetworkService` for handling API requests, retries, and caching.

## Installation

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/narayanshettigar/Shaadi-MatchMateApp.git
   ```

2. **Open the Project**:
   - Open the `MatchMakingApp.xcodeproj` file in Xcode.

3. **Run the App**:
   - Select a simulator or a physical device.
   - Click the "Run" button in Xcode to build and run the app.

## Usage

1. **Fetch Profiles**:
   - Upon launching the app, it will automatically fetch user profiles from the API.
   - If the device is offline, it will display cached profiles.

2. **Accept or Decline Profiles**:
   - Swipe through profiles and use the "Accept" or "Decline" buttons to manage profiles.
   - Accepted or declined profiles will be saved locally.

3. **Filter Profiles**:
   - Use the filter tabs at the top to view profiles by status (All, Accepted, Declined).

4. **Offline Mode**:
   - When offline, the app will display a banner indicating the offline status.
   - Any changes made offline will be synced with the server once the network is restored.

## Code Structure

- **App Entry Point**: `MatchMateApp` is the main entry point of the app.
- **Models**: Contains the data models for API responses and local storage.
- **Network Services**: Handles API requests and network monitoring.
  - **NetworkService**: A reusable networking layer for handling API requests, retries, and caching.
  - **APIService**: Handles specific API calls, such as fetching user profiles.
- **View Model**: Manages the app's state and business logic.
- **Views**: Contains all the SwiftUI views for the app's user interface.

## Networking Layer

The app includes a robust and reusable `NetworkService` that handles API requests, retries, and caching. Key features of the `NetworkService` include:

- **Retry Mechanism**: Automatically retries failed requests up to a specified number of times.
- **Caching**: Caches API responses to improve performance and reduce redundant network calls.
- **Error Handling**: Provides detailed error descriptions for various network-related issues.
- **Endpoint Configuration**: Allows flexible configuration of API endpoints, including headers, query parameters, and timeout intervals.

### Example Usage of `NetworkService`

```swift
let endpoint = Endpoint(
    path: "/api",
    method: .get,
    headers: ["Content-Type": "application/json"],
    body: nil,
    timeoutInterval: 60,
    queryParameters: ["results": "10"]
)

do {
    let userResponse: UserResponse = try await NetworkService.shared.request(endpoint)
    print(userResponse.results)
} catch {
    print("Error: \(error.localizedDescription)")
}
```

## Acknowledgments

- [Random User API](https://randomuser.me/) for providing the user data.
- Apple for providing SwiftUI, SwiftData, and Combine frameworks.

🚀
