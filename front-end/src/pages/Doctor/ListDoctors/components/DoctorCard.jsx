import React from 'react';
import PropTypes from 'prop-types';

export default function DoctorCard({ name, imageUrl, specialty, onClick }) {
    return (
        <div
            className="flex flex-col items-center p-4 border rounded-lg shadow-sm hover:shadow-md transition-shadow cursor-pointer"
            onClick={onClick}
        >
            <img
                src={imageUrl}
                alt={name}
                className="w-32 h-32 object-cover rounded-full"
            />
            <span className="mt-2 text-lg font-medium text-center">{name}</span>
            <span className="mt-1 text-sm text-gray-500">{specialty}</span>
        </div>
    );
}

DoctorCard.propTypes = {
    name: PropTypes.string.isRequired,
    imageUrl: PropTypes.string.isRequired,
    specialty: PropTypes.string.isRequired,
    onClick: PropTypes.func.isRequired,
};