import { Route, Routes } from 'react-router-dom';
import Layout from './components/Layout';
import Home from './pages/Home';
import Catalog from './pages/Catalog';
import Checker from './pages/Checker';
import Learn from './pages/Learn';
import Drones from './pages/Drones';
import Login from './pages/Login';
import Builds from './pages/Builds';

function Stub({ title }: { title: string }) {
  return (
    <div className="page">
      <h1 className="h-page">{title}</h1>
      <p className="muted">Сторінка в розробці.</p>
    </div>
  );
}

export default function App() {
  return (
    <Routes>
      <Route element={<Layout />}>
        <Route index element={<Home />} />
        <Route path="catalog" element={<Catalog />} />
        <Route path="checker" element={<Checker />} />
        <Route path="drones" element={<Drones />} />
        <Route path="login" element={<Login />} />
        <Route path="builds" element={<Builds />} />
        <Route path="learn" element={<Learn />} />
        <Route path="notes" element={<Stub title="Нотатки" />} />
        <Route path="*" element={<Stub title="Сторінку не знайдено" />} />
      </Route>
    </Routes>
  );
}
