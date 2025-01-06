import { useState, useEffect } from 'react';
import { fetchProvinces, fetchDistricts, fetchWards } from '../services/apis/ghn';

const useLocationData = () => {
  const [provinces, setProvinces] = useState([]);
  const [districts, setDistricts] = useState([]);
  const [wards, setWards] = useState([]);
  const [selectedProvince, setSelectedProvince] = useState({ name: "", id: null });
  const [selectedDistrict, setSelectedDistrict] = useState({ name: "", id: null });
  const [selectedWard, setSelectedWard] = useState({ name: "", id: null });
  const [isLoadingProvinces, setIsLoadingProvinces] = useState(false);
  const [isLoadingDistricts, setIsLoadingDistricts] = useState(false);
  const [isLoadingWards, setIsLoadingWards] = useState(false);

  // Parse address method
  const parseAddress = (address) => {
    const parts = address.split(', ').reverse(); // Reverse to match expected order
    if (parts.length !== 3) return null;

    const [province, district, ward] = parts;
    return { province, district, ward };
  };

  // Set location from address method
  const setLocationFromAddress = async (address) => {
    const parsedAddress = parseAddress(address);
    if (!parsedAddress) return;

    // First, ensure provinces are loaded
    if (provinces.length === 0) {
      setIsLoadingProvinces(true);
      try {
        const provinceResponse = await fetchProvinces();
        const provinceList = provinceResponse.data.map(province => ({
          name: province.ProvinceName,
          id: province.ProvinceID
        }));
        setProvinces(provinceList);
      } catch (error) {
        console.error("Error loading provinces:", error);
        return;
      } finally {
        setIsLoadingProvinces(false);
      }
    }

    // Find and set province
    const matchedProvince = provinces.find(p => 
      p.name.toLowerCase() === parsedAddress.province.toLowerCase()
    );

    if (matchedProvince) {
      setSelectedProvince(matchedProvince);

      // Load districts for this province
      setIsLoadingDistricts(true);
      try {
        const districtResponse = await fetchDistricts(matchedProvince.id);
        const districtList = districtResponse.data.map(district => ({
          name: district.DistrictName,
          id: district.DistrictID
        }));
        setDistricts(districtList);

        // Find and set district
        const matchedDistrict = districtList.find(d => 
          d.name.toLowerCase() === parsedAddress.district.toLowerCase()
        );

        if (matchedDistrict) {
          setSelectedDistrict(matchedDistrict);

          // Load wards for this district
          setIsLoadingWards(true);
          try {
            const wardResponse = await fetchWards(matchedDistrict.id);
            const wardList = wardResponse.data.map(ward => ({
              name: ward.WardName,
              id: ward.WardCode
            }));
            setWards(wardList);

            // Find and set ward
            const matchedWard = wardList.find(w => 
              w.name.toLowerCase() === parsedAddress.ward.toLowerCase()
            );

            if (matchedWard) {
              setSelectedWard(matchedWard);
            }
          } catch (error) {
            console.error("Error loading wards:", error);
          } finally {
            setIsLoadingWards(false);
          }
        }
      } catch (error) {
        console.error("Error loading districts:", error);
      } finally {
        setIsLoadingDistricts(false);
      }
    }
  };

  // Fetch provinces
  useEffect(() => {
    const loadProvinces = async () => {
      setIsLoadingProvinces(true);
      try {
        const response = await fetchProvinces();
        const provinceList = response.data.map(province => ({
          name: province.ProvinceName,
          id: province.ProvinceID
        }));
        setProvinces(provinceList);
      } catch (error) {
        console.error("Error loading provinces:", error);
      } finally {
        setIsLoadingProvinces(false);
      }
    };

    loadProvinces();
  }, []);

  // Fetch districts when province is selected
  useEffect(() => {
    const loadDistricts = async () => {
      if (!selectedProvince || !selectedProvince.id) return;

      setIsLoadingDistricts(true);
      try {
        const response = await fetchDistricts(selectedProvince.id);
        const districtList = response.data.map(district => ({
          name: district.DistrictName,
          id: district.DistrictID
        }));
        setDistricts(districtList);
        // Reset dependent fields
        setSelectedDistrict({ name: "", id: null });
        setSelectedWard({ name: "", id: null });
        setWards([]);
      } catch (error) {
        console.error("Error loading districts:", error);
      } finally {
        setIsLoadingDistricts(false);
      }
    };

    loadDistricts();
  }, [selectedProvince.id]);

  // Fetch wards when district is selected
  useEffect(() => {
    const loadWards = async () => {
      if (!selectedDistrict || !selectedDistrict.id) return;

      setIsLoadingWards(true);
      try {
        const response = await fetchWards(selectedDistrict.id);
        const wardList = response.data.map(ward => ({
          name: ward.WardName,
          id: ward.WardCode
        }));
        setWards(wardList);
        // Reset ward selection
        setSelectedWard({ name: "", id: null });
      } catch (error) {
        console.error("Error loading wards:", error);
      } finally {
        setIsLoadingWards(false);
      }
    };

    loadWards();
  }, [selectedDistrict.id]);

  return {
    provinces,
    districts,
    wards,
    selectedProvince,
    selectedDistrict,
    selectedWard,
    setSelectedProvince,
    setSelectedDistrict,
    setSelectedWard,
    isLoadingProvinces,
    isLoadingDistricts,
    isLoadingWards,
    parseAddress,
    setLocationFromAddress
  };
};

export default useLocationData;