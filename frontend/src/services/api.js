// API Base URL
export const API_URL = 'http://127.0.0.1:5000/api';

// Generic API call function
export const apiCall = async (endpoint, options = {}) => {
  const token = localStorage.getItem('token');
  const officeToken = localStorage.getItem('ofisToken');

  const headers = {
    'Content-Type': 'application/json',
    ...options.headers,
  };

  if (token) {
    headers['Authorization'] = `Bearer ${token}`;
  } else if (officeToken) {
    headers['Authorization'] = `Bearer ${officeToken}`;
  }

  const response = await fetch(`${API_URL}${endpoint}`, {
    ...options,
    headers,
  });

  const data = await response.json();

  if (data.error) {
    throw new Error(data.error);
  }

  return data;
};

// Auth Services
export const authService = {
  login: (email, password) =>
    apiCall('/auth/login', {
      method: 'POST',
      body: JSON.stringify({ Eposta: email, Sifre: password })
    }),

  loginOffice: (email, password) =>
    apiCall('/auth/ofis-login', {
      method: 'POST',
      body: JSON.stringify({ Eposta: email, Sifre: password })
    }),

  register: (userData) =>
    apiCall('/auth/register', {
      method: 'POST',
      body: JSON.stringify(userData)
    })
};

// Car Services
export const carService = {
  getAll: () => apiCall('/araclar/'),

  getById: (id) => apiCall(`/araclar/${id}`),

  getFiltered: (filters) =>
    apiCall('/araclar/filtreli', {
      method: 'POST',
      body: JSON.stringify(filters)
    }),

  getBrands: () => apiCall('/araclar/markalar'),

  getModels: () => apiCall('/araclar/modeller'),

  // Tarih ve ofis bazlı müsait araçları getir - /filtreli endpoint'ini kullanıyor
  getAvailable: (params) =>
    apiCall('/araclar/filtreli', {
      method: 'POST',
      body: JSON.stringify(params)
    }),

  // Sadece müsait araçları getir (filtresiz)
  getMusait: () => apiCall('/araclar/musait'),

  // Belirli ofisteki araçları getir
  getByOffice: (ofisId) => apiCall(`/araclar/ofis/${ofisId}`)
};

// Office Services
export const officeService = {
  getAll: () => apiCall('/ofis/list'),

  getReservations: (type) => apiCall(`/ofis/rezervasyonlar/${type}`),

  updateReservationStatus: (id, status) =>
    apiCall(`/ofis/rezervasyonlar/${id}/durum`, {
      method: 'PUT',
      body: JSON.stringify({ Durum: status })
    }),

  getDashboard: () => apiCall('/ofis/dashboard'),

  addCar: (carData) =>
    apiCall('/ofis/araclar/ekle', {
      method: 'POST',
      body: JSON.stringify(carData)
    }),

  updateCar: (id, carData) =>
    apiCall(`/ofis/araclar/${id}`, {
      method: 'PUT',
      body: JSON.stringify(carData)
    }),

  updateCarStatus: (id, status) =>
    apiCall(`/ofis/araclar/${id}/durum`, {
      method: 'PUT',
      body: JSON.stringify({ Durum: status })
    }),

  getCars: () => apiCall('/ofis/araclar')
};

// Reservation Services
export const reservationService = {
  create: (data) =>
    apiCall('/rezervasyonlar/add', {
      method: 'POST',
      body: JSON.stringify(data)
    }),

  getMy: () => apiCall('/rezervasyonlar/my'),

  cancel: (id) =>
    apiCall(`/rezervasyonlar/cancel/${id}`, {
      method: 'PUT'
    }),

  getById: (id) => apiCall(`/rezervasyonlar/${id}`),

  // Fatura görüntüleme
  getInvoice: (id) => apiCall(`/rezervasyonlar/${id}/fatura`)
};

// Payment Services
export const paymentService = {
  // Ödeme işlemi
  processPayment: (reservationId, paymentData) =>
    apiCall(`/odeme/isle`, {
      method: 'POST',
      body: JSON.stringify({
        RezervasyonID: reservationId,
        ...paymentData
      })
    }),

  // Ödeme durumu kontrol
  checkStatus: (reservationId) =>
    apiCall(`/odeme/durum/${reservationId}`),

  // Kayıtlı kartlar
  getSavedCards: () => apiCall('/odeme/kartlar'),

  addCard: (cardData) =>
    apiCall('/odeme/kartlar/ekle', {
      method: 'POST',
      body: JSON.stringify(cardData)
    }),

  deleteCard: (cardId) =>
    apiCall(`/odeme/kartlar/${cardId}`, {
      method: 'DELETE'
    })
};

// User Services
export const userService = {
  getMe: () => apiCall('/kullanicilar/me'),

  updateProfile: (userData) =>
    apiCall('/kullanicilar/guncelle', {
      method: 'PUT',
      body: JSON.stringify(userData)
    }),

  updateLicense: (licenseNumber) =>
    apiCall('/kullanicilar/ehliyet', {
      method: 'PUT',
      body: JSON.stringify({ EhliyetNumarasi: licenseNumber })
    }),

  changePassword: (oldPassword, newPassword) =>
    apiCall('/kullanicilar/sifre-degistir', {
      method: 'PUT',
      body: JSON.stringify({ EskiSifre: oldPassword, YeniSifre: newPassword })
    })
};