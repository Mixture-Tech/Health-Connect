// Header.js
import React from 'react';
import Navbar from './components/Navbar';
import Banner from './components/Banner';

export default function Header() {
    return (
        <>
            <Navbar />
            <div className="relative h-screen">
                <Banner />
            </div>
        </>
    );
}
