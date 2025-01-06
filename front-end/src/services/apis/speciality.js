import axiosClient from './axiosClient';

export const fetchSpecialties = async () => {
    try {
        const response = await axiosClient.get('/specializations');
        if (Array.isArray(response.data)) {
            return { data: response.data, error: null };
        } else {
            return { data: null, error: 'Dữ liệu không hợp lệ' };
        }
    } catch (err) {
        return { data: null, error: 'Lỗi khi tải dữ liệu chuyên khoa' };
    }
};


export const fetchDoctorsBySpecialization = async (specializationId) => {
    try {
        const response = await axiosClient.get(`/specializations/${specializationId}`);
        return response.data;
    } catch (error) {
        console.error('Error fetching doctors:', error);
        throw new Error('Có lỗi xảy ra khi tải dữ liệu bác sĩ');
    }
};


export const fetchDiseasesBySpecialization = async (specializationId) => {
    try {
        const response = await axiosClient.get(`/diseases/${specializationId}`);
        return response.data;
    } catch (error) {
        console.error('Error fetching diseases:', error);
        throw new Error('Không có bệnh cho chuyên khoa này');
    }
};