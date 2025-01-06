import React, {useState} from 'react';
import Doctor from './components/Doctor';
import InfoPage from './components/InfoPage';
import Specialization from './components/Specialization';

export default function Home() {

  return ( 
    <>
      <InfoPage />
      <Specialization />
      <Doctor />
    </>
  );
}
