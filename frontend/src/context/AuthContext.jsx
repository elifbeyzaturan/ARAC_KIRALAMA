import React, { createContext, useState, useEffect, useContext } from 'react';
import { authService } from '../services/api';

const AuthContext = createContext();

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within AuthProvider');
  }
  return context;
};

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [office, setOffice] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const token = localStorage.getItem('token');
    const officeToken = localStorage.getItem('ofisToken');
    const officeData = localStorage.getItem('ofisAdi');

    if (token) {
      setUser({ token });
    } else if (officeToken) {
      setOffice({ token: officeToken, name: officeData });
    }
    setLoading(false);
  }, []);

  const loginUser = async (email, password) => {
      const data = await authService.login(email, password);
      localStorage.setItem('token', data.token);

      // Kullanıcı bilgilerini de kaydet
      if (data.AdSoyad) {
        const [ad, soyad] = data.AdSoyad.split(' ');
        localStorage.setItem('userName', ad);
        localStorage.setItem('userSurname', soyad);
      }

      setUser({ token: data.token });
      return data;
  };

  const loginOffice = async (email, password) => {
    const data = await authService.loginOffice(email, password);
    localStorage.setItem('ofisToken', data.token);
    localStorage.setItem('ofisAdi', data.OfisAdi);
    setOffice({ token: data.token, name: data.OfisAdi });
    return data;
  };

  const register = async (userData) => {
    const data = await authService.register(userData);
    return data;
  };

  const logout = () => {
    localStorage.clear();
    setUser(null);
    setOffice(null);
  };

  const value = {
    user,
    office,
    loading,
    loginUser,
    loginOffice,
    register,
    logout,
    isAuthenticated: !!(user || office),
    isOffice: !!office,
    isUser: !!user
  };

  return (
    <AuthContext.Provider value={value}>
      {children}
    </AuthContext.Provider>
  );
};
