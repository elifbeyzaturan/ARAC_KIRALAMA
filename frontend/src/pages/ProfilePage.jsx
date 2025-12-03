import React, { useState, useEffect } from 'react';
import { User, CreditCard, FileText, MapPin, Calendar, Phone, Mail, Award, Clock, CheckCircle, XCircle } from 'lucide-react';
import { reservationService, userService } from '../services/api';

const ProfilePage = () => {
  const [activeTab, setActiveTab] = useState('info');
  const [reservations, setReservations] = useState([]);
  const [loading, setLoading] = useState(true);
  const [userInfo, setUserInfo] = useState({
    Ad: '',
    Soyad: '',
    Eposta: '',
    Telefon: '',
    EhliyetNumarasi: ''
  });

  useEffect(() => {
    loadUserInfo();
    loadReservations();
  }, []);

  const loadUserInfo = async () => {
    try {
      const data = await userService.getMe();
      setUserInfo(data);
    } catch (err) {
      console.error('Kullanıcı bilgileri yüklenemedi:', err);
    } finally {
      setLoading(false);
    }
  };

  const loadReservations = async () => {
    try {
      const data = await reservationService.getMy();
      setReservations(data.Rezervasyonlar || []);
    } catch (err) {
      console.error('Rezervasyonlar yüklenemedi:', err);
    }
  };

  const getReservationsByStatus = (status) => {
    if (status === 'all') return reservations;
    return reservations.filter(r => r.Durum === status);
  };

  const formatDate = (dateStr) => {
    return new Date(dateStr).toLocaleDateString('tr-TR', {
      year: 'numeric',
      month: 'long',
      day: 'numeric'
    });
  };

  const tabs = [
    { id: 'info', label: 'Bilgilerim', icon: User },
    { id: 'license', label: 'Ehliyet Bilgileri', icon: Award },
    { id: 'cards', label: 'Kayıtlı Kartlarım', icon: CreditCard },
    { id: 'reservations', label: 'Rezervasyonlarım', icon: FileText }
  ];

  if (loading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-gray-50 to-blue-50 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
          <p className="mt-4 text-gray-600">Profil yükleniyor...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 to-blue-50">
      {/* Header */}
      <div className="bg-gradient-to-r from-blue-600 to-blue-700 text-white py-12">
        <div className="max-w-7xl mx-auto px-4">
          <div className="flex items-center gap-4">
            <div className="w-20 h-20 bg-white rounded-full flex items-center justify-center">
              <User className="w-10 h-10 text-blue-600" />
            </div>
            <div>
              <h1 className="text-4xl font-bold">{userInfo.Ad} {userInfo.Soyad}</h1>
              <p className="text-blue-100 mt-1">{userInfo.Eposta}</p>
            </div>
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-4 py-8">
        {/* Tabs */}
        <div className="bg-white rounded-2xl shadow-lg p-2 mb-6">
          <div className="flex flex-wrap gap-2">
            {tabs.map(tab => (
              <button
                key={tab.id}
                onClick={() => setActiveTab(tab.id)}
                className={`flex items-center gap-2 px-6 py-3 rounded-xl transition font-medium ${
                  activeTab === tab.id
                    ? 'bg-gradient-to-r from-blue-600 to-blue-700 text-white shadow-md'
                    : 'text-gray-600 hover:bg-gray-100'
                }`}
              >
                <tab.icon className="w-5 h-5" />
                {tab.label}
              </button>
            ))}
          </div>
        </div>

        {/* Tab Content */}
        <div className="bg-white rounded-2xl shadow-lg p-8">
          {/* Bilgilerim Tab */}
          {activeTab === 'info' && (
            <div>
              <h2 className="text-2xl font-bold text-gray-800 mb-6 flex items-center">
                <User className="w-6 h-6 mr-2 text-blue-600" />
                Kişisel Bilgilerim
              </h2>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div className="space-y-2">
                  <label className="text-sm font-semibold text-gray-600">Ad</label>
                  <div className="flex items-center gap-3 p-4 bg-gray-50 rounded-xl">
                    <User className="w-5 h-5 text-gray-400" />
                    <span className="text-gray-800 font-medium">{userInfo.Ad}</span>
                  </div>
                </div>

                <div className="space-y-2">
                  <label className="text-sm font-semibold text-gray-600">Soyad</label>
                  <div className="flex items-center gap-3 p-4 bg-gray-50 rounded-xl">
                    <User className="w-5 h-5 text-gray-400" />
                    <span className="text-gray-800 font-medium">{userInfo.Soyad}</span>
                  </div>
                </div>

                <div className="space-y-2">
                  <label className="text-sm font-semibold text-gray-600">E-posta</label>
                  <div className="flex items-center gap-3 p-4 bg-gray-50 rounded-xl">
                    <Mail className="w-5 h-5 text-gray-400" />
                    <span className="text-gray-800 font-medium">{userInfo.Eposta}</span>
                  </div>
                </div>

                <div className="space-y-2">
                  <label className="text-sm font-semibold text-gray-600">Telefon</label>
                  <div className="flex items-center gap-3 p-4 bg-gray-50 rounded-xl">
                    <Phone className="w-5 h-5 text-gray-400" />
                    <span className="text-gray-800 font-medium">{userInfo.Telefon || 'Belirtilmemiş'}</span>
                  </div>
                </div>
              </div>

              <button className="mt-6 bg-blue-600 text-white px-6 py-3 rounded-xl hover:bg-blue-700 transition font-medium">
                Bilgilerimi Güncelle
              </button>
            </div>
          )}

          {/* Ehliyet Bilgileri Tab */}
          {activeTab === 'license' && (
            <div>
              <h2 className="text-2xl font-bold text-gray-800 mb-6 flex items-center">
                <Award className="w-6 h-6 mr-2 text-blue-600" />
                Ehliyet Bilgileri
              </h2>

              {userInfo.EhliyetNumarasi ? (
                <div className="bg-gradient-to-br from-blue-50 to-blue-100 p-8 rounded-2xl border-2 border-blue-200">
                  <div className="flex items-center justify-between mb-4">
                    <div>
                      <p className="text-sm text-gray-600 mb-1">Ehliyet Numarası</p>
                      <p className="text-3xl font-bold text-gray-800 tracking-wider">{userInfo.EhliyetNumarasi}</p>
                    </div>
                    <CheckCircle className="w-16 h-16 text-green-500" />
                  </div>
                  <div className="text-sm text-gray-600 mt-4">
                    ✓ Ehliyet bilginiz kayıtlı
                  </div>
                </div>
              ) : (
                <div className="bg-yellow-50 border-2 border-yellow-200 p-8 rounded-2xl">
                  <div className="flex items-center gap-4 mb-4">
                    <XCircle className="w-12 h-12 text-yellow-600" />
                    <div>
                      <h3 className="text-xl font-bold text-gray-800">Ehliyet Bilgisi Eksik</h3>
                      <p className="text-gray-600 mt-1">Rezervasyon yapabilmek için ehliyet bilginizi eklemeniz gerekmektedir.</p>
                    </div>
                  </div>
                  <input
                    type="text"
                    placeholder="Ehliyet Numaranızı Girin"
                    className="w-full px-4 py-3 border-2 border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none mt-4"
                  />
                  <button className="mt-4 bg-blue-600 text-white px-6 py-3 rounded-xl hover:bg-blue-700 transition font-medium">
                    Ehliyet Bilgisini Kaydet
                  </button>
                </div>
              )}
            </div>
          )}

          {/* Kayıtlı Kartlarım Tab */}
          {activeTab === 'cards' && (
            <div>
              <h2 className="text-2xl font-bold text-gray-800 mb-6 flex items-center">
                <CreditCard className="w-6 h-6 mr-2 text-blue-600" />
                Kayıtlı Kartlarım
              </h2>

              <div className="text-center py-12">
                <CreditCard className="w-16 h-16 text-gray-300 mx-auto mb-4" />
                <p className="text-gray-600">Henüz kayıtlı kartınız bulunmamaktadır.</p>
                <button className="mt-6 bg-blue-600 text-white px-6 py-3 rounded-xl hover:bg-blue-700 transition font-medium">
                  + Yeni Kart Ekle
                </button>
              </div>
            </div>
          )}

          {/* Rezervasyonlarım Tab */}
          {activeTab === 'reservations' && (
            <div>
              <h2 className="text-2xl font-bold text-gray-800 mb-6 flex items-center">
                <FileText className="w-6 h-6 mr-2 text-blue-600" />
                Rezervasyonlarım
              </h2>

              {/* Status Filters */}
              <div className="flex flex-wrap gap-3 mb-6">
                <button className="px-4 py-2 bg-blue-100 text-blue-700 rounded-lg font-medium">
                  Tümü ({reservations.length})
                </button>
                <button className="px-4 py-2 bg-green-100 text-green-700 rounded-lg font-medium">
                  Onaylananlar ({getReservationsByStatus('Onaylandı').length})
                </button>
                <button className="px-4 py-2 bg-blue-100 text-blue-700 rounded-lg font-medium">
                  Tamamlananlar ({getReservationsByStatus('Tamamlandı').length})
                </button>
                <button className="px-4 py-2 bg-red-100 text-red-700 rounded-lg font-medium">
                  İptal Edilenler ({getReservationsByStatus('İptal Edildi').length})
                </button>
              </div>

              {/* Reservations List */}
              {reservations.length === 0 ? (
                <div className="text-center py-12 bg-gray-50 rounded-xl">
                  <Calendar className="w-16 h-16 text-gray-300 mx-auto mb-4" />
                  <p className="text-gray-600">Henüz rezervasyonunuz bulunmamaktadır.</p>
                </div>
              ) : (
                <div className="space-y-4">
                  {reservations.map(res => (
                    <div key={res.RezervasyonID} className="bg-gray-50 p-6 rounded-xl hover:shadow-md transition">
                      <div className="flex items-start justify-between">
                        <div className="flex-1">
                          <h3 className="text-lg font-bold text-gray-800">{res.Marka} {res.Model}</h3>
                          <div className="mt-3 space-y-1 text-sm text-gray-600">
                            <p>📅 {formatDate(res.AlisTarihi)} - {formatDate(res.TeslimTarihi)}</p>
                            <p>📍 {res.AlisOfisi} → {res.TeslimOfisi}</p>
                            <p>💰 {res.ToplamUcret} ₺</p>
                          </div>
                        </div>
                        <span className={`px-4 py-2 rounded-full text-sm font-semibold ${
                          res.Durum === 'Onaylandı' ? 'bg-green-100 text-green-700' :
                          res.Durum === 'Tamamlandı' ? 'bg-blue-100 text-blue-700' :
                          res.Durum === 'İptal Edildi' ? 'bg-red-100 text-red-700' :
                          'bg-yellow-100 text-yellow-700'
                        }`}>
                          {res.Durum}
                        </span>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default ProfilePage;