import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import { fetchDiseasesBySpecialization } from '../../../services/apis/speciality';

export default function DiseaseList({ specialityName }) {
    const { id } = useParams();
    const [diseases, setDiseases] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
        const getDiseases = async () => {
            try {
                const data = await fetchDiseasesBySpecialization(id);
                console.log('Diseases Response:', data);
                if (data) {
                    setDiseases(data);
                }
            } catch (err) {
                console.error(err);
                setError(err.message);
            } finally {
                setLoading(false);
            }
        };

        if (id) {
            getDiseases();
        }
    }, [id]);

    if (loading) return <div>Đang tải danh sách bệnh...</div>;
    if (error) return <div>{error}</div>;

    return (
        <section className="mb-8">
            <h2 className="text-2xl font-semibold">Bệnh {specialityName}</h2>
            {diseases.length === 0 ? null : (
                <ul className="list-disc list-inside mt-4 space-y-2 text-gray-700">
                    {diseases.map((disease) => (
                        <li key={disease.disease_id}>{disease.disease_vie_name}</li>
                    ))}
                </ul>
            )}
        </section>
    );
}