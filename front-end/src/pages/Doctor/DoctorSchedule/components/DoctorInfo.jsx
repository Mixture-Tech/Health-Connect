import React from "react";

export default function DoctorInfo({ doctorInfo }) {
    return (
        <div className="flex flex-col md:flex-row items-center gap-4">
            <img
                src={doctorInfo.imageUrl}
                alt="Doctor"
                className="w-32 h-32 object-cover rounded-full"
            />
            <div className="text-left">
                <h1 className="text-xl font-bold">{doctorInfo.name}</h1>
                <ul className="list-disc pl-5 text-gray-700">
                    {doctorInfo.description.map((desc, index) => (
                        <li key={index}>{desc}</li>
                    ))}
                </ul>
            </div>
        </div>
    );
}
