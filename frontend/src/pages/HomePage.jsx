import React, { useState, useEffect } from 'react';
import { Car, Shield, Clock, Award, MapPin, Calendar, Search, ChevronRight, AlertCircle } from 'lucide-react';
import { carService, officeService } from '../services/api';
import CarCard from '../components/CarCard';
import { useAuth } from '../context/AuthContext';

const HomePage = ({ onLoginClick, onReserve, setCurrentPage }) => {
  const { user } = useAuth();
  const [cars, setCars] = useState([]);
  const [offices, setOffices] = useState([]);
  const [loading, setLoading] = useState(true);
  const [searchLoading, setSearchLoading] = useState(false);
  const [searchResults, setSearchResults] = useState(null);

  // Arama formu
  const [searchForm, setSearchForm] = useState({
    AlisOfisID: '',
    TeslimOfisID: '',
    AlisTarihi: '',
    TeslimTarihi: ''
  });
  const [searchError, setSearchError] = useState('');

  useEffect(() => {
    loadCars();
    loadOffices();
  }, []);

  const loadCars = async () => {
    try {
      const data = await carService.getAll();
      setCars(data.slice(0, 6));
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

  const handleReserve = (car) => {
    if (!user) {
      alert('Rezervasyon yapmak için giriş yapmalısınız.');
      onLoginClick();
      return;
    }
    onReserve(car, searchForm);
  };

  const getTodayDate = () => {
    return new Date().toISOString().split('T')[0];
  };

  const getMinReturnDate = () => {
    if (!searchForm.AlisTarihi) return getTodayDate();
    const pickupDate = new Date(searchForm.AlisTarihi);
    pickupDate.setDate(pickupDate.getDate() + 1);
    return pickupDate.toISOString().split('T')[0];
  };

  const handleSearch = async () => {
    setSearchError('');

    if (!searchForm.AlisOfisID) {
      setSearchError('Lütfen alış ofisi seçin');
      return;
    }
    if (!searchForm.AlisTarihi) {
      setSearchError('Lütfen alış tarihi seçin');
      return;
    }
    if (!searchForm.TeslimTarihi) {
      setSearchError('Lütfen teslim tarihi seçin');
      return;
    }

    const start = new Date(searchForm.AlisTarihi);
    const end = new Date(searchForm.TeslimTarihi);
    if (end <= start) {
      setSearchError('Teslim tarihi, alış tarihinden sonra olmalıdır');
      return;
    }

    setSearchLoading(true);
    try {
      const data = await carService.getAvailable({
        AlisOfisID: searchForm.AlisOfisID,
        TeslimOfisID: searchForm.TeslimOfisID || searchForm.AlisOfisID,
        AlisTarihi: searchForm.AlisTarihi,
        TeslimTarihi: searchForm.TeslimTarihi
      });
      setSearchResults(data);
    } catch (err) {
      console.error('Arama hatası:', err);
      setSearchError('Arama yapılırken bir hata oluştu. Lütfen tekrar deneyin.');
      setSearchResults([]);
    } finally {
      setSearchLoading(false);
    }
  };

  const clearSearch = () => {
    setSearchResults(null);
    setSearchForm({
      AlisOfisID: '',
      TeslimOfisID: '',
      AlisTarihi: '',
      TeslimTarihi: ''
    });
    setSearchError('');
  };

  // Seçilen ofis adını bul
  const getOfficeName = (officeId) => {
    const office = offices.find(o => o.OfisID == officeId);
    return office ? office.OfisAdi : '';
  };

  return (
    <div>
      {/* Hero Section with Search */}
      <div className="bg-gradient-to-br from-blue-600 via-blue-700 to-blue-800 text-white py-16">
        <div className="max-w-7xl mx-auto px-4">
          <div className="text-center mb-10">
            <h1 className="text-5xl md:text-6xl font-bold mb-6">
              Hayalinizdeki Aracı Kiralayın
            </h1>
            <p className="text-xl md:text-2xl text-blue-100 mb-8">
              En uygun fiyatlarla, güvenli ve kolay rezervasyon
            </p>
          </div>

          {/* Search Box */}
          <div className="bg-white rounded-2xl shadow-2xl p-6 md:p-8 max-w-5xl mx-auto">
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-4">
              {/* Alış Ofisi */}
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  <MapPin className="w-4 h-4 inline mr-1 text-blue-600" />
                  Alış Ofisi
                </label>
                <select
                  value={searchForm.AlisOfisID}
                  onChange={(e) => setSearchForm({...searchForm, AlisOfisID: e.target.value})}
                  className="w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition text-gray-800"
                >
                  <option value="">Ofis Seçin</option>
                  {offices.map(office => (
                    <option key={office.OfisID} value={office.OfisID}>
                      {office.OfisAdi} {office.Sehir && `- ${office.Sehir}`}
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
                  value={searchForm.TeslimOfisID}
                  onChange={(e) => setSearchForm({...searchForm, TeslimOfisID: e.target.value})}
                  className="w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition text-gray-800"
                >
                  <option value="">Aynı Ofis</option>
                  {offices.map(office => (
                    <option key={office.OfisID} value={office.OfisID}>
                      {office.OfisAdi} {office.Sehir && `- ${office.Sehir}`}
                    </option>
                  ))}
                </select>
              </div>

              {/* Alış Tarihi */}
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  <Calendar className="w-4 h-4 inline mr-1 text-blue-600" />
                  Alış Tarihi
                </label>
                <input
                  type="date"
                  min={getTodayDate()}
                  value={searchForm.AlisTarihi}
                  onChange={(e) => setSearchForm({...searchForm, AlisTarihi: e.target.value, TeslimTarihi: ''})}
                  className="w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition text-gray-800"
                />
              </div>

              {/* Teslim Tarihi */}
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  <Calendar className="w-4 h-4 inline mr-1 text-green-600" />
                  Teslim Tarihi
                </label>
                <input
                  type="date"
                  min={getMinReturnDate()}
                  value={searchForm.TeslimTarihi}
                  onChange={(e) => setSearchForm({...searchForm, TeslimTarihi: e.target.value})}
                  className="w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition text-gray-800"
                  disabled={!searchForm.AlisTarihi}
                />
              </div>
            </div>

            {searchError && (
              <div className="bg-red-50 border border-red-200 rounded-lg p-3 mb-4 flex items-center gap-2">
                <AlertCircle className="w-5 h-5 text-red-500 flex-shrink-0" />
                <p className="text-red-600 text-sm">{searchError}</p>
              </div>
            )}

            <button
              onClick={handleSearch}
              disabled={searchLoading}
              className="w-full bg-gradient-to-r from-blue-600 to-blue-700 text-white py-4 rounded-xl hover:shadow-lg transition font-semibold text-lg flex items-center justify-center gap-2"
            >
              {searchLoading ? (
                <>
                  <div className="animate-spin rounded-full h-5 w-5 border-b-2 border-white"></div>
                  Aranıyor...
                </>
              ) : (
                <>
                  <Search className="w-5 h-5" />
                  Araç Ara
                </>
              )}
            </button>
          </div>
        </div>
      </div>

      {/* Search Results */}
      {searchResults !== null && (
        <div className="py-12 bg-gray-50">
          <div className="max-w-7xl mx-auto px-4">
            <div className="flex items-center justify-between mb-8">
              <div>
                <h2 className="text-3xl font-bold text-gray-800">Arama Sonuçları</h2>
                <p className="text-gray-600 mt-1">
                  <span className="font-semibold text-blue-600">{getOfficeName(searchForm.AlisOfisID)}</span> ofisinde {searchResults.length} araç bulundu
                </p>
              </div>
              <button
                onClick={clearSearch}
                className="text-blue-600 hover:text-blue-700 font-medium"
              >
                Aramayı Temizle
              </button>
            </div>

            {searchResults.length === 0 ? (
              <div className="bg-white rounded-2xl shadow-md p-12 text-center">
                <Car className="w-16 h-16 text-gray-400 mx-auto mb-4" />
                <h3 className="text-xl font-semibold text-gray-800 mb-2">
                  Uygun araç bulunamadı
                </h3>
                <p className="text-gray-600">
                  Seçtiğiniz ofis ve tarihler için müsait araç bulunmamaktadır. Lütfen farklı bir ofis veya tarih deneyin.
                </p>
              </div>
            ) : (
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                {searchResults.map(car => (
                  <CarCard key={car.AracID} car={car} onReserve={handleReserve} />
                ))}
              </div>
            )}
          </div>
        </div>
      )}

      {/* Features Section */}
      {searchResults === null && (
        <>
          <div className="py-16 bg-gray-50">
            <div className="max-w-7xl mx-auto px-4">
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
                <div className="text-center">
                  <div className="bg-blue-100 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                    <Car className="w-8 h-8 text-blue-600" />
                  </div>
                  <h3 className="text-lg font-semibold mb-2">Geniş Araç Filosu</h3>
                  <p className="text-gray-600">Her bütçeye uygun araç seçenekleri</p>
                </div>

                <div className="text-center">
                  <div className="bg-green-100 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                    <Shield className="w-8 h-8 text-green-600" />
                  </div>
                  <h3 className="text-lg font-semibold mb-2">Güvenli Kiralama</h3>
                  <p className="text-gray-600">Sigortalı ve bakımlı araçlar</p>
                </div>

                <div className="text-center">
                  <div className="bg-purple-100 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                    <Clock className="w-8 h-8 text-purple-600" />
                  </div>
                  <h3 className="text-lg font-semibold mb-2">Hızlı Teslimat</h3>
                  <p className="text-gray-600">Anında rezervasyon onayı</p>
                </div>

                <div className="text-center">
                  <div className="bg-orange-100 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                    <Award className="w-8 h-8 text-orange-600" />
                  </div>
                  <h3 className="text-lg font-semibold mb-2">Uygun Fiyatlar</h3>
                  <p className="text-gray-600">En iyi fiyat garantisi</p>
                </div>
              </div>
            </div>
          </div>

          {/* Featured Cars Section */}
          <div id="featured-cars" className="py-16">
            <div className="max-w-7xl mx-auto px-4">
              <div className="text-center mb-12">
                <h2 className="text-4xl font-bold text-gray-800 mb-4">Öne Çıkan Araçlar</h2>
                <p className="text-gray-600 text-lg">Popüler araçlarımızı keşfedin</p>
              </div>

              {loading ? (
                <div className="text-center py-12">
                  <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
                  <p className="mt-4 text-gray-600">Araçlar yükleniyor...</p>
                </div>
              ) : (
                <>
                  <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    {cars.map(car => (
                      <CarCard key={car.AracID} car={car} onReserve={handleReserve} />
                    ))}
                  </div>

                  <div className="text-center mt-10">
                    <button
                      onClick={() => setCurrentPage('cars')}
                      className="inline-flex items-center gap-2 bg-blue-600 text-white px-8 py-4 rounded-xl hover:bg-blue-700 transition font-semibold"
                    >
                      Tüm Araçları Görüntüle
                      <ChevronRight className="w-5 h-5" />
                    </button>
                  </div>
                </>
              )}
            </div>
          </div>
        </>
      )}

      {/* CTA Section */}
      <div className="bg-blue-600 text-white py-16">
        <div className="max-w-7xl mx-auto px-4 text-center">
          <h2 className="text-3xl font-bold mb-4">Hemen Rezervasyon Yapın!</h2>
          <p className="text-xl text-blue-100 mb-8">
            Yüzlerce araç arasından size en uygununu bulun
          </p>
          {!user && (
            <button
              onClick={onLoginClick}
              className="bg-white text-blue-600 px-8 py-4 rounded-lg text-lg font-semibold hover:bg-blue-50 transition shadow-lg"
            >
              Giriş Yapın
            </button>
          )}
        </div>
      </div>
    </div>
  );
};

export default HomePage;