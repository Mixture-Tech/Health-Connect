import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { ChatInput } from './components/ChatInput';
import { PromptGrid } from "./components/PromptGrid";
import { ChatHistory } from './components/ChatHistory';
import { ChatMessages } from './components/ChatMessages';
import { predictDisease } from '../../services/apis/predict'; // Adjust import path

export default function Chatbot() {
    const [messages, setMessages] = useState([]); 
    const [chatHistory, setChatHistory] = useState([]);
    const [input, setInput] = useState("");
    const [activeChatId, setActiveChatId] = useState(null);
    const [showPrompts, setShowPrompts] = useState(true);
    const navigate = useNavigate();

    const handleSendMessage = async (messageText) => {
        if (!messageText.trim()) return;

        const newUserMessage = {
            id: messages.length + 1,
            text: messageText,
            sender: "user",
        };

        const updatedMessages = [...messages, newUserMessage];
        setMessages(updatedMessages);

        // Hide prompts after first message
        if (showPrompts) {
            setShowPrompts(false);
        }

        try {
            // Call API to predict disease
            const response = await predictDisease(messageText);
        
            const newBotMessage = {
                id: messages.length + 2,
                text: (
                    <div className="space-y-2">
                        <p>Dựa vào các triệu chứng mà bạn cung cấp, có thể bạn đang mắc bệnh: <strong>{response.data.disease_vie_name}</strong></p>
                        <p>
                            Nguyên nhân: {response.data.cause_of_disease}
                        </p>
                        {/* <p>
                            <strong>Các triệu chứng:</strong> {response.data.extractedSymptoms.join(', ')}
                        </p> */}
                        <div>
                            <strong>Chuyên khoa:</strong>{' '}
                            <span 
                                onClick={() => navigate(`/chi-tiet-chuyen-khoa/${response.data.specialization.specialization_id}`)}
                                className="text-primary-500 hover:underline cursor-pointer"
                            >
                                {response.data.specialization.specialization_name}
                            </span>
                        </div>
                    </div>
                ),
                sender: "bot",
            };
        
            const finalMessages = [...updatedMessages, newBotMessage];
            setMessages(finalMessages);
        
            // Save current chat to history
            if (!activeChatId) {
                const newChatId = Date.now();
                setChatHistory(prev => [
                    { 
                        id: newChatId, 
                        messages: finalMessages, 
                        timestamp: new Date().toLocaleString() 
                    },
                    ...prev
                ]);
                setActiveChatId(newChatId);
            } else {
                setChatHistory(prev => prev.map(chat => 
                    chat.id === activeChatId 
                        ? { ...chat, messages: finalMessages } 
                        : chat
                ));
            }
        } catch (error) {
            const errorMessage = {
                id: messages.length + 2,
                text: "Rất tiếc, hệ thống chưa thể phân tích đúng các triệu chứng của bạn. Bạn có thể thử lại bằng cách mô tả chi tiết hơn các triệu chứng hoặc liên hệ trực tiếp với bác sĩ để được tư vấn chính xác nhất.",
                sender: "bot",
            };
        
            const finalMessages = [...updatedMessages, errorMessage];
            setMessages(finalMessages);
        
            // Save the chat with error message to history
            if (!activeChatId) {
                const newChatId = Date.now();
                setChatHistory(prev => [
                    { 
                        id: newChatId, 
                        messages: finalMessages, 
                        timestamp: new Date().toLocaleString() 
                    },
                    ...prev
                ]);
                setActiveChatId(newChatId);
            } else {
                setChatHistory(prev => prev.map(chat => 
                    chat.id === activeChatId 
                        ? { ...chat, messages: finalMessages } 
                        : chat
                ));
            }
        }

        setInput("");
    };

    const handleSend = () => {
        handleSendMessage(input);
    };

    const handlePromptSelect = (prompt) => {
        handleSendMessage(prompt);
    };

    const loadChatHistory = (chatId) => {
        const selectedChat = chatHistory.find(chat => chat.id === chatId);
        if (selectedChat) {
            setMessages(selectedChat.messages);
            setActiveChatId(chatId);
            setShowPrompts(false);
        }
    };

    const handleNewChat = () => {
        const initialMessages = []; 
        setMessages(initialMessages);
        setActiveChatId(null);
        setInput("");
        setShowPrompts(true);
    };

    // Update PromptGrid to accept onPromptSelect prop
    const PromptGridWithSelect = () => (
        <PromptGrid onPromptSelect={handlePromptSelect} />
    );

    return (
        <div className="flex h-screen">
            <ChatHistory 
                chatHistory={chatHistory}
                activeChatId={activeChatId}
                onLoadChat={loadChatHistory}
                onNewChat={handleNewChat}
                onGoHome={() => navigate("/")}
            /> 
            <div className="flex flex-col w-3/4 bg-gray-100">
                <ChatMessages messages={messages} />
                {showPrompts && <PromptGridWithSelect />}
                <ChatInput 
                    input={input}
                    onInputChange={(e) => setInput(e.target.value)}
                    onSend={handleSend}
                />
            </div>
        </div>
    );
}