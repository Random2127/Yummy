// API
const String GEMINI_API_KEY = "AIzaSyDgvBtOSwIp7i3J_dWH-AhfwzWao6Q4U-o";

const String PROMPT =
    'Return only JSON with this structure: '
    '{"title": "...", "description": "...", "time": 30, "servings": 2, '
    '"cuisine": "...", "ingredients": ["..."], "instructions": ["..."]}. '
    'User request:'; // ${message.text};
