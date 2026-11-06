import { Link } from 'react-router-dom';

export default function Home() {
  return (
    <div className="container">
      <section className="hero">
        <p className="muted">Каталог FPV-компонентів</p>
        <h1>Зберіть свій дрон із сумісних деталей</h1>
        <p className="muted">Оберіть раму, мотори, ESC, польотний контролер, пропелери та акумулятор.</p>
        <div className="row">
          <Link to="/checker" className="btn btn--primary">Почати збірку</Link>
          <Link to="/catalog" className="btn">Відкрити каталог</Link>
        </div>
      </section>
    </div>
  );
}
