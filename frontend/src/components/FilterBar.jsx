import React, { useState, useEffect } from 'react';
import { Filter } from 'lucide-react';
import { carService } from '../services/api';

const FilterBar = ({ onFilter }) => {
  const [brands, setBrands] = useState([]);
  const [models, setModels] = useState([]);
  const [filters, setFilters] = useState({
    Marka: '',
    Model: '',
    YakitTipi: '',
    VitesTuru: '',
    MinFiyat: '',
    MaxFiyat: ''
  });

  useEffect(() => {
    loadFilterOptions();
  }, []);

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

  const handleFilterChange = (field, value) => {
    setFilters(prev => ({ ...prev, [field]: value }));
  };

  const applyFilters = () => {
    onFilter(filters);
  };

  const resetFilters = () => {
    const emptyFilters = {
      Marka: '',
      Model: '',
      YakitTipi: '',
      VitesTuru: '',
      MinFiyat: '',
      MaxFiyat: ''
    };
    setFilters(emptyFilters);
    onFilter(emptyFilters);
  };

  return (
    <div className="bg-white rounded-xl shadow-md p-6 mb-6">
      <div className="flex items-center mb-4">
        <Filter className="w-5 h-5 text-blue-600 mr-2" />
        <h3 className="text-lg font-semibold text-gray-800">Filtrele</h3>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        {/* Marka */}
        <select
          value={filters.Marka}
          onChange={(e) => handleFilterChange('Marka', e.target.value)}
          className="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none"
        >
          <option value="">Tüm Markalar</option>
          {brands.map(brand => (
            <option key={brand} value={brand}>{brand}</option>
          ))}
        </select>

        {/* Model */}
        <select
          value={filters.Model}
          onChange={(e) => handleFilterChange('Model', e.target.value)}
          className="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none"
        >
          <option value="">Tüm Modeller</option>
          {models.map(model => (
            <option key={model} value={model}>{model}</option>
          ))}
        </select>

        {/* Yakıt */}
        <select
          value={filters.YakitTipi}
          onChange={(e) => handleFilterChange('YakitTipi', e.target.value)}
          className="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none"
        >
          <option value="">Yakıt Tipi</option>
          <option value="Benzin">Benzin</option>
          <option value="Dizel">Dizel</option>
          <option value="Elektrik">Elektrik</option>
          <option value="Hibrit">Hibrit</option>
        </select>

        {/* Vites */}
        <select
          value={filters.VitesTuru}
          onChange={(e) => handleFilterChange('VitesTuru', e.target.value)}
          className="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none"
        >
          <option value="">Vites Türü</option>
          <option value="Manuel">Manuel</option>
          <option value="Otomatik">Otomatik</option>
        </select>

        {/* Min Fiyat */}
        <input
          type="number"
          placeholder="Min Fiyat (₺)"
          value={filters.MinFiyat}
          onChange={(e) => handleFilterChange('MinFiyat', e.target.value)}
          className="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none"
        />

        {/* Max Fiyat */}
        <input
          type="number"
          placeholder="Max Fiyat (₺)"
          value={filters.MaxFiyat}
          onChange={(e) => handleFilterChange('MaxFiyat', e.target.value)}
          className="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none"
        />
      </div>

      {/* Action Buttons */}
      <div className="flex gap-3 mt-4">
        <button
          onClick={applyFilters}
          className="flex-1 bg-blue-600 text-white py-2 rounded-lg hover:bg-blue-700 transition font-medium"
        >
          Filtrele
        </button>
        <button
          onClick={resetFilters}
          className="px-6 bg-gray-200 text-gray-700 py-2 rounded-lg hover:bg-gray-300 transition font-medium"
        >
          Temizle
        </button>
      </div>
    </div>
  );
};

export default FilterBar;