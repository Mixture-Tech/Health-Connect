import React, { useState, useEffect } from 'react';
import axios from '../../../services/apis/axiosClient';
import List from './components/List';
import CompanyInformation from './components/CompanyInformation';
import { AppointmentService } from '../../../services/apis/appointment';

export default function ListAppointments() {
  const [appointments, setAppointments] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    const fetchAppointments = async () => {
      try {
        setLoading(true);
        const response = await AppointmentService.listAppointments(); // API endpoint
        console.log('Appointments Response:', response);
        setAppointments(response); // Giả định dữ liệu ở response.data.data
      } catch (err) {
        console.error('Error fetching appointments:', err);
        setError('Không thể tải danh sách lịch hẹn.');
      } finally {
        setLoading(false);
      }
    };

    fetchAppointments();
  }, []);

  return (
    <>
      <div className="p-5">
        {loading ? (
          <p>Đang tải danh sách lịch hẹn...</p>
        ) : error ? (
          <p>{error}</p>
        ) : (
          <List appointments={appointments} />
        )}
      </div>
      <CompanyInformation />
    </>
  );
}
