// Button.js
import React from 'react';

export default function Button({ onClick, children, className, type = 'button' }) {
  return (
    <button
      type={type}
      onClick={onClick}
      className={`rounded-full px-6 py-2 bg-primary hover:bg-primary-200 text-secondary hover:text-primary-1000 transition duration-300 rounded ${className}`}
    >
      {children}
    </button>
  );
}