import React from "react";

export function PromptGrid({ onPromptSelect }) {
    const prompts = [
        "Tôi cảm thấy đau đầu, chóng mặt, mệt mỏi và nôn",
        "Tôi cảm thấy lo âu, nôn, cơ thể mệt mỏi và hay nói lắp",
        "Tôi cảm thấy ngứa, đau đầu và chóng mặt",
        "Tôi bị sốt cao và mệt mỏi kéo dài hơn 3 ngày",
    ];

    return (
        <div className="grid grid-cols-2 gap-4 p-4">
            {prompts.map((prompt, index) => (
                <div
                    key={index}
                    onClick={() => onPromptSelect(prompt)}
                    className="flex items-center justify-between p-4 border rounded-lg hover:shadow-lg cursor-pointer"
                >
                    <span className="font-medium text-gray-800">{prompt}</span>
                    <span className="text-primary-500 font-bold text-lg">+</span>
                </div>
            ))}
        </div>
    );
}