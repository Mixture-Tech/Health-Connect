import React, { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import Doctors from "./components/Doctors";
import { fetchDoctors } from "../../../services/apis/doctor";

export default function ListDoctors() {
  const [doctors, setDoctors] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const navigate = useNavigate();

  useEffect(() => {
    const getDoctors = async () => {
      try {
        const data = await fetchDoctors();
        setDoctors(data);
      } catch (err) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };

    getDoctors();
  }, []);

  const handleDoctorClick = (doctorId) => {
    navigate(`/chi-tiet-bac-si/${doctorId}`);
  };

  if (loading) {
    return <div>Đang tải dữ liệu...</div>;
  }

  if (error) {
    return <div>{error}</div>;
  }

  return (
    <main>
      <Doctors item={doctors} onDoctorClick={handleDoctorClick} />
    </main>
  );
}