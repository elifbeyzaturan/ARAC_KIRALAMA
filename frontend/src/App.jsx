import React, { useState } from 'react';
import { AuthProvider, useAuth } from './context/AuthContext';
import Navbar from './components/Navbar';
import LoginModal from './components/LoginModal';
import HomePage from './pages/HomePage';
import CarsPage from './pages/CarsPage';
import OfficesPage from './pages/OfficesPage';
import MyReservationsPage from './pages/MyReservationsPage';
import OfficeDashboardPage from './pages/OfficeDashboardPage';
import ReservationPage from './pages/ReservationPage';
import ProfilePage from './pages/ProfilePage';

const AppContent = () => {
  const { user, office } = useAuth();
  const [currentPage, setCurrentPage] = useState('home');
  const [loginModalOpen, setLoginModalOpen] = useState(false);
  const [selectedCar, setSelectedCar] = useState(null);

  const handleReserve = (car) => {
    setSelectedCar(car);
    setCurrentPage('reservation');
  };

  const handleReservationSuccess = () => {
    setSelectedCar(null);
    setCurrentPage('reservations');
  };

  const handleReservationBack = () => {
    setSelectedCar(null);
    setCurrentPage('cars');
  };

  const renderPage = () => {
    if (currentPage === 'reservation' && selectedCar) {
      return (
        <ReservationPage
          car={selectedCar}
          onBack={handleReservationBack}
          onSuccess={handleReservationSuccess}
        />
      );
    }

    if (office && currentPage === 'office-dashboard') {
      return <OfficeDashboardPage />;
    }

    if (user && currentPage === 'profile') {
      return <ProfilePage />;
    }

    switch (currentPage) {
      case 'home':
        return (
          <HomePage
            onLoginClick={() => setLoginModalOpen(true)}
            onReserve={handleReserve}
          />
        );
      case 'cars':
        return (
          <CarsPage
            onLoginClick={() => setLoginModalOpen(true)}
            onReserve={handleReserve}
          />
        );
      case 'offices':
        return <OfficesPage />;
      default:
        return (
          <HomePage
            onLoginClick={() => setLoginModalOpen(true)}
            onReserve={handleReserve}
          />
        );
    }
  };

  return (
    <div className="min-h-screen bg-gray-50">
      <Navbar
        onLoginClick={() => setLoginModalOpen(true)}
        currentPage={currentPage}
        setCurrentPage={setCurrentPage}
      />

      <LoginModal
        isOpen={loginModalOpen}
        onClose={() => setLoginModalOpen(false)}
      />

      {renderPage()}

      <footer className="bg-gray-800 text-white py-8 mt-12">
          <div className="max-w-7xl mx-auto px-4 text-center">
            <p className="text-gray-400">
              © 2025 Rent&Drive. Tüm hakları saklıdır.
            </p>
          </div>
      </footer>
    </div>
  );
};

function App() {
  return (
    <AuthProvider>
      <AppContent />
    </AuthProvider>
  );
}

export default App;