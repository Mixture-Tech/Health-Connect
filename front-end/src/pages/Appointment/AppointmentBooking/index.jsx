import React, { useState } from 'react';
import Appointment from './components/Appointment';
import DoctorReferral from './components/Referral';

export default function AppointmentBooking() {
  return (
    <div>
      <DoctorReferral />
      <Appointment />
    </div>
  );
}
