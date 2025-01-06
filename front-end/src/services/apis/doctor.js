import axiosClient from './axiosClient';

export const fetchDoctors = async () => {
    try {
        const response = await axiosClient.get('/doctors');
        if (response.data && Array.isArray(response.data)) {
            return response.data.map((doctor) => doctor);  // Không cần phải gán lại, trả về trực tiếp
        } else {
            throw new Error('Dữ liệu không hợp lệ.');
        }
    } catch (error) {
        console.error('Error fetching doctors:', error);
        throw new Error('Lỗi khi tải danh sách bác sĩ.');
    }
};
