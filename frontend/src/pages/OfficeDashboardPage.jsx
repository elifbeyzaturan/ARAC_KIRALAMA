import React, { useState, useEffect } from 'react';
import { Car, Calendar, CheckCircle, XCircle, Clock, BarChart3, Plus, Edit, TrendingUp, Trash2, FileText, AlertCircle, Truck } from 'lucide-react';
import { useAuth } from '../context/AuthContext';

const OfficeDashboardPage = () => {
  const { office } = useAuth();
  const [stats, setStats] = useState(null);
  const [cars, setCars] = useState([]);
  const [reservations, setReservations] = useState([]);
  const [loading, setLoading] = useState(true);
  const [activeView, setActiveView] = useState('dashboard');
  const [reservationType, setReservationType] = useState('alis'); // alis or teslim

  // Modals
  const [showAddCarModal, setShowAddCarModal] = useState(false);
  const [showEditCarModal, setShowEditCarModal] = useState(false);
  const [selectedCar, setSelectedCar] = useState(null);

  // Form states
  const [carForm, setCarForm] = useState({
    Plaka: '',
    Marka: '',
    Model: '',
    Yil: '',
    YakitTipi: 'Benzin',
    VitesTuru: 'Manuel',
    GunlukKiraUcreti: ''
  });

  const token = localStorage.getItem('ofisToken');

  useEffect(() => {
    if (activeView === 'dashboard') loadDashboard();
    if (activeView === 'cars') loadCars();
    if (activeView === 'reservations') loadReservations();
  }, [activeView, reservationType]);

  const loadDashboard = async () => {
    try {
      const res = await fetch('http://127.0.0.1:5000/api/ofis/dashboard', {
        headers: { 'Authorization': `Bearer ${token}` }
      });
      const data = await res.json();
      setStats(data);
    } catch (err) {
      console.error('Dashboard yüklenemedi:', err);
    } finally {
      setLoading(false);
    }
  };

  const loadCars = async () => {
    try {
      const res = await fetch('http://127.0.0.1:5000/api/ofis/araclar', {
        headers: { 'Authorization': `Bearer ${token}` }
      });
      const data = await res.json();
      setCars(data.Araclar || []);
    } catch (err) {
      console.error('Araçlar yüklenemedi:', err);
    }
  };

  const loadReservations = async () => {
    try {
      const res = await fetch(`http://127.0.0.1:5000/api/ofis/rezervasyonlar/${reservationType}`, {
        headers: { 'Authorization': `Bearer ${token}` }
      });
      const data = await res.json();
      setReservations(data.Rezervasyonlar || []);
    } catch (err) {
      console.error('Rezervasyonlar yüklenemedi:', err);
    }
  };

  const handleAddCar = async (e) => {
    e.preventDefault();

    if (!carForm.Plaka || !carForm.Marka || !carForm.Model || !carForm.Yil || !carForm.GunlukKiraUcreti) {
      alert('Tüm alanları doldurun!');
      return;
    }

    try {
      const res = await fetch('http://127.0.0.1:5000/api/ofis/araclar/ekle', {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(carForm)
      });

      const data = await res.json();

      if (data.error) {
        alert(data.error);
        return;
      }

      alert('Araç başarıyla eklendi!');
      setShowAddCarModal(false);
      setCarForm({
        Plaka: '',
        Marka: '',
        Model: '',
        Yil: '',
        YakitTipi: 'Benzin',
        VitesTuru: 'Manuel',
        GunlukKiraUcreti: ''
      });
      loadCars();
    } catch (err) {
      alert('Araç eklenirken hata oluştu: ' + err.message);
    }
  };

  const handleEditCar = async (e) => {
    e.preventDefault();

    try {
      const res = await fetch(`http://127.0.0.1:5000/api/ofis/araclar/${selectedCar.AracID}`, {
        method: 'PUT',
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          GunlukKiraUcreti: carForm.GunlukKiraUcreti,
          YakitTipi: carForm.YakitTipi,
          VitesTuru: carForm.VitesTuru
        })
      });

      const data = await res.json();

      if (data.error) {
        alert(data.error);
        return;
      }

      alert('Araç güncellendi!');
      setShowEditCarModal(false);
      setSelectedCar(null);
      loadCars();
    } catch (err) {
      alert('Güncelleme hatası: ' + err.message);
    }
  };

  const handleCarStatusChange = async (carId, newStatus) => {
    if (!window.confirm(`Araç durumunu "${newStatus}" olarak değiştirmek istediğinize emin misiniz?`)) {
      return;
    }

    try {
      const res = await fetch(`http://127.0.0.1:5000/api/ofis/araclar/${carId}/durum`, {
        method: 'PUT',
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ Durum: newStatus })
      });

      const data = await res.json();

      if (data.error) {
        alert(data.error);
        return;
      }

      alert('Araç durumu güncellendi!');
      loadCars();
    } catch (err) {
      alert('Hata: ' + err.message);
    }
  };

  const handleReservationStatusChange = async (rezId, newStatus) => {
    const messages = {
      'Onaylandı': 'Bu rezervasyonu onaylamak istediğinize emin misiniz?',
      'İptal Edildi': 'Bu rezervasyonu iptal etmek istediğinize emin misiniz?',
      'Tamamlandı': 'Aracı müşteriden teslim aldınız mı? Rezervasyonu tamamlamak istediğinize emin misiniz?',
      'Devam Ediyor': 'Aracı müşteriye teslim ettiniz mi? Kiralama sürecini başlatmak istediğinize emin misiniz?'
    };

    if (!window.confirm(messages[newStatus])) return;

    try {
      const res = await fetch(`http://127.0.0.1:5000/api/ofis/rezervasyonlar/${rezId}/durum`, {
        method: 'PUT',
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ Durum: newStatus })
      });

      const data = await res.json();

      if (data.error) {
        alert(data.error);
        return;
      }

      alert('Rezervasyon durumu güncellendi!');
      loadReservations();
    } catch (err) {
      alert('Hata: ' + err.message);
    }
  };

  const openEditModal = (car) => {
    setSelectedCar(car);
    setCarForm({
      ...carForm,
      GunlukKiraUcreti: car.GunlukKiraUcreti,
      YakitTipi: car.YakitTipi,
      VitesTuru: car.VitesTuru
    });
    setShowEditCarModal(true);
  };

  const formatDate = (dateStr) => {
    return new Date(dateStr).toLocaleDateString('tr-TR', {
      year: 'numeric',
      month: 'long',
      day: 'numeric'
    });
  };

  const getStatusColor = (status) => {
    const colors = {
      'Müsait': 'bg-green-100 text-green-700',
      'Kirada': 'bg-blue-100 text-blue-700',
      'Bakımda': 'bg-yellow-100 text-yellow-700',
      'Beklemede': 'bg-yellow-100 text-yellow-700',
      'Onaylandı': 'bg-green-100 text-green-700',
      'Devam Ediyor': 'bg-purple-100 text-purple-700',
      'İptal Edildi': 'bg-red-100 text-red-700',
      'Tamamlandı': 'bg-blue-100 text-blue-700'
    };
    return colors[status] || 'bg-gray-100 text-gray-700';
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 to-blue-50">
      {/* Header */}
      <div className="bg-gradient-to-r from-blue-600 to-blue-700 text-white py-12">
        <div className="max-w-7xl mx-auto px-4">
          <h1 className="text-4xl font-bold mb-2">{office?.name} Ofis Paneli</h1>
          <p className="text-blue-100">Araç ve rezervasyon yönetimi</p>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-4 py-8">
        {/* Navigation Tabs */}
        <div className="bg-white rounded-2xl shadow-lg p-2 mb-6">
          <div className="flex flex-wrap gap-2">
            <button
              onClick={() => setActiveView('dashboard')}
              className={`flex items-center gap-2 px-6 py-3 rounded-xl transition font-medium ${
                activeView === 'dashboard'
                  ? 'bg-gradient-to-r from-blue-600 to-blue-700 text-white shadow-md'
                  : 'text-gray-600 hover:bg-gray-100'
              }`}
            >
              <BarChart3 className="w-5 h-5" />
              Dashboard
            </button>
            <button
              onClick={() => setActiveView('cars')}
              className={`flex items-center gap-2 px-6 py-3 rounded-xl transition font-medium ${
                activeView === 'cars'
                  ? 'bg-gradient-to-r from-blue-600 to-blue-700 text-white shadow-md'
                  : 'text-gray-600 hover:bg-gray-100'
              }`}
            >
              <Car className="w-5 h-5" />
              Araçlarımız
            </button>
            <button
              onClick={() => setActiveView('reservations')}
              className={`flex items-center gap-2 px-6 py-3 rounded-xl transition font-medium ${
                activeView === 'reservations'
                  ? 'bg-gradient-to-r from-blue-600 to-blue-700 text-white shadow-md'
                  : 'text-gray-600 hover:bg-gray-100'
              }`}
            >
              <Calendar className="w-5 h-5" />
              Rezervasyonlar
            </button>
          </div>
        </div>

        {/* DASHBOARD VIEW */}
        {activeView === 'dashboard' && stats && (
          <div>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
              <div className="bg-white rounded-2xl shadow-lg p-6 border-l-4 border-blue-500">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-gray-600 text-sm font-medium">Toplam Araç</p>
                    <p className="text-3xl font-bold text-gray-800 mt-2">{stats.toplamArac || 0}</p>
                  </div>
                  <Car className="w-12 h-12 text-blue-500 opacity-80" />
                </div>
              </div>

              <div className="bg-white rounded-2xl shadow-lg p-6 border-l-4 border-green-500">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-gray-600 text-sm font-medium">Müsait Araç</p>
                    <p className="text-3xl font-bold text-gray-800 mt-2">{stats.musaitArac || 0}</p>
                  </div>
                  <CheckCircle className="w-12 h-12 text-green-500 opacity-80" />
                </div>
              </div>

              <div className="bg-white rounded-2xl shadow-lg p-6 border-l-4 border-orange-500">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-gray-600 text-sm font-medium">Kiradaki Araç</p>
                    <p className="text-3xl font-bold text-gray-800 mt-2">{stats.kiradaArac || 0}</p>
                  </div>
                  <TrendingUp className="w-12 h-12 text-orange-500 opacity-80" />
                </div>
              </div>

              <div className="bg-white rounded-2xl shadow-lg p-6 border-l-4 border-purple-500">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-gray-600 text-sm font-medium">Bu Ay Gelir</p>
                    <p className="text-3xl font-bold text-gray-800 mt-2">{stats.buAyGelir || 0}₺</p>
                  </div>
                  <BarChart3 className="w-12 h-12 text-purple-500 opacity-80" />
                </div>
              </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              <div className="bg-yellow-50 border-2 border-yellow-200 rounded-2xl p-6">
                <div className="flex items-center gap-3">
                  <Clock className="w-8 h-8 text-yellow-600" />
                  <div>
                    <p className="text-sm text-gray-600">Bekleyen Rezervasyon</p>
                    <p className="text-2xl font-bold text-gray-800">{stats.bekleyenRezervasyon || 0}</p>
                  </div>
                </div>
              </div>

              <div className="bg-green-50 border-2 border-green-200 rounded-2xl p-6">
                <div className="flex items-center gap-3">
                  <CheckCircle className="w-8 h-8 text-green-600" />
                  <div>
                    <p className="text-sm text-gray-600">Onaylanan Rezervasyon</p>
                    <p className="text-2xl font-bold text-gray-800">{stats.onaylananRezervasyon || 0}</p>
                  </div>
                </div>
              </div>

              <div className="bg-gray-50 border-2 border-gray-200 rounded-2xl p-6">
                <div className="flex items-center gap-3">
                  <XCircle className="w-8 h-8 text-gray-600" />
                  <div>
                    <p className="text-sm text-gray-600">Bakımdaki Araç</p>
                    <p className="text-2xl font-bold text-gray-800">{stats.bakimdaArac || 0}</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        )}

        {/* CARS VIEW */}
        {activeView === 'cars' && (
          <div>
            <div className="flex justify-between items-center mb-6">
              <h2 className="text-2xl font-bold text-gray-800">Araç Yönetimi</h2>
              <button
                onClick={() => setShowAddCarModal(true)}
                className="flex items-center gap-2 bg-gradient-to-r from-blue-600 to-blue-700 text-white px-6 py-3 rounded-xl hover:shadow-lg transition"
              >
                <Plus className="w-5 h-5" />
                Yeni Araç Ekle
              </button>
            </div>

            {cars.length === 0 ? (
              <div className="text-center py-12 bg-white rounded-xl">
                <Car className="w-16 h-16 text-gray-300 mx-auto mb-4" />
                <p className="text-gray-600">Henüz araç eklenmemiş</p>
              </div>
            ) : (
              <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
                {cars.map(car => (
                  <div key={car.AracID} className="bg-white rounded-2xl shadow-md p-6">
                    <div className="flex justify-between items-start mb-4">
                      <div>
                        <h3 className="text-xl font-bold text-gray-800">{car.Marka} {car.Model}</h3>
                        <p className="text-gray-500 text-sm">{car.Plaka}</p>
                      </div>
                      <span className={`px-3 py-1 rounded-full text-sm font-semibold ${getStatusColor(car.Durum)}`}>
                        {car.Durum}
                      </span>
                    </div>

                    <div className="grid grid-cols-2 gap-4 mb-4 text-sm">
                      <div>
                        <p className="text-gray-600">Yıl</p>
                        <p className="font-semibold">{car.Yil}</p>
                      </div>
                      <div>
                        <p className="text-gray-600">Yakıt</p>
                        <p className="font-semibold">{car.YakitTipi}</p>
                      </div>
                      <div>
                        <p className="text-gray-600">Vites</p>
                        <p className="font-semibold">{car.VitesTuru}</p>
                      </div>
                      <div>
                        <p className="text-gray-600">Günlük Ücret</p>
                        <p className="font-semibold">{car.GunlukKiraUcreti}₺</p>
                      </div>
                    </div>

                    <div className="flex gap-2">
                      <button
                        onClick={() => openEditModal(car)}
                        className="flex-1 flex items-center justify-center gap-2 bg-blue-100 text-blue-700 py-2 rounded-lg hover:bg-blue-200 transition"
                      >
                        <Edit className="w-4 h-4" />
                        Düzenle
                      </button>

                      <select
                        value={car.Durum}
                        onChange={(e) => handleCarStatusChange(car.AracID, e.target.value)}
                        className="flex-1 px-3 py-2 border border-gray-300 rounded-lg text-sm"
                      >
                        <option value="Müsait">Müsait</option>
                        <option value="Kirada">Kirada</option>
                        <option value="Bakımda">Bakımda</option>
                      </select>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        )}

        {/* RESERVATIONS VIEW */}
        {activeView === 'reservations' && (
          <div>
            <div className="flex justify-between items-center mb-6">
              <h2 className="text-2xl font-bold text-gray-800">Rezervasyon Yönetimi</h2>
              <div className="flex gap-2">
                <button
                  onClick={() => setReservationType('alis')}
                  className={`px-6 py-3 rounded-xl transition font-medium ${
                    reservationType === 'alis'
                      ? 'bg-blue-600 text-white'
                      : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                  }`}
                >
                  Alış Rezervasyonları
                </button>
                <button
                  onClick={() => setReservationType('teslim')}
                  className={`px-6 py-3 rounded-xl transition font-medium ${
                    reservationType === 'teslim'
                      ? 'bg-blue-600 text-white'
                      : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                  }`}
                >
                  Teslim Rezervasyonları
                </button>
              </div>
            </div>

            {reservations.length === 0 ? (
              <div className="text-center py-12 bg-white rounded-xl">
                <Calendar className="w-16 h-16 text-gray-300 mx-auto mb-4" />
                <p className="text-gray-600">Rezervasyon bulunamadı</p>
              </div>
            ) : (
              <div className="space-y-4">
                {reservations.map(rez => (
                  <div key={rez.RezervasyonID} className="bg-white rounded-2xl shadow-md p-6">
                    <div className="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
                      <div className="flex-1">
                        <div className="flex items-center justify-between mb-3">
                          <h3 className="text-xl font-bold text-gray-800">{rez.Marka} {rez.Model}</h3>
                          <span className={`px-4 py-2 rounded-full text-sm font-semibold ${getStatusColor(rez.Durum)}`}>
                            {rez.Durum}
                          </span>
                        </div>

                        <div className="grid grid-cols-1 md:grid-cols-2 gap-3 text-sm">
                          <div>
                            <p className="text-gray-600">Müşteri</p>
                            <p className="font-semibold">{rez.Ad} {rez.Soyad}</p>
                          </div>
                          <div>
                            <p className="text-gray-600">Telefon</p>
                            <p className="font-semibold">{rez.Telefon || 'Belirtilmemiş'}</p>
                          </div>
                          <div>
                            <p className="text-gray-600">Plaka</p>
                            <p className="font-semibold">{rez.Plaka}</p>
                          </div>
                          <div>
                            <p className="text-gray-600">Tarih</p>
                            <p className="font-semibold">{formatDate(rez.AlisTarihi)}</p>
                          </div>
                          <div>
                            <p className="text-gray-600">{reservationType === 'alis' ? 'Teslim Ofisi' : 'Alış Ofisi'}</p>
                            <p className="font-semibold">{reservationType === 'alis' ? rez.TeslimOfisi : rez.AlisOfisi}</p>
                          </div>
                          <div>
                            <p className="text-gray-600">Toplam Ücret</p>
                            <p className="font-semibold text-green-600">{rez.ToplamUcret}₺</p>
                          </div>
                        </div>
                      </div>

                      {/* BUTONLAR - DÜZELTİLMİŞ MANTIK */}
                      <div className="flex flex-col gap-2 lg:w-48">

                        {/* BEKLEMEDE: Her iki ofis de onaylayabilir veya iptal edebilir */}
                        {rez.Durum === 'Beklemede' && (
                          <>
                            <button
                              onClick={() => handleReservationStatusChange(rez.RezervasyonID, 'Onaylandı')}
                              className="flex items-center justify-center gap-2 bg-green-600 text-white py-2 rounded-lg hover:bg-green-700 transition"
                            >
                              <CheckCircle className="w-4 h-4" />
                              Onayla
                            </button>
                            <button
                              onClick={() => handleReservationStatusChange(rez.RezervasyonID, 'İptal Edildi')}
                              className="flex items-center justify-center gap-2 bg-red-600 text-white py-2 rounded-lg hover:bg-red-700 transition"
                            >
                              <XCircle className="w-4 h-4" />
                              İptal Et
                            </button>
                          </>
                        )}

                        {/* ONAYLANDI DURUMU */}
                        {rez.Durum === 'Onaylandı' && (
                          <>
                            {/* ALIŞ OFİSİ: Aracı müşteriye teslim et + İptal */}
                            {reservationType === 'alis' && (
                              <>
                                <button
                                  onClick={() => handleReservationStatusChange(rez.RezervasyonID, 'Devam Ediyor')}
                                  className="flex items-center justify-center gap-2 bg-purple-600 text-white py-2 rounded-lg hover:bg-purple-700 transition"
                                >
                                  <Truck className="w-4 h-4" />
                                  Aracı Teslim Et
                                </button>
                                <button
                                  onClick={() => handleReservationStatusChange(rez.RezervasyonID, 'İptal Edildi')}
                                  className="flex items-center justify-center gap-2 bg-red-600 text-white py-2 rounded-lg hover:bg-red-700 transition"
                                >
                                  <XCircle className="w-4 h-4" />
                                  İptal Et
                                </button>
                              </>
                            )}

                            {/* TESLİM OFİSİ: Onaylandı durumunda sadece iptal edebilir */}
                            {reservationType === 'teslim' && (
                              <>
                                <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-3">
                                  <div className="flex items-start gap-2">
                                    <AlertCircle className="w-5 h-5 text-yellow-600 flex-shrink-0 mt-0.5" />
                                    <p className="text-sm text-yellow-800">
                                      Araç henüz müşteriye teslim edilmedi. Alış ofisinin aracı teslim etmesi bekleniyor.
                                    </p>
                                  </div>
                                </div>
                                <button
                                  onClick={() => handleReservationStatusChange(rez.RezervasyonID, 'İptal Edildi')}
                                  className="flex items-center justify-center gap-2 bg-red-600 text-white py-2 rounded-lg hover:bg-red-700 transition"
                                >
                                  <XCircle className="w-4 h-4" />
                                  İptal Et
                                </button>
                              </>
                            )}
                          </>
                        )}

                        {/* DEVAM EDİYOR DURUMU */}
                        {rez.Durum === 'Devam Ediyor' && (
                          <>
                            {/* TESLİM OFİSİ: Aracı müşteriden teslim al + İptal */}
                            {reservationType === 'teslim' && (
                              <>
                                <button
                                  onClick={() => handleReservationStatusChange(rez.RezervasyonID, 'Tamamlandı')}
                                  className="flex items-center justify-center gap-2 bg-blue-600 text-white py-2 rounded-lg hover:bg-blue-700 transition"
                                >
                                  <CheckCircle className="w-4 h-4" />
                                  Aracı Teslim Al
                                </button>
                                <button
                                  onClick={() => handleReservationStatusChange(rez.RezervasyonID, 'İptal Edildi')}
                                  className="flex items-center justify-center gap-2 bg-red-600 text-white py-2 rounded-lg hover:bg-red-700 transition"
                                >
                                  <XCircle className="w-4 h-4" />
                                  İptal Et
                                </button>
                              </>
                            )}

                            {/* ALIŞ OFİSİ: Devam ediyor durumunda işlem yapamaz */}
                            {reservationType === 'alis' && (
                              <div className="bg-purple-50 border border-purple-200 rounded-lg p-3">
                                <div className="flex items-start gap-2">
                                  <Truck className="w-5 h-5 text-purple-600 flex-shrink-0 mt-0.5" />
                                  <p className="text-sm text-purple-800">
                                    Araç müşteride. Teslim ofisinin aracı teslim alması bekleniyor.
                                  </p>
                                </div>
                              </div>
                            )}
                          </>
                        )}

                        {/* TAMAMLANDI veya İPTAL EDİLDİ */}
                        {(rez.Durum === 'İptal Edildi' || rez.Durum === 'Tamamlandı') && (
                          <span className="text-center text-sm text-gray-500 italic py-2">
                            İşlem yapılamaz
                          </span>
                        )}

                      </div>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        )}
      </div>

      {/* ADD CAR MODAL */}
      {showAddCarModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-2xl shadow-2xl max-w-2xl w-full p-8">
            <div className="flex items-center justify-between mb-6">
              <h2 className="text-2xl font-bold text-gray-800">Yeni Araç Ekle</h2>
              <button onClick={() => setShowAddCarModal(false)} className="text-gray-400 hover:text-gray-600">
                <XCircle className="w-6 h-6" />
              </button>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
              <input
                type="text"
                placeholder="Plaka *"
                value={carForm.Plaka}
                onChange={(e) => setCarForm({...carForm, Plaka: e.target.value})}
                className="px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none"
              />

              <input
                type="text"
                placeholder="Marka *"
                value={carForm.Marka}
                onChange={(e) => setCarForm({...carForm, Marka: e.target.value})}
                className="px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none"
              />

              <input
                type="text"
                placeholder="Model *"
                value={carForm.Model}
                onChange={(e) => setCarForm({...carForm, Model: e.target.value})}
                className="px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none"
              />

              <input
                type="number"
                placeholder="Yıl *"
                value={carForm.Yil}
                onChange={(e) => setCarForm({...carForm, Yil: e.target.value})}
                className="px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none"
              />

              <select
                value={carForm.YakitTipi}
                onChange={(e) => setCarForm({...carForm, YakitTipi: e.target.value})}
                className="px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none"
              >
                <option value="Benzin">Benzin</option>
                <option value="Dizel">Dizel</option>
                <option value="Elektrik">Elektrik</option>
                <option value="Hibrit">Hibrit</option>
              </select>

              <select
                value={carForm.VitesTuru}
                onChange={(e) => setCarForm({...carForm, VitesTuru: e.target.value})}
                className="px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none"
              >
                <option value="Manuel">Manuel</option>
                <option value="Otomatik">Otomatik</option>
              </select>

              <input
                type="number"
                placeholder="Günlük Kiralama Ücreti (₺) *"
                value={carForm.GunlukKiraUcreti}
                onChange={(e) => setCarForm({...carForm, GunlukKiraUcreti: e.target.value})}
                className="px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none md:col-span-2"
              />
            </div>

            <button
              onClick={handleAddCar}
              className="w-full bg-gradient-to-r from-blue-600 to-blue-700 text-white py-4 rounded-xl hover:shadow-lg transition font-semibold"
            >
              Araç Ekle
            </button>
          </div>
        </div>
      )}

      {/* EDIT CAR MODAL */}
      {showEditCarModal && selectedCar && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-2xl shadow-2xl max-w-lg w-full p-8">
            <div className="flex items-center justify-between mb-6">
              <h2 className="text-2xl font-bold text-gray-800">Araç Düzenle</h2>
              <button onClick={() => setShowEditCarModal(false)} className="text-gray-400 hover:text-gray-600">
                <XCircle className="w-6 h-6" />
              </button>
            </div>

            <div className="mb-4 bg-gray-50 p-4 rounded-xl">
              <h3 className="font-bold text-gray-800">{selectedCar.Marka} {selectedCar.Model}</h3>
              <p className="text-sm text-gray-600">{selectedCar.Plaka} - {selectedCar.Yil}</p>
            </div>

            <div className="space-y-4 mb-6">
              <input
                type="number"
                placeholder="Günlük Ücret"
                value={carForm.GunlukKiraUcreti}
                onChange={(e) => setCarForm({...carForm, GunlukKiraUcreti: e.target.value})}
                className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none"
              />

              <select
                value={carForm.YakitTipi}
                onChange={(e) => setCarForm({...carForm, YakitTipi: e.target.value})}
                className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none"
              >
                <option value="Benzin">Benzin</option>
                <option value="Dizel">Dizel</option>
                <option value="Elektrik">Elektrik</option>
                <option value="Hibrit">Hibrit</option>
              </select>

              <select
                value={carForm.VitesTuru}
                onChange={(e) => setCarForm({...carForm, VitesTuru: e.target.value})}
                className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none"
              >
                <option value="Manuel">Manuel</option>
                <option value="Otomatik">Otomatik</option>
              </select>
            </div>

            <button
              onClick={handleEditCar}
              className="w-full bg-gradient-to-r from-blue-600 to-blue-700 text-white py-4 rounded-xl hover:shadow-lg transition font-semibold"
            >
              Değişiklikleri Kaydet
            </button>
          </div>
        </div>
      )}
    </div>
  );
};

export default OfficeDashboardPage;