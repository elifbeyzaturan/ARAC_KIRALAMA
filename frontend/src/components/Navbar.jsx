import React, { useState } from 'react';
import { Car, LogIn, LogOut, Menu, X } from 'lucide-react';
import { useAuth } from '../context/AuthContext';

const Navbar = ({ onLoginClick, currentPage, setCurrentPage }) => {
  const { user, office, logout } = useAuth();
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  const navItems = [
      { id: 'home', label: 'Ana Sayfa', showAlways: true },
      { id: 'cars', label: 'Araçlar', showAlways: true },
      { id: 'offices', label: 'Ofisler', showAlways: true },
      { id: 'profile', label: 'Profilim', showWhen: 'user' },  // ← DEĞİŞTİ
      { id: 'office-dashboard', label: 'Ofis Paneli', showWhen: 'office' }
  ];

  const shouldShowItem = (item) => {
    if (item.showAlways) return true;
    if (item.showWhen === 'user') return !!user;
    if (item.showWhen === 'office') return !!office;
    return false;
  };

  const handleNavClick = (pageId) => {
    setCurrentPage(pageId);
    setMobileMenuOpen(false);
  };

  return (
    <nav className="bg-gradient-to-r from-blue-600 to-blue-700 text-white shadow-lg sticky top-0 z-50">
      <div className="max-w-7xl mx-auto px-4">
        <div className="flex items-center justify-between h-16">
          <button
            onClick={() => handleNavClick('home')}
            className="flex items-center space-x-2 hover:opacity-80 transition"
          >
            <Car className="w-8 h-8" />
            <span className="text-xl font-bold">Rent&Drive</span>
          </button>

          <div className="hidden md:flex items-center space-x-6">
            {navItems.filter(shouldShowItem).map(item => (
              <button
                key={item.id}
                onClick={() => handleNavClick(item.id)}
                className={`hover:text-blue-200 transition ${
                  currentPage === item.id ? 'border-b-2 border-white' : ''
                }`}
              >
                {item.label}
              </button>
            ))}

            {(user || office) ? (
              <button
                onClick={logout}
                className="flex items-center space-x-1 bg-white bg-opacity-20 px-4 py-2 rounded-lg hover:bg-opacity-30 transition"
              >
                <LogOut className="w-4 h-4" />
                <span>Çıkış</span>
              </button>
            ) : (
              <button
                onClick={onLoginClick}
                className="flex items-center space-x-1 bg-white text-blue-600 px-4 py-2 rounded-lg hover:bg-blue-50 transition"
              >
                <LogIn className="w-4 h-4" />
                <span>Giriş Yap</span>
              </button>
            )}
          </div>

          <button
            onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
            className="md:hidden"
          >
            {mobileMenuOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
          </button>
        </div>

        {mobileMenuOpen && (
          <div className="md:hidden pb-4 space-y-2">
            {navItems.filter(shouldShowItem).map(item => (
              <button
                key={item.id}
                onClick={() => handleNavClick(item.id)}
                className="block w-full text-left py-2 hover:text-blue-200"
              >
                {item.label}
              </button>
            ))}

            {(user || office) ? (
              <button
                onClick={logout}
                className="block w-full text-left py-2 hover:text-blue-200"
              >
                Çıkış
              </button>
            ) : (
              <button
                onClick={onLoginClick}
                className="block w-full text-left py-2 hover:text-blue-200"
              >
                Giriş Yap
              </button>
            )}
          </div>
        )}
      </div>
    </nav>
  );
};

export default Navbar;