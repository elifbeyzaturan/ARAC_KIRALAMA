import React, { useState, useEffect } from 'react';
import { Calendar, MapPin, DollarSign, AlertCircle, FileText, Eye, Car, User, CheckCircle, X, Printer } from 'lucide-react';
import { reservationService } from '../services/api';

const MyReservationsPage = () => {
  const [reservations, setReservations] = useState([]);
  const [loading, setLoading] = useState(true);
  const [selectedInvoice, setSelectedInvoice] = useState(null);
  const [filterStatus, setFilterStatus] = useState('all');

  useEffect(() => {
    loadReservations();
  }, []);

  const loadReservations = async () => {
    try {
      const data = await reservationService.getMy();
      setReservations(data.Rezervasyonlar || []);
    } catch (err) {
      console.error('Rezervasyonlar yüklenemedi:', err);
    } finally {
      setLoading(false);
    }
  };

  const handleCancel = async (id) => {
    if (!window.confirm('Bu rezervasyonu iptal etmek istediğinize emin misiniz?')) {
      return;
    }

    try {
      await reservationService.cancel(id);
      alert('Rezervasyon iptal edildi.');
      loadReservations();
    } catch (err) {
      alert('İptal işlemi başarısız: ' + err.message);
    }
  };

  const viewInvoice = (reservation) => {
    // Fatura bilgilerini oluştur
    const invoice = {
      FaturaNo: `FTR-${reservation.RezervasyonID}`,
      RezervasyonID: reservation.RezervasyonID,
      Tarih: new Date().toLocaleDateString('tr-TR'),
      Arac: `${reservation.Marka} ${reservation.Model}`,
      AlisOfisi: reservation.AlisOfisi,
      TeslimOfisi: reservation.TeslimOfisi,
      AlisTarihi: reservation.AlisTarihi,
      TeslimTarihi: reservation.TeslimTarihi,
      ToplamUcret: reservation.ToplamUcret,
      Durum: reservation.Durum
    };
    setSelectedInvoice(invoice);
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
      'Beklemede': 'bg-yellow-100 text-yellow-800 border-yellow-300',
      'Onaylandı': 'bg-green-100 text-green-800 border-green-300',
      'İptal Edildi': 'bg-red-100 text-red-800 border-red-300',
      'Tamamlandı': 'bg-blue-100 text-blue-800 border-blue-300'
    };
    return colors[status] || 'bg-gray-100 text-gray-800 border-gray-300';
  };

  const filteredReservations = filterStatus === 'all'
    ? reservations
    : reservations.filter(r => r.Durum === filterStatus);

  const calculateDays = (start, end) => {
    const startDate = new Date(start);
    const endDate = new Date(end);
    const diffTime = endDate - startDate;
    return Math.ceil(diffTime / (1000 * 60 * 60 * 24));
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 py-12 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
          <p className="mt-4 text-gray-600">Rezervasyonlar yükleniyor...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 to-blue-50 py-8">
      <div className="max-w-7xl mx-auto px-4">
        {/* Header */}
        <div className="bg-gradient-to-r from-blue-600 to-blue-700 text-white rounded-2xl p-8 mb-8">
          <h1 className="text-4xl font-bold mb-2">Rezervasyonlarım</h1>
          <p className="text-blue-100">
            Toplam {reservations.length} rezervasyon
          </p>
        </div>

        {/* Filter Buttons */}
        <div className="bg-white rounded-xl shadow-md p-4 mb-6">
          <div className="flex flex-wrap gap-3">
            <button
              onClick={() => setFilterStatus('all')}
              className={`px-4 py-2 rounded-lg font-medium transition ${
                filterStatus === 'all' 
                  ? 'bg-blue-600 text-white' 
                  : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
              }`}
            >
              Tümü ({reservations.length})
            </button>
            <button
              onClick={() => setFilterStatus('Beklemede')}
              className={`px-4 py-2 rounded-lg font-medium transition ${
                filterStatus === 'Beklemede' 
                  ? 'bg-yellow-500 text-white' 
                  : 'bg-yellow-100 text-yellow-700 hover:bg-yellow-200'
              }`}
            >
              Beklemede ({reservations.filter(r => r.Durum === 'Beklemede').length})
            </button>
            <button
              onClick={() => setFilterStatus('Onaylandı')}
              className={`px-4 py-2 rounded-lg font-medium transition ${
                filterStatus === 'Onaylandı' 
                  ? 'bg-green-500 text-white' 
                  : 'bg-green-100 text-green-700 hover:bg-green-200'
              }`}
            >
              Onaylanan ({reservations.filter(r => r.Durum === 'Onaylandı').length})
            </button>
            <button
              onClick={() => setFilterStatus('Tamamlandı')}
              className={`px-4 py-2 rounded-lg font-medium transition ${
                filterStatus === 'Tamamlandı' 
                  ? 'bg-blue-500 text-white' 
                  : 'bg-blue-100 text-blue-700 hover:bg-blue-200'
              }`}
            >
              Tamamlanan ({reservations.filter(r => r.Durum === 'Tamamlandı').length})
            </button>
            <button
              onClick={() => setFilterStatus('İptal Edildi')}
              className={`px-4 py-2 rounded-lg font-medium transition ${
                filterStatus === 'İptal Edildi' 
                  ? 'bg-red-500 text-white' 
                  : 'bg-red-100 text-red-700 hover:bg-red-200'
              }`}
            >
              İptal ({reservations.filter(r => r.Durum === 'İptal Edildi').length})
            </button>
          </div>
        </div>

        {filteredReservations.length === 0 ? (
          <div className="bg-white rounded-xl shadow-md p-12 text-center">
            <AlertCircle className="w-16 h-16 text-gray-400 mx-auto mb-4" />
            <h3 className="text-xl font-semibold text-gray-800 mb-2">
              {filterStatus === 'all'
                ? 'Henüz rezervasyonunuz yok'
                : `"${filterStatus}" durumunda rezervasyon bulunamadı`}
            </h3>
            <p className="text-gray-600">
              {filterStatus === 'all' && 'Araç kiralayarak ilk rezervasyonunuzu oluşturun'}
            </p>
          </div>
        ) : (
          <div className="space-y-4">
            {filteredReservations.map(reservation => (
              <div
                key={reservation.RezervasyonID}
                className="bg-white rounded-2xl shadow-md hover:shadow-lg transition overflow-hidden"
              >
                <div className="p-6">
                  <div className="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
                    <div className="flex-1">
                      {/* Araç Bilgisi */}
                      <div className="flex items-center gap-3 mb-4">
                        <div className="bg-blue-100 p-3 rounded-xl">
                          <Car className="w-6 h-6 text-blue-600" />
                        </div>
                        <div>
                          <h3 className="text-xl font-bold text-gray-800">
                            {reservation.Marka} {reservation.Model}
                          </h3>
                          <p className="text-gray-500 text-sm">
                            Rezervasyon #{reservation.RezervasyonID}
                          </p>
                        </div>
                      </div>

                      {/* Detaylar */}
                      <div className="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm">
                        <div className="flex items-start gap-2">
                          <MapPin className="w-4 h-4 mt-0.5 text-blue-500" />
                          <div>
                            <p className="text-gray-500">Alış Ofisi</p>
                            <p className="font-medium text-gray-800">{reservation.AlisOfisi}</p>
                          </div>
                        </div>

                        <div className="flex items-start gap-2">
                          <MapPin className="w-4 h-4 mt-0.5 text-green-500" />
                          <div>
                            <p className="text-gray-500">Teslim Ofisi</p>
                            <p className="font-medium text-gray-800">{reservation.TeslimOfisi}</p>
                          </div>
                        </div>

                        <div className="flex items-start gap-2">
                          <Calendar className="w-4 h-4 mt-0.5 text-blue-500" />
                          <div>
                            <p className="text-gray-500">Tarih Aralığı</p>
                            <p className="font-medium text-gray-800">
                              {formatDate(reservation.AlisTarihi)} → {formatDate(reservation.TeslimTarihi)}
                            </p>
                            <p className="text-xs text-gray-400">
                              ({calculateDays(reservation.AlisTarihi, reservation.TeslimTarihi)} gün)
                            </p>
                          </div>
                        </div>

                        <div className="flex items-start gap-2">
                          <DollarSign className="w-4 h-4 mt-0.5 text-green-500" />
                          <div>
                            <p className="text-gray-500">Toplam Ücret</p>
                            <p className="font-bold text-xl text-green-600">
                              {reservation.ToplamUcret}₺
                            </p>
                          </div>
                        </div>
                      </div>
                    </div>

                    {/* Sağ Taraf - Durum ve Aksiyonlar */}
                    <div className="flex flex-col items-end gap-3">
                      <span className={`px-4 py-2 rounded-full text-sm font-semibold border-2 ${getStatusColor(reservation.Durum)}`}>
                        {reservation.Durum}
                      </span>

                      <div className="flex gap-2">
                        {/* Fatura Görüntüle */}
                        {(reservation.Durum === 'Onaylandı' || reservation.Durum === 'Tamamlandı') && (
                          <button
                            onClick={() => viewInvoice(reservation)}
                            className="flex items-center gap-2 px-4 py-2 bg-blue-100 text-blue-700 rounded-lg hover:bg-blue-200 transition text-sm font-medium"
                          >
                            <FileText className="w-4 h-4" />
                            Fatura
                          </button>
                        )}

                        {/* İptal Et */}
                        {(reservation.Durum === 'Beklemede' || reservation.Durum === 'Onaylandı') && (
                          <button
                            onClick={() => handleCancel(reservation.RezervasyonID)}
                            className="flex items-center gap-2 px-4 py-2 bg-red-100 text-red-700 rounded-lg hover:bg-red-200 transition text-sm font-medium"
                          >
                            <X className="w-4 h-4" />
                            İptal Et
                          </button>
                        )}
                      </div>
                    </div>
                  </div>
                </div>

                {/* Durum Çubuğu */}
                <div className={`h-1 ${
                  reservation.Durum === 'Onaylandı' ? 'bg-green-500' :
                  reservation.Durum === 'Tamamlandı' ? 'bg-blue-500' :
                  reservation.Durum === 'İptal Edildi' ? 'bg-red-500' :
                  'bg-yellow-500'
                }`}></div>
              </div>
            ))}
          </div>
        )}
      </div>

      {/* Fatura Modal */}
      {selectedInvoice && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-2xl shadow-2xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
            <div className="p-8" id="invoice-print">
              {/* Fatura Başlığı */}
              <div className="flex items-center justify-between mb-8 border-b-2 border-blue-600 pb-6">
                <div className="flex items-center gap-3">
                  <Car className="w-10 h-10 text-blue-600" />
                  <div>
                    <h1 className="text-2xl font-bold text-blue-600">Rent&Drive</h1>
                    <p className="text-gray-500 text-sm">Araç Kiralama Hizmetleri</p>
                  </div>
                </div>
                <div className="text-right">
                  <h2 className="text-xl font-bold text-gray-800">FATURA</h2>
                  <p className="text-gray-600 font-mono text-sm">{selectedInvoice.FaturaNo}</p>
                  <p className="text-gray-500 text-xs">{selectedInvoice.Tarih}</p>
                </div>
              </div>

              {/* Durum Bilgisi */}
              <div className={`p-4 rounded-xl mb-6 flex items-center gap-3 ${
                selectedInvoice.Durum === 'Tamamlandı' ? 'bg-blue-50 border-2 border-blue-200' :
                selectedInvoice.Durum === 'Onaylandı' ? 'bg-green-50 border-2 border-green-200' :
                'bg-gray-50 border-2 border-gray-200'
              }`}>
                <CheckCircle className={`w-8 h-8 ${
                  selectedInvoice.Durum === 'Tamamlandı' ? 'text-blue-500' :
                  selectedInvoice.Durum === 'Onaylandı' ? 'text-green-500' :
                  'text-gray-500'
                }`} />
                <div>
                  <p className="font-semibold text-gray-800">Durum: {selectedInvoice.Durum}</p>
                  <p className="text-sm text-gray-600">
                    {selectedInvoice.Durum === 'Tamamlandı'
                      ? 'Bu kiralama başarıyla tamamlanmıştır.'
                      : 'Rezervasyonunuz onaylanmıştır.'}
                  </p>
                </div>
              </div>

              {/* Araç ve Kiralama Bilgileri */}
              <div className="grid grid-cols-2 gap-6 mb-6">
                <div className="bg-gray-50 p-4 rounded-xl">
                  <h3 className="font-bold text-gray-800 mb-3 flex items-center gap-2">
                    <Car className="w-5 h-5 text-blue-600" />
                    Araç Bilgileri
                  </h3>
                  <p className="text-lg font-semibold">{selectedInvoice.Arac}</p>
                </div>

                <div className="bg-gray-50 p-4 rounded-xl">
                  <h3 className="font-bold text-gray-800 mb-3 flex items-center gap-2">
                    <Calendar className="w-5 h-5 text-blue-600" />
                    Süre
                  </h3>
                  <p className="text-lg font-semibold">
                    {calculateDays(selectedInvoice.AlisTarihi, selectedInvoice.TeslimTarihi)} Gün
                  </p>
                </div>
              </div>

              {/* Ofis ve Tarih Bilgileri */}
              <div className="bg-blue-50 p-4 rounded-xl mb-6">
                <div className="grid grid-cols-2 gap-4 text-sm">
                  <div>
                    <p className="text-gray-500">Alış Ofisi</p>
                    <p className="font-semibold">{selectedInvoice.AlisOfisi}</p>
                  </div>
                  <div>
                    <p className="text-gray-500">Teslim Ofisi</p>
                    <p className="font-semibold">{selectedInvoice.TeslimOfisi}</p>
                  </div>
                  <div>
                    <p className="text-gray-500">Alış Tarihi</p>
                    <p className="font-semibold">{formatDate(selectedInvoice.AlisTarihi)}</p>
                  </div>
                  <div>
                    <p className="text-gray-500">Teslim Tarihi</p>
                    <p className="font-semibold">{formatDate(selectedInvoice.TeslimTarihi)}</p>
                  </div>
                </div>
              </div>

              {/* Ücret */}
              <div className="bg-gradient-to-r from-green-500 to-green-600 text-white p-6 rounded-xl mb-6">
                <div className="flex justify-between items-center">
                  <span className="text-lg font-medium">Toplam Ücret</span>
                  <span className="text-3xl font-bold">{selectedInvoice.ToplamUcret}₺</span>
                </div>
              </div>

              {/* Butonlar */}
              <div className="flex gap-4">
                <button
                  onClick={() => window.print()}
                  className="flex-1 flex items-center justify-center gap-2 bg-gray-100 text-gray-700 py-3 rounded-xl hover:bg-gray-200 transition font-medium"
                >
                  <Printer className="w-5 h-5" />
                  Yazdır
                </button>
                <button
                  onClick={() => setSelectedInvoice(null)}
                  className="flex-1 bg-blue-600 text-white py-3 rounded-xl hover:bg-blue-700 transition font-medium"
                >
                  Kapat
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default MyReservationsPage;