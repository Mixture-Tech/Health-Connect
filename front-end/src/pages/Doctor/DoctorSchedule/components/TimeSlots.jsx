import React from "react";
import TimeButton from "../../../../components/Form/Appointment/TimeButton";

export default function TimeSlots({ schedule, selectedDate }) {
    return (
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mt-4">
            {schedule.map((slot, index) => (
                <TimeButton
                    key={index}
                    onClick={() => {
                        if (slot.status === "available") {
                            console.log(
                                `Đặt lịch vào ${new Date(selectedDate).toLocaleDateString()} lúc ${slot.time}`
                            );
                        }
                    }}
                >
          <span
              className={`${
                  slot.status === "available"
                      ? "text-black"
                      : "text-gray-500 cursor-not-allowed"
              }`}
          >
            {slot.time}
          </span>
                </TimeButton>
            ))}
        </div>
    );
}
