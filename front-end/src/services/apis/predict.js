import axiosClient from './axiosClient';

export const predictDisease = async (symptomName) => {
    try{
        const url = '/chatbot/predict-disease';
        const response = await axiosClient.post(url, {
            symptomName: symptomName
        });
        return response;
    }
    catch(error){
        console.log("Failed to predict diesase: ", error);
        throw error;
    }
};