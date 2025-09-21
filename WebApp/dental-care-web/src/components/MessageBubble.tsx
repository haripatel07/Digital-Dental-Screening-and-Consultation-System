import React from 'react';

interface MessageBubbleProps {
  text: string;
  isUser: boolean;
}

const MessageBubble: React.FC<MessageBubbleProps> = ({ text, isUser }) => (
  <div
    className={`message-bubble ${isUser ? 'user' : 'bot'}`}
    style={{
      alignSelf: isUser ? 'flex-end' : 'flex-start',
      background: isUser ? '#b2dfdb' : '#eee',
      borderRadius: 12,
      margin: '5px 0',
      padding: 12,
      maxWidth: '70%',
    }}
  >
    {text}
  </div>
);

export default MessageBubble;
