import React from 'react';
import Navbar from './components/Navbar';
import Banner from './components/Banner';

export default function Header() {
    return (
        <header className="relative w-full h-screen bg-cover bg-center">
            <div className="relative z-10">
                <Navbar />
            </div>
            <div>
                <Banner />
            </div>
        </header>
    );
}
