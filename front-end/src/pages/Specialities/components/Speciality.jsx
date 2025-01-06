import React from 'react';
import SpecialtyCard from './SpecialityCard';
import PropTypes from 'prop-types';

export default function Speciality({ item }) {
    return (
        <div className="container mx-auto p-4">
            <h1 className="text-xl font-bold md:text-2xl">Chuyên khoa dành cho bạn</h1>
            <div className="h-1 bg-primary mb-8" style={{width:'336px'}}></div>
            <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
                {item.map((specialty) => (
                    <SpecialtyCard
                        key={specialty.specialization_id}
                        id={specialty.specialization_id}
                        name={specialty.specialization_name}
                        imageUrl={specialty.specialization_image}
                    />
                ))}
            </div>
        </div>
    );
}

Speciality.propTypes = {
    item: PropTypes.arrayOf(
        PropTypes.shape({
            id: PropTypes.number.isRequired,
            name: PropTypes.string.isRequired,
            imageUrl: PropTypes.string.isRequired
        })
    ).isRequired
};
