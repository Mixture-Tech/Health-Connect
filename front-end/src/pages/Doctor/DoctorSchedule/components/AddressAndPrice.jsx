import React from "react";

export default function AddressAndPrice({ doctorInfo }) {
    return (
        <div className="mt-4 flex flex-col md:flex-row justify-between items-center gap-4">
            <div className="text-center md:text-left">
                <h2 className="font-semibold">ĐỊA CHỈ KHÁM</h2>
                <p>{doctorInfo.location}</p>
                <p className="text-gray-500">{doctorInfo.address}</p>
            </div>
            <div className="text-center md:text-right">
                <h2 className="font-semibold">GIÁ KHÁM</h2>
                <p>{doctorInfo.price}</p>
            </div>
        </div>
    );
}
