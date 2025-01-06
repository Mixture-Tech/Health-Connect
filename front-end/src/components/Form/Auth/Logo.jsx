import React from "react";
const logo = require("../../../assets/images/logo.png");

export default function Logo() {
    return (
        <div className="flex justify-center mb-6">
            <img src={logo} alt="Health-Connect-Logo" className="h-28" />
        </div>
    );
}
