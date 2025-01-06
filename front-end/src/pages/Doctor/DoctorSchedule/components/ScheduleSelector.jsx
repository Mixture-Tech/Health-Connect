import React from "react";

export default function ScheduleSelector({ availableDates, selectedDate, onDateChange }) {
    return (
        <div className="mt-2 text-center md:text-left">
            <label htmlFor="date-select" className="block font-medium mb-2">
                Chọn ngày khám:
            </label>
            <select
                id="date-select"
                value={selectedDate}
                onChange={onDateChange}
                className="border border-gray-300 px-3 py-2 rounded w-auto"
            >
                {availableDates.map((date) => (
                    <option key={date} value={date}>
                        {new Date(date).toLocaleDateString("vi-VN")}
                    </option>
                ))}
            </select>
        </div>
    );
}
