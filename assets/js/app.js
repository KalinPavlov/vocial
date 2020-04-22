// Import the default Phoenix HTML libraries
import "phoenix_html";

import css from "../css/app.css"

// Import the User Socket code to enable websockets
import socket from "./socket";

// Import the polls channel code to enable live polling
import LivePolls from "./poll";
LivePolls.connect(socket);

// // Import the Chat Socket code to enable chat
import LiveChat from "./chat";
LiveChat.loadChat(socket);
