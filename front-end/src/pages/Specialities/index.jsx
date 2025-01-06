
import React, { useEffect, useState } from 'react';
import { fetchSpecialties } from '../../services/apis/speciality';
import Speciality from './components/Speciality';

export default function Specialities() {
  const [specialties, setSpecialties] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const getSpecialties = async () => {
      setLoading(true);
      const { data, error } = await fetchSpecialties();
      if (data) {
        setSpecialties(data);
      } else {
        setError(error);
      }
      setLoading(false);
    };
    
    getSpecialties();
  }, []);

  if (loading) {
    return <div>Đang tải dữ liệu...</div>;
  }

  if (error) {
    return <div>{error}</div>;
  }

  return (
      <main>
          <Speciality item={specialties} />
      </main>
  );
}
