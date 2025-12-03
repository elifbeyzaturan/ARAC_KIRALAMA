import React from 'react';
import { Calendar, Fuel, Settings, Car } from 'lucide-react';

const CarCard = ({ car, onReserve }) => {
  return (
    <div className="bg-white rounded-2xl shadow-md hover:shadow-2xl transition-all duration-300 overflow-hidden group">
      {/* Image Placeholder with Car Icon */}
      <div className="h-48 bg-gradient-to-br from-blue-500 to-blue-700 flex items-center justify-center relative overflow-hidden">
        <div className="absolute inset-0 bg-black opacity-0 group-hover:opacity-10 transition-opacity"></div>
        <div className="text-white text-center transform group-hover:scale-110 transition-transform duration-300">
          <Car className="w-20 h-20 mx-auto mb-3 opacity-90" strokeWidth={1.5} />
          <p className="text-2xl font-bold tracking-wide">{car.Marka}</p>
          <p className="text-lg opacity-90">{car.Model}</p>
        </div>
      </div>

      {/* Content */}
      <div className="p-6">
        <div className="flex items-start justify-between mb-4">
          <div>
            <h3 className="text-xl font-bold text-gray-800">
              {car.Marka} {car.Model}
            </h3>
            <p className="text-gray-500 text-sm mt-1">{car.Plaka}</p>
          </div>
          <div className="bg-gradient-to-r from-blue-500 to-blue-600 text-white px-4 py-2 rounded-xl text-sm font-bold shadow-md">
            {car.GunlukKiraUcreti}₺
          </div>
        </div>

        <div className="space-y-3 mb-6">
          <div className="flex items-center justify-between text-sm">
            <div className="flex items-center text-gray-600">
              <Calendar className="w-4 h-4 mr-2 text-blue-500" />
              <span className="font-medium">Yıl</span>
            </div>
            <span className="text-gray-800 font-semibold">{car.Yil}</span>
          </div>

          <div className="flex items-center justify-between text-sm">
            <div className="flex items-center text-gray-600">
              <Fuel className="w-4 h-4 mr-2 text-blue-500" />
              <span className="font-medium">Yakıt</span>
            </div>
            <span className="text-gray-800 font-semibold">{car.YakitTipi}</span>
          </div>

          <div className="flex items-center justify-between text-sm">
            <div className="flex items-center text-gray-600">
              <Settings className="w-4 h-4 mr-2 text-blue-500" />
              <span className="font-medium">Vites</span>
            </div>
            <span className="text-gray-800 font-semibold">{car.VitesTuru}</span>
          </div>
        </div>

        <button
          onClick={() => onReserve(car)}
          className="w-full bg-gradient-to-r from-blue-600 to-blue-700 text-white py-3 rounded-xl hover:shadow-lg transition-all font-semibold transform hover:scale-105 hover:-translate-y-0.5"
        >
          Rezervasyon Yap
        </button>
      </div>
    </div>
  );
};

export default CarCard;