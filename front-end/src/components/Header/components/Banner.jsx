import React from 'react';
import Button from '@mui/material/Button'
import BackgroundImage from '../../../assets/images/background.png';

export default function Header() {
    return (
            <div>
                <img src={BackgroundImage} alt="Background" className="absolute top-0 left-0 w-full h-full object-cover" />
                <div className="absolute top-0 left-0 w-full h-full bg-gray-800 opacity-50"></div>
                <div className="absolute inset-0 flex flex-col justify-center items-center text-white text-center">
                    <h1 className="text-5xl font-bold mb-4">Avoid Hassles & Delays.</h1>
                    <p className="mb-4">Don't worry. Find your doctor online. Book as you wish with eDoc.</p>
                    <p className="mb-6">We offer you a free doctor channeling service. Make your appointment now.</p>
                    <Button className="!bg-blue-500 !text-white !px-6 !py-3 rounded">Make Appointment</Button>
                </div>
            </div>
    );
}
