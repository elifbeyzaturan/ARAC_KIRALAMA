import React, { useState, useEffect } from 'react';
import { Calendar, MapPin, Car as CarIcon, Clock, AlertCircle, CheckCircle, User, Award, Phone, Mail, CreditCard, FileText, Download, Printer, Info } from 'lucide-react';
import { officeService, reservationService, paymentService } from '../services/api';

const ReservationPage = ({ car, onBack, onSuccess, initialDates }) => {
  const [offices, setOffices] = useState([]);
  const [userInfo, setUserInfo] = useState(null);
  const [formData, setFormData] = useState({
    AlisOfisID: '',
    TeslimOfisID: initialDates?.TeslimOfisID || '',
    AlisTarihi: initialDates?.AlisTarihi || '',
    TeslimTarihi: initialDates?.TeslimTarihi || ''
  });
  const [totalPrice, setTotalPrice] = useState(0);
  const [days, setDays] = useState(0);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  // Aracın bulunduğu ofis bilgisi
  const [aracOfisi, setAracOfisi] = useState(null);

  // Ödeme ve Fatura State'leri
  const [step, setStep] = useState(1); // 1: Rezervasyon, 2: Ödeme, 3: Fatura
  const [reservationId, setReservationId] = useState(null);
  const [paymentData, setPaymentData] = useState({
    CardNumber: '',
    CardHolder: '',
    ExpiryDate: '',
    CVV: '',
    SaveCard: false
  });
  const [paymentLoading, setPaymentLoading] = useState(false);
  const [invoice, setInvoice] = useState(null);

  useEffect(() => {
    loadOffices();
    checkUserInfo();
  }, []);

  // Ofisler yüklendiğinde aracın ofisini bul ve alış ofisini otomatik seç
  useEffect(() => {
    if (offices.length > 0 && car?.MevcutOfisID) {
      const ofis = offices.find(o => o.OfisID === car.MevcutOfisID);
      setAracOfisi(ofis);

      // Alış ofisini otomatik olarak aracın bulunduğu ofis yap
      setFormData(prev => ({
        ...prev,
        AlisOfisID: car.MevcutOfisID.toString()
      }));
    }
  }, [offices, car]);

  useEffect(() => {
    calculatePrice();
  }, [formData.AlisTarihi, formData.TeslimTarihi]);

  const checkUserInfo = async () => {
    try {
      const token = localStorage.getItem('token');
      const res = await fetch('http://127.0.0.1:5000/api/kullanicilar/me', {
        headers: { 'Authorization': `Bearer ${token}` }
      });
      const data = await res.json();
      setUserInfo(data);
    } catch (err) {
      console.error('Kullanıcı bilgileri alınamadı:', err);
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

  const calculatePrice = () => {
    if (!formData.AlisTarihi || !formData.TeslimTarihi) {
      setTotalPrice(0);
      setDays(0);
      return;
    }

    const start = new Date(formData.AlisTarihi);
    const end = new Date(formData.TeslimTarihi);
    const diffTime = end - start;
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

    if (diffDays <= 0) {
      setTotalPrice(0);
      setDays(0);
      setError('Teslim tarihi, alış tarihinden sonra olmalıdır');
      return;
    }

    setDays(diffDays);
    setTotalPrice(diffDays * car.GunlukKiraUcreti);
    setError('');
  };

  const validateForm = () => {
    if (!userInfo?.EhliyetNumarasi) {
      setError('Rezervasyon yapabilmek için ehliyet numaranızı profilinize eklemeniz gerekmektedir.');
      return false;
    }

    if (!formData.AlisOfisID || !formData.TeslimOfisID) {
      setError('Lütfen alış ve teslim ofislerini seçin.');
      return false;
    }

    if (!formData.AlisTarihi || !formData.TeslimTarihi) {
      setError('Lütfen alış ve teslim tarihlerini seçin.');
      return false;
    }

    if (days <= 0) {
      setError('Geçerli bir tarih aralığı seçin.');
      return false;
    }

    return true;
  };

  const handleSubmit = async () => {
    if (!validateForm()) return;

    setLoading(true);
    setError('');

    try {
      const token = localStorage.getItem('token');
      const res = await fetch('http://127.0.0.1:5000/api/rezervasyonlar/add', {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          AracID: car.AracID,
          AracAdi: `${car.Marka} ${car.Model}`,
          AlisOfisID: formData.AlisOfisID,
          TeslimOfisID: formData.TeslimOfisID,
          AlisOfisi: offices.find(o => o.OfisID == formData.AlisOfisID)?.OfisAdi,
          TeslimOfisi: offices.find(o => o.OfisID == formData.TeslimOfisID)?.OfisAdi,
          AlisTarihi: formData.AlisTarihi,
          TeslimTarihi: formData.TeslimTarihi,
          ToplamUcret: totalPrice
        })
      });

      const data = await res.json();

      if (data.error) {
        setError(data.error);
        return;
      }

      setReservationId(data.RezervasyonID || data.rezervasyonId || Date.now());
      setStep(2); // Ödeme adımına geç
    } catch (err) {
      setError('Rezervasyon oluşturulurken hata oluştu: ' + err.message);
    } finally {
      setLoading(false);
    }
  };

  const validatePayment = () => {
    if (!paymentData.CardNumber || paymentData.CardNumber.replace(/\s/g, '').length < 16) {
      setError('Geçerli bir kart numarası girin');
      return false;
    }
    if (!paymentData.CardHolder || paymentData.CardHolder.length < 3) {
      setError('Kart sahibi adını girin');
      return false;
    }
    if (!paymentData.ExpiryDate || !/^\d{2}\/\d{2}$/.test(paymentData.ExpiryDate)) {
      setError('Geçerli bir son kullanma tarihi girin (AA/YY)');
      return false;
    }
    if (!paymentData.CVV || paymentData.CVV.length < 3) {
      setError('Geçerli bir CVV girin');
      return false;
    }
    return true;
  };

  const handlePayment = async () => {
    setError('');
    if (!validatePayment()) return;

    setPaymentLoading(true);

    try {
      // Gerçek API çağrısı (backend destekliyorsa)
      // const result = await paymentService.processPayment(reservationId, paymentData);

      // Simülasyon - Backend hazır olduğunda kaldırılacak
      await new Promise(resolve => setTimeout(resolve, 2000));

      // Fatura oluştur
      const invoiceData = {
        FaturaNo: `FTR-${Date.now()}`,
        RezervasyonID: reservationId,
        Tarih: new Date().toLocaleDateString('tr-TR'),
        Musteri: {
          Ad: userInfo.Ad,
          Soyad: userInfo.Soyad,
          Eposta: userInfo.Eposta,
          Telefon: userInfo.Telefon
        },
        Arac: {
          Marka: car.Marka,
          Model: car.Model,
          Plaka: car.Plaka
        },
        AlisOfisi: offices.find(o => o.OfisID == formData.AlisOfisID)?.OfisAdi,
        TeslimOfisi: offices.find(o => o.OfisID == formData.TeslimOfisID)?.OfisAdi,
        AlisTarihi: formData.AlisTarihi,
        TeslimTarihi: formData.TeslimTarihi,
        Gun: days,
        GunlukUcret: car.GunlukKiraUcreti,
        ToplamUcret: totalPrice,
        OdemeDurumu: 'Ödendi',
        OdemeTarihi: new Date().toLocaleString('tr-TR')
      };

      setInvoice(invoiceData);
      setStep(3); // Fatura adımına geç
    } catch (err) {
      setError('Ödeme işlemi başarısız: ' + err.message);
    } finally {
      setPaymentLoading(false);
    }
  };

  const formatCardNumber = (value) => {
    const v = value.replace(/\s+/g, '').replace(/[^0-9]/gi, '');
    const matches = v.match(/\d{4,16}/g);
    const match = matches && matches[0] || '';
    const parts = [];
    for (let i = 0, len = match.length; i < len; i += 4) {
      parts.push(match.substring(i, i + 4));
    }
    return parts.length ? parts.join(' ') : value;
  };

  const formatExpiryDate = (value) => {
    const v = value.replace(/\s+/g, '').replace(/[^0-9]/gi, '');
    if (v.length >= 2) {
      return v.substring(0, 2) + '/' + v.substring(2, 4);
    }
    return v;
  };

  const getTodayDate = () => {
    return new Date().toISOString().split('T')[0];
  };

  const getMinReturnDate = () => {
    if (!formData.AlisTarihi) return getTodayDate();
    const pickupDate = new Date(formData.AlisTarihi);
    pickupDate.setDate(pickupDate.getDate() + 1);
    return pickupDate.toISOString().split('T')[0];
  };

  const printInvoice = () => {
    window.print();
  };

  // Adım 3: Fatura Görüntüleme
  if (step === 3 && invoice) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-gray-50 to-blue-50 py-8">
        <div className="max-w-3xl mx-auto px-4">
          <div className="bg-white rounded-2xl shadow-xl p-8 print:shadow-none" id="invoice">
            {/* Fatura Başlığı */}
            <div className="flex items-center justify-between mb-8 border-b-2 border-blue-600 pb-6">
              <div className="flex items-center gap-3">
                <CarIcon className="w-12 h-12 text-blue-600" />
                <div>
                  <h1 className="text-3xl font-bold text-blue-600">Rent&Drive</h1>
                  <p className="text-gray-500 text-sm">Araç Kiralama Hizmetleri</p>
                </div>
              </div>
              <div className="text-right">
                <h2 className="text-2xl font-bold text-gray-800">FATURA</h2>
                <p className="text-gray-600 font-mono">{invoice.FaturaNo}</p>
                <p className="text-gray-500 text-sm">{invoice.Tarih}</p>
              </div>
            </div>

            {/* Başarı Mesajı */}
            <div className="bg-green-50 border-2 border-green-400 rounded-xl p-6 mb-8 flex items-center gap-4">
              <CheckCircle className="w-12 h-12 text-green-500" />
              <div>
                <h3 className="text-xl font-bold text-green-700">Ödeme Başarılı!</h3>
                <p className="text-green-600">Rezervasyonunuz onaylandı. İyi yolculuklar dileriz.</p>
              </div>
            </div>

            {/* Müşteri ve Araç Bilgileri */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
              <div className="bg-gray-50 p-5 rounded-xl">
                <h3 className="font-bold text-gray-800 mb-3 flex items-center gap-2">
                  <User className="w-5 h-5 text-blue-600" />
                  Müşteri Bilgileri
                </h3>
                <div className="space-y-2 text-sm">
                  <p><span className="text-gray-500">Ad Soyad:</span> <span className="font-semibold">{invoice.Musteri.Ad} {invoice.Musteri.Soyad}</span></p>
                  <p><span className="text-gray-500">E-posta:</span> <span className="font-semibold">{invoice.Musteri.Eposta}</span></p>
                  {invoice.Musteri.Telefon && (
                    <p><span className="text-gray-500">Telefon:</span> <span className="font-semibold">{invoice.Musteri.Telefon}</span></p>
                  )}
                </div>
              </div>

              <div className="bg-gray-50 p-5 rounded-xl">
                <h3 className="font-bold text-gray-800 mb-3 flex items-center gap-2">
                  <CarIcon className="w-5 h-5 text-blue-600" />
                  Araç Bilgileri
                </h3>
                <div className="space-y-2 text-sm">
                  <p><span className="text-gray-500">Araç:</span> <span className="font-semibold">{invoice.Arac.Marka} {invoice.Arac.Model}</span></p>
                  <p><span className="text-gray-500">Plaka:</span> <span className="font-semibold">{invoice.Arac.Plaka}</span></p>
                </div>
              </div>
            </div>

            {/* Kiralama Detayları */}
            <div className="bg-blue-50 p-5 rounded-xl mb-8">
              <h3 className="font-bold text-gray-800 mb-4 flex items-center gap-2">
                <Calendar className="w-5 h-5 text-blue-600" />
                Kiralama Detayları
              </h3>
              <div className="grid grid-cols-2 gap-4 text-sm">
                <div>
                  <p className="text-gray-500">Alış Ofisi</p>
                  <p className="font-semibold">{invoice.AlisOfisi}</p>
                </div>
                <div>
                  <p className="text-gray-500">Teslim Ofisi</p>
                  <p className="font-semibold">{invoice.TeslimOfisi}</p>
                </div>
                <div>
                  <p className="text-gray-500">Alış Tarihi</p>
                  <p className="font-semibold">{new Date(invoice.AlisTarihi).toLocaleDateString('tr-TR')}</p>
                </div>
                <div>
                  <p className="text-gray-500">Teslim Tarihi</p>
                  <p className="font-semibold">{new Date(invoice.TeslimTarihi).toLocaleDateString('tr-TR')}</p>
                </div>
              </div>
            </div>

            {/* Ücret Detayları */}
            <div className="border-2 border-gray-200 rounded-xl overflow-hidden mb-8">
              <table className="w-full">
                <thead className="bg-gray-100">
                  <tr>
                    <th className="text-left py-3 px-4 text-gray-700">Açıklama</th>
                    <th className="text-center py-3 px-4 text-gray-700">Miktar</th>
                    <th className="text-right py-3 px-4 text-gray-700">Birim Fiyat</th>
                    <th className="text-right py-3 px-4 text-gray-700">Toplam</th>
                  </tr>
                </thead>
                <tbody>
                  <tr className="border-t">
                    <td className="py-4 px-4">Günlük Araç Kiralama</td>
                    <td className="text-center py-4 px-4">{invoice.Gun} gün</td>
                    <td className="text-right py-4 px-4">{invoice.GunlukUcret}₺</td>
                    <td className="text-right py-4 px-4 font-semibold">{invoice.ToplamUcret}₺</td>
                  </tr>
                </tbody>
                <tfoot className="bg-blue-600 text-white">
                  <tr>
                    <td colSpan="3" className="py-4 px-4 font-bold text-right">GENEL TOPLAM</td>
                    <td className="py-4 px-4 text-right font-bold text-xl">{invoice.ToplamUcret}₺</td>
                  </tr>
                </tfoot>
              </table>
            </div>

            {/* Ödeme Bilgisi */}
            <div className="bg-green-50 border border-green-200 p-4 rounded-xl mb-8 flex items-center justify-between">
              <div className="flex items-center gap-2">
                <CheckCircle className="w-5 h-5 text-green-600" />
                <span className="font-semibold text-green-700">{invoice.OdemeDurumu}</span>
              </div>
              <span className="text-gray-600 text-sm">{invoice.OdemeTarihi}</span>
            </div>

            {/* Butonlar */}
            <div className="flex gap-4 print:hidden">
              <button
                onClick={printInvoice}
                className="flex-1 bg-gray-100 text-gray-700 py-3 rounded-xl hover:bg-gray-200 transition font-semibold flex items-center justify-center gap-2"
              >
                <Printer className="w-5 h-5" />
                Yazdır
              </button>
              <button
                onClick={onSuccess}
                className="flex-1 bg-gradient-to-r from-blue-600 to-blue-700 text-white py-3 rounded-xl hover:shadow-lg transition font-semibold"
              >
                Rezervasyonlarıma Git
              </button>
            </div>
          </div>
        </div>
      </div>
    );
  }

  // Adım 2: Ödeme Formu
  if (step === 2) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-gray-50 to-blue-50 py-8">
        <div className="max-w-2xl mx-auto px-4">
          {/* Progress Bar */}
          <div className="flex items-center justify-center mb-8">
            <div className="flex items-center">
              <div className="w-10 h-10 rounded-full bg-green-500 text-white flex items-center justify-center font-bold">✓</div>
              <div className="w-16 h-1 bg-green-500"></div>
              <div className="w-10 h-10 rounded-full bg-blue-600 text-white flex items-center justify-center font-bold">2</div>
              <div className="w-16 h-1 bg-gray-300"></div>
              <div className="w-10 h-10 rounded-full bg-gray-300 text-gray-600 flex items-center justify-center font-bold">3</div>
            </div>
          </div>

          <div className="bg-white rounded-2xl shadow-xl p-8">
            <div className="flex items-center gap-3 mb-6">
              <CreditCard className="w-8 h-8 text-blue-600" />
              <h2 className="text-2xl font-bold text-gray-800">Ödeme Bilgileri</h2>
            </div>

            {/* Özet */}
            <div className="bg-blue-50 border-2 border-blue-200 p-4 rounded-xl mb-6">
              <div className="flex justify-between items-center">
                <div>
                  <p className="text-gray-600">{car.Marka} {car.Model}</p>
                  <p className="text-sm text-gray-500">{days} gün kiralama</p>
                </div>
                <p className="text-2xl font-bold text-blue-600">{totalPrice}₺</p>
              </div>
            </div>

            {error && (
              <div className="bg-red-50 border-2 border-red-200 text-red-700 p-4 rounded-xl mb-6 flex items-start gap-3">
                <AlertCircle className="w-5 h-5 flex-shrink-0 mt-0.5" />
                <p className="text-sm">{error}</p>
              </div>
            )}

            <div className="space-y-4">
              {/* Kart Numarası */}
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  Kart Numarası
                </label>
                <input
                  type="text"
                  placeholder="0000 0000 0000 0000"
                  maxLength="19"
                  value={paymentData.CardNumber}
                  onChange={(e) => setPaymentData({...paymentData, CardNumber: formatCardNumber(e.target.value)})}
                  className="w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition font-mono text-lg"
                />
              </div>

              {/* Kart Sahibi */}
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  Kart Sahibi
                </label>
                <input
                  type="text"
                  placeholder="Ad Soyad"
                  value={paymentData.CardHolder}
                  onChange={(e) => setPaymentData({...paymentData, CardHolder: e.target.value.toUpperCase()})}
                  className="w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition uppercase"
                />
              </div>

              <div className="grid grid-cols-2 gap-4">
                {/* Son Kullanma Tarihi */}
                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Son Kullanma Tarihi
                  </label>
                  <input
                    type="text"
                    placeholder="AA/YY"
                    maxLength="5"
                    value={paymentData.ExpiryDate}
                    onChange={(e) => setPaymentData({...paymentData, ExpiryDate: formatExpiryDate(e.target.value)})}
                    className="w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition font-mono"
                  />
                </div>

                {/* CVV */}
                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    CVV
                  </label>
                  <input
                    type="password"
                    placeholder="***"
                    maxLength="4"
                    value={paymentData.CVV}
                    onChange={(e) => setPaymentData({...paymentData, CVV: e.target.value.replace(/\D/g, '')})}
                    className="w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition font-mono"
                  />
                </div>
              </div>

              {/* Kartı Kaydet */}
              <label className="flex items-center gap-3 cursor-pointer">
                <input
                  type="checkbox"
                  checked={paymentData.SaveCard}
                  onChange={(e) => setPaymentData({...paymentData, SaveCard: e.target.checked})}
                  className="w-5 h-5 rounded border-gray-300 text-blue-600 focus:ring-blue-500"
                />
                <span className="text-gray-700">Bu kartı sonraki ödemeler için kaydet</span>
              </label>

              {/* Ödeme Butonu */}
              <button
                onClick={handlePayment}
                disabled={paymentLoading}
                className="w-full bg-gradient-to-r from-green-500 to-green-600 text-white py-4 rounded-xl hover:shadow-xl transition font-bold text-lg flex items-center justify-center gap-2 mt-6"
              >
                {paymentLoading ? (
                  <>
                    <div className="animate-spin rounded-full h-5 w-5 border-b-2 border-white"></div>
                    Ödeme İşleniyor...
                  </>
                ) : (
                  <>
                    <CreditCard className="w-6 h-6" />
                    {totalPrice}₺ Öde
                  </>
                )}
              </button>

              <p className="text-center text-sm text-gray-500 mt-4">
                🔒 Ödeme bilgileriniz 256-bit SSL ile korunmaktadır
              </p>
            </div>
          </div>
        </div>
      </div>
    );
  }

  // Adım 1: Rezervasyon Formu
  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 to-blue-50 py-8">
      <div className="max-w-6xl mx-auto px-4">
        {/* Progress Bar */}
        <div className="flex items-center justify-center mb-8">
          <div className="flex items-center">
            <div className="w-10 h-10 rounded-full bg-blue-600 text-white flex items-center justify-center font-bold">1</div>
            <div className="w-16 h-1 bg-gray-300"></div>
            <div className="w-10 h-10 rounded-full bg-gray-300 text-gray-600 flex items-center justify-center font-bold">2</div>
            <div className="w-16 h-1 bg-gray-300"></div>
            <div className="w-10 h-10 rounded-full bg-gray-300 text-gray-600 flex items-center justify-center font-bold">3</div>
          </div>
        </div>

        {/* Back Button */}
        <button
          onClick={onBack}
          className="mb-6 text-blue-600 hover:text-blue-700 font-medium flex items-center gap-2 transition"
        >
          ← Geri Dön
        </button>

        {/* Ehliyet Uyarısı */}
        {!userInfo?.EhliyetNumarasi && (
          <div className="bg-yellow-50 border-2 border-yellow-400 rounded-2xl p-6 mb-6 flex items-start gap-4">
            <AlertCircle className="w-8 h-8 text-yellow-600 flex-shrink-0" />
            <div>
              <h3 className="text-lg font-bold text-gray-800 mb-1">Ehliyet Bilgisi Gerekli!</h3>
              <p className="text-gray-700 mb-3">Rezervasyon yapabilmek için profilinize ehliyet numaranızı eklemeniz gerekmektedir.</p>
            </div>
          </div>
        )}

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          {/* Araç Bilgileri */}
          <div className="bg-white rounded-2xl shadow-xl p-8 h-fit border border-gray-100">
            <div className="flex items-center mb-6">
              <div className="bg-gradient-to-br from-blue-500 to-blue-600 p-4 rounded-xl mr-4 shadow-lg">
                <CarIcon className="w-8 h-8 text-white" />
              </div>
              <div>
                <h2 className="text-2xl font-bold text-gray-800">Araç Bilgileri</h2>
                <p className="text-gray-600 text-sm">Seçtiğiniz araç</p>
              </div>
            </div>

            {/* Araç Kartı */}
            <div className="bg-gradient-to-br from-blue-500 via-blue-600 to-blue-700 text-white p-6 rounded-2xl mb-6 shadow-xl">
              <div className="flex items-center justify-between mb-4">
                <div>
                  <h3 className="text-3xl font-bold tracking-tight">{car.Marka}</h3>
                  <p className="text-xl text-blue-100 mt-1">{car.Model}</p>
                </div>
                <CarIcon className="w-16 h-16 opacity-90" strokeWidth={1.5} />
              </div>
              <div className="flex items-center justify-between text-blue-100 text-sm">
                <span>{car.Plaka}</span>
                <span>{car.Yil}</span>
              </div>
            </div>

            {/* Araç Özellikleri */}
            <div className="space-y-3">
              <div className="flex justify-between items-center py-2 border-b">
                <span className="text-gray-600">Yakıt Tipi</span>
                <span className="font-semibold">{car.YakitTipi}</span>
              </div>
              <div className="flex justify-between items-center py-2 border-b">
                <span className="text-gray-600">Vites</span>
                <span className="font-semibold">{car.VitesTuru}</span>
              </div>
              <div className="flex justify-between items-center py-2 border-b">
                <span className="text-gray-600">Mevcut Konum</span>
                <span className="font-semibold text-blue-600">
                  {aracOfisi ? aracOfisi.OfisAdi : 'Yükleniyor...'}
                </span>
              </div>
              <div className="flex justify-between items-center py-2">
                <span className="text-gray-600">Günlük Ücret</span>
                <span className="text-3xl font-bold text-blue-600">{car.GunlukKiraUcreti}₺</span>
              </div>
            </div>
          </div>

          {/* Rezervasyon Formu */}
          <div className="bg-white rounded-2xl shadow-xl p-8 border border-gray-100">
            <h2 className="text-2xl font-bold text-gray-800 mb-6">Rezervasyon Detayları</h2>

            {error && (
              <div className="bg-red-50 border-2 border-red-200 text-red-700 p-4 rounded-xl mb-6 flex items-start gap-3">
                <AlertCircle className="w-5 h-5 flex-shrink-0 mt-0.5" />
                <p className="text-sm">{error}</p>
              </div>
            )}

            <div className="space-y-5">
              {/* Alış Ofisi - Otomatik Seçili ve Devre Dışı */}
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  <MapPin className="w-4 h-4 inline mr-1 text-blue-600" />
                  Alış Ofisi
                </label>

                {/* Bilgi Mesajı */}
                <div className="bg-blue-50 border border-blue-200 rounded-lg p-3 mb-2 flex items-start gap-2">
                  <Info className="w-5 h-5 text-blue-600 flex-shrink-0 mt-0.5" />
                  <p className="text-sm text-blue-800">
                    Bu araç şu anda <strong>{aracOfisi?.OfisAdi || 'yükleniyor...'}</strong> ofisinde bulunmaktadır.
                    Aracı sadece bu ofisten alabilirsiniz.
                  </p>
                </div>

                <select
                  value={formData.AlisOfisID}
                  disabled={true}
                  className="w-full px-4 py-3 border-2 border-gray-200 rounded-xl bg-gray-100 text-gray-700 cursor-not-allowed"
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
                  value={formData.TeslimOfisID}
                  onChange={(e) => setFormData({...formData, TeslimOfisID: e.target.value})}
                  className="w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition"
                >
                  <option value="">Ofis Seçin</option>
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
                  value={formData.AlisTarihi}
                  onChange={(e) => setFormData({...formData, AlisTarihi: e.target.value})}
                  className="w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition"
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
                  value={formData.TeslimTarihi}
                  onChange={(e) => setFormData({...formData, TeslimTarihi: e.target.value})}
                  className="w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition"
                />
              </div>

              {/* Fiyat Özeti */}
              {totalPrice > 0 && (
                <div className="bg-gradient-to-br from-green-50 to-green-100 border-2 border-green-300 p-6 rounded-2xl shadow-md">
                  <div className="space-y-4">
                    <div className="flex items-center justify-between">
                      <span className="text-gray-700 flex items-center gap-2 font-medium">
                        <Clock className="w-5 h-5 text-green-600" />
                        Kiralama Süresi
                      </span>
                      <span className="text-xl font-bold text-gray-800">{days} Gün</span>
                    </div>
                    <div className="flex items-center justify-between">
                      <span className="text-gray-700 font-medium">Günlük Ücret</span>
                      <span className="text-xl font-bold text-gray-800">{car.GunlukKiraUcreti}₺</span>
                    </div>
                    <div className="border-t-2 border-green-400 pt-4 flex items-center justify-between">
                      <span className="text-gray-800 font-bold text-lg">
                        Toplam Ücret
                      </span>
                      <span className="text-4xl font-bold text-green-600">
                        {totalPrice}₺
                      </span>
                    </div>
                  </div>
                </div>
              )}

              {/* Kullanıcı Bilgileri */}
              {userInfo && (
                <div className="bg-gradient-to-br from-blue-50 to-blue-100 border-2 border-blue-200 p-5 rounded-2xl shadow-sm">
                  <h3 className="font-bold text-gray-800 mb-4 flex items-center gap-2 text-lg">
                    <User className="w-5 h-5 text-blue-600" />
                    Rezervasyon Sahibi
                  </h3>
                  <div className="space-y-3 text-sm">
                    <div className="flex justify-between items-center bg-white bg-opacity-50 p-3 rounded-lg">
                      <span className="text-gray-600 font-medium flex items-center gap-2">
                        <User className="w-4 h-4" />
                        Ad Soyad
                      </span>
                      <span className="font-bold text-gray-800">{userInfo.Ad} {userInfo.Soyad}</span>
                    </div>
                    <div className="flex justify-between items-center bg-white bg-opacity-50 p-3 rounded-lg">
                      <span className="text-gray-600 font-medium flex items-center gap-2">
                        <Mail className="w-4 h-4" />
                        E-posta
                      </span>
                      <span className="font-bold text-gray-800">{userInfo.Eposta}</span>
                    </div>
                    {userInfo.Telefon && (
                      <div className="flex justify-between items-center bg-white bg-opacity-50 p-3 rounded-lg">
                        <span className="text-gray-600 font-medium flex items-center gap-2">
                          <Phone className="w-4 h-4" />
                          Telefon
                        </span>
                        <span className="font-bold text-gray-800">{userInfo.Telefon}</span>
                      </div>
                    )}
                    {userInfo.EhliyetNumarasi && (
                      <div className="flex justify-between items-center bg-green-100 p-3 rounded-lg border-2 border-green-300">
                        <span className="text-gray-700 font-medium flex items-center gap-2">
                          <Award className="w-4 h-4 text-green-600" />
                          Ehliyet
                        </span>
                        <span className="font-bold text-green-700 flex items-center gap-1">
                          <CheckCircle className="w-4 h-4" />
                          {userInfo.EhliyetNumarasi}
                        </span>
                      </div>
                    )}
                  </div>
                </div>
              )}

              {/* Submit Button */}
              <button
                onClick={handleSubmit}
                disabled={loading || totalPrice <= 0 || !userInfo?.EhliyetNumarasi}
                className="w-full bg-gradient-to-r from-blue-600 to-blue-700 text-white py-4 rounded-xl hover:shadow-xl hover:scale-105 transition-all disabled:bg-gray-400 disabled:cursor-not-allowed disabled:hover:scale-100 font-bold text-lg flex items-center justify-center gap-2"
              >
                {loading ? (
                  <>
                    <div className="animate-spin rounded-full h-5 w-5 border-b-2 border-white"></div>
                    Rezervasyon Yapılıyor...
                  </>
                ) : (
                  <>
                    <CheckCircle className="w-6 h-6" />
                    Ödemeye Geç
                  </>
                )}
              </button>

              {!userInfo?.EhliyetNumarasi && (
                <p className="text-center text-sm text-red-600 font-medium flex items-center justify-center gap-1">
                  <AlertCircle className="w-4 h-4" />
                  Rezervasyon yapabilmek için ehliyet bilgisi gereklidir
                </p>
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ReservationPage;