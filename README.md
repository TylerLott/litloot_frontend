# LitLoot

LitLoot is an interactive reading companion app that helps users discover and engage with classic literature through AI-powered chat and quizzes.

## Features

### AI Chat
- Natural conversation with an AI assistant about books and literature
- Get personalized book recommendations based on your interests
- View detailed book information directly in the chat
- Click on recommended books to view full details and take quizzes

### Book Details
- View comprehensive information about books including:
  - Title and author
  - Book content and descriptions
  - Project Gutenberg metadata
- Access quizzes for each book

### Interactive Quizzes
- Test your knowledge of books through AI-generated quizzes
- Multiple choice questions about book content
- Immediate feedback on answers
- Track your progress and understanding

## Setup Instructions

### Prerequisites
- macOS 13.0 or later
- Xcode 15.0 or later
- Swift 5.9 or later

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/litloot_frontend.git
   ```

2. Open the project in Xcode:
   ```bash
   cd litloot_frontend
   open LitLoot.xcodeproj
   ```

3. Build and run the project:
   - Select your target device (iPhone simulator or physical device)
   - Click the "Play" button or press Cmd+R

### Backend Setup
The app requires the LitLoot backend server to be running. Follow these steps to set up the backend:

1. Clone the backend repository:
   ```bash
   git clone https://github.com/yourusername/litloot_backend.git
   ```

2. Navigate to the backend directory:
   ```bash
   cd litloot_backend
   ```

3. Install Python dependencies:
   ```bash
   pip install -r requirements.txt
   ```

4. Start the backend server:
   ```bash
   python app.py
   ```

5. Ensure the backend URL is correctly configured in the frontend app.

## Usage

1. Launch the app on your device
2. Navigate to the AI Chat section
3. Start a conversation about books or literature
4. Receive book recommendations and information
5. Click on recommended books to view details and take quizzes
6. Track your reading progress and quiz results

## Architecture

The app is built using:
- SwiftUI for the user interface
- Combine for reactive programming
- MVVM architecture pattern
- RESTful API communication with the backend

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.