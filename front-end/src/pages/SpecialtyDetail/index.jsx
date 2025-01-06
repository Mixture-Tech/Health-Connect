import React, { useState, useEffect } from 'react';
import Header from './components/Header';
import DiseaseList from './components/DiseaseList';
import DoctorCard from './components/DoctorCard';
import { useParams } from 'react-router-dom';
import { fetchDoctorsBySpecialization } from '../../services/apis/speciality';
import { fetchSpecialties } from '../../services/apis/speciality';

export default function BoneJointPage() {
    const { id } = useParams();
    const [doctors, setDoctors] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [selectedDates, setSelectedDates] = useState({});
    const [availableDates, setAvailableDates] = useState([]);
    const [specialityName, setSpecialityName] = useState('');

    useEffect(() => {
        const getDoctors = async () => {
            try {
                const data = await fetchDoctorsBySpecialization(id);
                if (data) {
                    const dates = data.flatMap((doctor) =>
                        doctor.schedules.map((schedule) => schedule.working_date)
                    );
                    const uniqueDates = [...new Set(dates)];
                    setAvailableDates(uniqueDates);
                    setDoctors(data);
                }

                const speciality = await fetchSpecialties();
                const selectedSpeciality = speciality.data.find(
                    (item) => item.specialization_id === id
                );
                setSpecialityName(selectedSpeciality?.specialization_name || '');
            } catch (err) {
                console.error(err);
                setError(err.message);
            } finally {
                setLoading(false);
            }
        };

        if (id) {
            getDoctors();
        }
    }, [id]);

    const handleDateChange = (doctorId, date) => {
        console.log("doctorId:", doctorId, "date:", date);
        if (doctorId && date) {
            setSelectedDates((prevDates) => ({
                ...prevDates,
                [doctorId]: date,
            }));
        } else {
            console.error("Thông tin bác sĩ hoặc ngày không hợp lệ");
        }
    };

    useEffect(() => {
        console.log('Selected Dates:', selectedDates);
    }, [selectedDates]);

    if (loading) return <div>Đang tải danh sách bác sĩ...</div>;
    if (error) return <div>{error}</div>;

    return (
        <div className="bone-joint-page container mx-auto px-4 py-8">
            <Header specialityName={specialityName}/>
            <DiseaseList specialityName={specialityName}/>
            <section>
                <h2 className="text-2xl font-semibold mb-6">Danh sách bác sĩ</h2>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                    {doctors.map((doctor) => (
                        <DoctorCard
                            key={doctor.doctor_id}
                            doctor={doctor}
                            availableDates={availableDates}
                            selectedDate={selectedDates[doctor.doctor_id] || ''}
                            setSelectedDate={(date) => {
                                if (doctor.doctor_id) {
                                    console.log(`Chọn ngày cho bác sĩ ${doctor.doctor_name}:`, date);
                                    handleDateChange(doctor.doctor_id, date);
                                } else {
                                    console.error("Không tìm thấy doctorId hợp lệ");
                                }
                            }}
                        />
                    ))}
                </div>
            </section>
        </div>
    );
}