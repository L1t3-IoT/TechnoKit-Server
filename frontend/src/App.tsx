import { Route, Routes } from 'react-router-dom';
import Layout from './components/Layout';
import Home from './pages/Home';
import Catalog from './pages/Catalog';
import Checker from './pages/Checker';
import Learn from './pages/Learn';

export default function App() {
  return (
    <Routes>
      <Route element={<Layout />}>
        <Route index element={<Home />} />
        <Route path="catalog" element={<Catalog />} />
        <Route path="checker" element={<Checker />} />
        <Route path="learn" element={<Learn />} />
        <Route path="*" element={<div className="container"><h1>404</h1><p>Сторінку не знайдено.</p></div>} />
      </Route>
    </Routes>
  );
}
