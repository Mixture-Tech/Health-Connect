import React from 'react';

export default function AppointmentSelectAddress({ icon: Icon, type = "text", placeholder, options = [] }) {
    return (
        <div className="w-[100%] relative">
            <Icon className="absolute top-3.5 left-3 text-[1.5rem] text-secondary-300" />
            {type === "select" ? (
                <select className="peer border-secondary-100 border rounded-md outline-none pl-12 pr-4 py-3 w-full focus:border-primary transition-colors duration-300">
                    <option>{placeholder}</option>
                    {options.map((option, index) => (
                        <option key={index} value={option}>
                            {option}
                        </option>
                    ))}
                </select>
            ) : (
                <input
                    type={type}
                    placeholder={placeholder}
                    className="peer border-secondary-100 border rounded-md outline-none pl-12 pr-4 py-3 w-full focus:border-primary transition-colors duration-300"
                />
            )}
        </div>
    );
}
