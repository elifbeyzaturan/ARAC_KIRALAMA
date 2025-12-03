import React, { useState, useEffect } from 'react';
import { Search, SlidersHorizontal, X, Calendar, MapPin } from 'lucide-react';
import { carService, officeService } from '../services/api';
import CarCard from '../components/CarCard';
import { useAuth } from '../context/AuthContext';

const CarsPage = ({ onLoginClick, onReserve }) => {
  const { user } = useAuth();
  const [cars, setCars] = useState([]);
  const [filteredCars, setFilteredCars] = useState([]);
  const [loading, setLoading] = useState(true);
  const [showFilters, setShowFilters] = useState(false);
  const [showDateSearch, setShowDateSearch] = useState(false);

  const [offices, setOffices] = useState([]);
  const [brands, setBrands] = useState([]);
  const [models, setModels] = useState([]);

  // Araç Filtreleri
  const [filters, setFilters] = useState({
    Marka: '',
    Model: '',
    YakitTipi: '',
    VitesTuru: '',
    MinFiyat: '',
    MaxFiyat: ''
  });

  // Tarih ve Ofis Arama
  const [dateSearch, setDateSearch] = useState({
    AlisOfisID: '',
    TeslimOfisID: '',
    AlisTarihi: '',
    TeslimTarihi: ''
  });

  useEffect(() => {
    loadCars();
    loadFilterOptions();
    loadOffices();
  }, []);

  const loadCars = async () => {
    try {
      const data = await carService.getAll();
      setCars(data);
      setFilteredCars(data);
    } catch (err) {
      console.error('Araçlar yüklenemedi:', err);
    } finally {
      setLoading(false);
    }
  };

  const loadOffices = async () => {
    try {
      const data = await officeService.getAll();
      setOffices(data);
    } catch (err) {
      console.error('Ofisler yüklenemedi:', err);
    }
  };

  const loadFilterOptions = async () => {
    try {
      const brandsData = await carService.getBrands();
      const modelsData = await carService.getModels();
      setBrands(brandsData);
      setModels(modelsData);
    } catch (err) {
      console.error('Filtre seçenekleri yüklenemedi:', err);
    }
  };

  const applyFilters = () => {
    let filtered = [...cars];

    if (filters.Marka) {
      filtered = filtered.filter(car => car.Marka === filters.Marka);
    }
    if (filters.Model) {
      filtered = filtered.filter(car => car.Model === filters.Model);
    }
    if (filters.YakitTipi) {
      filtered = filtered.filter(car => car.YakitTipi === filters.YakitTipi);
    }
    if (filters.VitesTuru) {
      filtered = filtered.filter(car => car.VitesTuru === filters.VitesTuru);
    }
    if (filters.MinFiyat) {
      filtered = filtered.filter(car => car.GunlukKiraUcreti >= parseFloat(filters.MinFiyat));
    }
    if (filters.MaxFiyat) {
      filtered = filtered.filter(car => car.GunlukKiraUcreti <= parseFloat(filters.MaxFiyat));
    }

    setFilteredCars(filtered);
    setShowFilters(false);
  };

  const resetFilters = () => {
    setFilters({
      Marka: '',
      Model: '',
      YakitTipi: '',
      VitesTuru: '',
      MinFiyat: '',
      MaxFiyat: ''
    });
    setFilteredCars(cars);
  };

  const searchByDate = async () => {
    if (!dateSearch.AlisOfisID || !dateSearch.AlisTarihi || !dateSearch.TeslimTarihi) {
      alert('Lütfen alış ofisi ve tarih aralığı seçin');
      return;
    }

    setLoading(true);
    try {
      const data = await carService.getAvailable({
        AlisOfisID: dateSearch.AlisOfisID,
        TeslimOfisID: dateSearch.TeslimOfisID || dateSearch.AlisOfisID,
        AlisTarihi: dateSearch.AlisTarihi,
        TeslimTarihi: dateSearch.TeslimTarihi
      });
      setFilteredCars(data);
    } catch (err) {
      // Backend henüz desteklemiyorsa mevcut araçları göster
      console.log('Tarih bazlı arama desteklenmiyor, tüm araçlar gösteriliyor');
      applyFilters();
    } finally {
      setLoading(false);
      setShowDateSearch(false);
    }
  };

  const handleReserve = (car) => {
    if (!user) {
      alert('Rezervasyon yapmak için giriş yapmalısınız.');
      onLoginClick();
      return;
    }
    // Tarih bilgilerini de gönder
    onReserve(car, dateSearch.AlisTarihi ? dateSearch : null);
  };

  const getTodayDate = () => {
    return new Date().toISOString().split('T')[0];
  };

  const getMinReturnDate = () => {
    if (!dateSearch.AlisTarihi) return getTodayDate();
    const pickupDate = new Date(dateSearch.AlisTarihi);
    pickupDate.setDate(pickupDate.getDate() + 1);
    return pickupDate.toISOString().split('T')[0];
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 to-blue-50">
      {/* Header */}
      <div className="bg-gradient-to-r from-blue-600 to-blue-700 text-white py-12">
        <div className="max-w-7xl mx-auto px-4">
          <h1 className="text-4xl font-bold mb-2">Araç Galerisi</h1>
          <p className="text-blue-100">
            {filteredCars.length} araç arasından size en uygununu bulun
          </p>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-4 py-8">
        {/* Action Buttons */}
        <div className="flex flex-wrap gap-3 mb-6">
          <button
            onClick={() => setShowDateSearch(!showDateSearch)}
            className={`flex items-center gap-2 px-6 py-3 rounded-xl shadow-md hover:shadow-lg transition ${
              showDateSearch ? 'bg-blue-600 text-white' : 'bg-white text-gray-700'
            }`}
          >
            <Calendar className="w-5 h-5" />
            <span className="font-medium">Tarih ile Ara</span>
          </button>

          <button
            onClick={() => setShowFilters(!showFilters)}
            className={`flex items-center gap-2 px-6 py-3 rounded-xl shadow-md hover:shadow-lg transition ${
              showFilters ? 'bg-blue-600 text-white' : 'bg-white text-gray-700'
            }`}
          >
            <SlidersHorizontal className="w-5 h-5" />
            <span className="font-medium">Özellik Filtrele</span>
          </button>

          {(Object.values(filters).some(val => val !== '') || dateSearch.AlisTarihi) && (
            <button
              onClick={() => {
                resetFilters();
                setDateSearch({ AlisOfisID: '', TeslimOfisID: '', AlisTarihi: '', TeslimTarihi: '' });
                loadCars();
              }}
              className="text-gray-600 hover:text-gray-800 flex items-center gap-1 px-4"
            >
              <X className="w-4 h-4" />
              Temizle
            </button>
          )}
        </div>

        {/* Date Search Panel */}
        {showDateSearch && (
          <div className="bg-white rounded-2xl shadow-lg p-6 mb-6 border-2 border-blue-100">
            <h3 className="text-xl font-bold text-gray-800 mb-4 flex items-center gap-2">
              <Calendar className="w-5 h-5 text-blue-600" />
              Tarih ve Ofis ile Ara
            </h3>
            <p className="text-gray-600 text-sm mb-4">
              Seçtiğiniz tarihlerde müsait araçları görüntüleyin
            </p>

            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
              {/* Alış Ofisi */}
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  <MapPin className="w-4 h-4 inline mr-1 text-blue-600" />
                  Alış Ofisi *
                </label>
                <select
                  value={dateSearch.AlisOfisID}
                  onChange={(e) => setDateSearch({...dateSearch, AlisOfisID: e.target.value})}
                  className="w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition"
                >
                  <option value="">Ofis Seçin</option>
                  {offices.map(office => (
                    <option key={office.OfisID} value={office.OfisID}>
                      {office.OfisAdi}
                    </option>
                  ))}
                </select>
              </div>

              {/* Teslim Ofisi */}
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  <MapPin className="w-4 h-4 inline mr-1 text-green-600" />
                  Teslim Ofisi
                </label>
                <select
                  value={dateSearch.TeslimOfisID}
                  onChange={(e) => setDateSearch({...dateSearch, TeslimOfisID: e.target.value})}
                  className="w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition"
                >
                  <option value="">Aynı Ofis</option>
                  {offices.map(office => (
                    <option key={office.OfisID} value={office.OfisID}>
                      {office.OfisAdi}
                    </option>
                  ))}
                </select>
              </div>

              {/* Alış Tarihi */}
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  <Calendar className="w-4 h-4 inline mr-1 text-blue-600" />
                  Alış Tarihi *
                </label>
                <input
                  type="date"
                  min={getTodayDate()}
                  value={dateSearch.AlisTarihi}
                  onChange={(e) => setDateSearch({...dateSearch, AlisTarihi: e.target.value, TeslimTarihi: ''})}
                  className="w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition"
                />
              </div>

              {/* Teslim Tarihi */}
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  <Calendar className="w-4 h-4 inline mr-1 text-green-600" />
                  Teslim Tarihi *
                </label>
                <input
                  type="date"
                  min={getMinReturnDate()}
                  value={dateSearch.TeslimTarihi}
                  onChange={(e) => setDateSearch({...dateSearch, TeslimTarihi: e.target.value})}
                  disabled={!dateSearch.AlisTarihi}
                  className="w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition disabled:bg-gray-100"
                />
              </div>
            </div>

            <button
              onClick={searchByDate}
              className="mt-4 w-full md:w-auto bg-gradient-to-r from-blue-600 to-blue-700 text-white px-8 py-3 rounded-xl hover:shadow-lg transition font-semibold flex items-center justify-center gap-2"
            >
              <Search className="w-5 h-5" />
              Müsait Araçları Bul
            </button>
          </div>
        )}

        {/* Filter Panel */}
        {showFilters && (
          <div className="bg-white rounded-2xl shadow-lg p-8 mb-8 border-2 border-blue-100">
            <h3 className="text-xl font-bold text-gray-800 mb-6 flex items-center">
              <SlidersHorizontal className="w-5 h-5 mr-2 text-blue-600" />
              Özellik Filtreleme
            </h3>

            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              {/* Marka */}
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  🚗 Marka
                </label>
                <select
                  value={filters.Marka}
                  onChange={(e) => setFilters({...filters, Marka: e.target.value})}
                  className="w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition"
                >
                  <option value="">Tüm Markalar</option>
                  {brands.map(brand => (
                    <option key={brand} value={brand}>{brand}</option>
                  ))}
                </select>
              </div>

              {/* Model */}
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  📋 Model
                </label>
                <select
                  value={filters.Model}
                  onChange={(e) => setFilters({...filters, Model: e.target.value})}
                  className="w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition"
                >
                  <option value="">Tüm Modeller</option>
                  {models.map(model => (
                    <option key={model} value={model}>{model}</option>
                  ))}
                </select>
              </div>

              {/* Yakıt */}
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  ⛽ Yakıt Tipi
                </label>
                <select
                  value={filters.YakitTipi}
                  onChange={(e) => setFilters({...filters, YakitTipi: e.target.value})}
                  className="w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition"
                >
                  <option value="">Tümü</option>
                  <option value="Benzin">Benzin</option>
                  <option value="Dizel">Dizel</option>
                  <option value="Elektrik">Elektrik</option>
                  <option value="Hibrit">Hibrit</option>
                </select>
              </div>

              {/* Vites */}
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  ⚙️ Vites Türü
                </label>
                <select
                  value={filters.VitesTuru}
                  onChange={(e) => setFilters({...filters, VitesTuru: e.target.value})}
                  className="w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition"
                >
                  <option value="">Tümü</option>
                  <option value="Manuel">Manuel</option>
                  <option value="Otomatik">Otomatik</option>
                </select>
              </div>

              {/* Min Fiyat */}
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  💰 Min Fiyat (₺/gün)
                </label>
                <input
                  type="number"
                  placeholder="0"
                  value={filters.MinFiyat}
                  onChange={(e) => setFilters({...filters, MinFiyat: e.target.value})}
                  className="w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition"
                />
              </div>

              {/* Max Fiyat */}
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  💰 Max Fiyat (₺/gün)
                </label>
                <input
                  type="number"
                  placeholder="∞"
                  value={filters.MaxFiyat}
                  onChange={(e) => setFilters({...filters, MaxFiyat: e.target.value})}
                  className="w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition"
                />
              </div>
            </div>

            <div className="flex gap-4 mt-8">
              <button
                onClick={applyFilters}
                className="flex-1 bg-gradient-to-r from-blue-600 to-blue-700 text-white py-4 rounded-xl hover:shadow-xl transition-all font-semibold text-lg transform hover:scale-105"
              >
                🔍 Filtrele
              </button>
              <button
                onClick={resetFilters}
                className="px-8 bg-gray-100 text-gray-700 py-4 rounded-xl hover:bg-gray-200 transition font-semibold"
              >
                ↺ Temizle
              </button>
            </div>
          </div>
        )}

        {/* Cars Grid */}
        {loading ? (
          <div className="text-center py-12">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
            <p className="mt-4 text-gray-600">Araçlar yükleniyor...</p>
          </div>
        ) : filteredCars.length === 0 ? (
          <div className="text-center py-12 bg-white rounded-2xl shadow-md">
            <p className="text-gray-600 text-lg">Filtrelere uygun araç bulunamadı.</p>
            <button
              onClick={() => {
                resetFilters();
                loadCars();
              }}
              className="mt-4 text-blue-600 hover:text-blue-700 font-medium"
            >
              Filtreleri temizle
            </button>
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {filteredCars.map(car => (
              <CarCard key={car.AracID} car={car} onReserve={handleReserve} />
            ))}
          </div>
        )}
      </div>
    </div>
  );
};

export default CarsPage;