// Button.js
import React from 'react';

export default function TimeButton({ onClick, children }) {
  return (
    <button
      onClick={onClick}
      className="px-2 py-2 border border-primary hover:bg-primary-200 transition duration-300 rounded"
    >
      {children}
    </button>
  );
}

// Usage example:
/*
        <Button variant="secondary" onClick={() => console.log('Secondary button clicked')}>
            09:00 - 10:00
        </Button>
*/