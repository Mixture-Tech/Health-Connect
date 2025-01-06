import axiosClient from './axiosClient';

export const fetchProvinces = async () => {
    try {
        const response = await axiosClient.get('/ghn/provinces');
        return response;
    } catch (error) {
        console.error('Error fetching provinces:', error);
        throw new Error('Lỗi khi tải danh sách tỉnh thành.');
    }
}

export const fetchDistricts = async (provinceId) => {
    try {
        const response = await axiosClient.get(`/ghn/districts/${provinceId}`);
        return response;
    } catch (error) {
        console.error('Error fetching districts:', error);
        throw new Error('Lỗi khi tải danh sách quận huyện.');
    }
}

export const fetchWards = async (districtId) => {
    try {
        const response = await axiosClient.get(`/ghn/wards/${districtId}`);
        return response;
    } catch (error) {
        console.error('Error fetching wards:', error);
        throw new Error('Lỗi khi tải danh sách phường xã.');
    }
}