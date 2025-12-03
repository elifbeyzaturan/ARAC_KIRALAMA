import React, { useState } from 'react';
import { X, User, Building2 } from 'lucide-react';
import { useAuth } from '../context/AuthContext';

const LoginModal = ({ isOpen, onClose }) => {
  const { loginUser, loginOffice, register } = useAuth();
  const [mode, setMode] = useState('login');
  const [userType, setUserType] = useState('user');
  const [formData, setFormData] = useState({
    email: '',
    password: '',
    name: '',
    surname: '',
    phone: '',
    license: ''
  });
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  if (!isOpen) return null;

  const validateForm = () => {
    if (mode === 'register') {
      if (!formData.name || !formData.surname || !formData.email || !formData.password) {
        setError('Tüm alanlar zorunludur');
        return false;
      }
      if (!formData.phone) {
        setError('Telefon numarası zorunludur');
        return false;
      }
      if (!formData.license) {
        setError('Ehliyet numarası zorunludur');
        return false;
      }
      if (formData.phone.length < 10) {
        setError('Geçerli bir telefon numarası girin');
        return false;
      }
    }
    return true;
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');

    if (!validateForm()) return;

    setLoading(true);

    try {
      if (mode === 'login') {
        if (userType === 'user') {
          await loginUser(formData.email, formData.password);
        } else {
          await loginOffice(formData.email, formData.password);
        }
        onClose();
        setFormData({ email: '', password: '', name: '', surname: '', phone: '', license: '' });
      } else {
        await register({
          Ad: formData.name,
          Soyad: formData.surname,
          Eposta: formData.email,
          Sifre: formData.password,
          Telefon: formData.phone,
          EhliyetNumarasi: formData.license
        });
        alert('Kayıt başarılı! Şimdi giriş yapabilirsiniz.');
        setMode('login');
        setFormData({ ...formData, name: '', surname: '', phone: '', license: '' });
      }
    } catch (err) {
      setError(err.message || 'Bir hata oluştu');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-xl shadow-2xl max-w-md w-full p-6 relative max-h-[90vh] overflow-y-auto">
        <button
          onClick={onClose}
          className="absolute top-4 right-4 text-gray-400 hover:text-gray-600 transition"
        >
          <X className="w-6 h-6" />
        </button>

        <h2 className="text-2xl font-bold mb-6 text-gray-800">
          {mode === 'login' ? 'Giriş Yap' : 'Kayıt Ol'}
        </h2>

        {mode === 'login' && (
          <div className="flex gap-2 mb-6">
            <button
              onClick={() => setUserType('user')}
              className={`flex-1 py-2 rounded-lg transition ${
                userType === 'user' 
                  ? 'bg-blue-600 text-white' 
                  : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
              }`}
            >
              <User className="w-4 h-4 inline mr-1" />
              Bireysel
            </button>
            <button
              onClick={() => setUserType('office')}
              className={`flex-1 py-2 rounded-lg transition ${
                userType === 'office' 
                  ? 'bg-blue-600 text-white' 
                  : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
              }`}
            >
              <Building2 className="w-4 h-4 inline mr-1" />
              Ofis
            </button>
          </div>
        )}

        {error && (
          <div className="bg-red-50 text-red-600 p-3 rounded-lg mb-4 text-sm">
            {error}
          </div>
        )}

        <div className="space-y-4">
          {mode === 'register' && (
            <>
              <input
                type="text"
                placeholder="Ad *"
                value={formData.name}
                onChange={(e) => setFormData({...formData, name: e.target.value})}
                className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none"
                required
              />
              <input
                type="text"
                placeholder="Soyad *"
                value={formData.surname}
                onChange={(e) => setFormData({...formData, surname: e.target.value})}
                className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none"
                required
              />
              <input
                type="tel"
                placeholder="Telefon (05xxxxxxxxx) *"
                value={formData.phone}
                onChange={(e) => setFormData({...formData, phone: e.target.value})}
                className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none"
                required
              />
              <input
                type="text"
                placeholder="Ehliyet Numarası *"
                value={formData.license}
                onChange={(e) => setFormData({...formData, license: e.target.value})}
                className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none"
                required
              />
            </>
          )}

          <input
            type="email"
            placeholder="E-posta *"
            value={formData.email}
            onChange={(e) => setFormData({...formData, email: e.target.value})}
            className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none"
            required
          />

          <input
            type="password"
            placeholder="Şifre *"
            value={formData.password}
            onChange={(e) => setFormData({...formData, password: e.target.value})}
            className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none"
            required
          />

          {mode === 'register' && (
            <p className="text-xs text-gray-500">
              * Tüm alanlar zorunludur
            </p>
          )}

          <button
            onClick={handleSubmit}
            disabled={loading}
            className="w-full bg-blue-600 text-white py-3 rounded-lg hover:bg-blue-700 transition disabled:bg-gray-400 font-medium"
          >
            {loading ? 'Yükleniyor...' : (mode === 'login' ? 'Giriş Yap' : 'Kayıt Ol')}
          </button>
        </div>

        <div className="mt-4 text-center">
          <button
            onClick={() => {
              setMode(mode === 'login' ? 'register' : 'login');
              setError('');
            }}
            className="text-blue-600 hover:text-blue-700 text-sm transition"
          >
            {mode === 'login'
              ? 'Hesabınız yok mu? Kayıt olun'
              : 'Zaten hesabınız var mı? Giriş yapın'}
          </button>
        </div>
      </div>
    </div>
  );
};

export default LoginModal;