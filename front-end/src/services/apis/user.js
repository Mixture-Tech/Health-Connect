import axiosClient from './axiosClient';

export const userDetail = async (userEmail) => {
    try {
        const response = await axiosClient.get(`/user/getUser/${userEmail}`);
        return response.data;
    } catch (error) {
        console.error('Error fetching users:', error);
        throw new Error('Có lỗi xảy ra khi tải dữ liệu người dùng');
    }
};