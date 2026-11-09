import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { api } from '../api';
import { Icon } from '../icons';
import Img from '../components/Img';

// Координати з макета (панель 744 × 428). Виводимо у відсотках, щоб масштабувалось.
const W = 744, H = 428;
const labels = [
  { n: 6, t: 'Акумулятор', x: 557, y: 41, w: 164 },
  { n: 5, t: 'Пропелери', x: 555, y: 347, w: 166 },
  { n: 4, t: 'Польотний контролер', x: 533, y: 129, w: 188, tall: true },
  { n: 3, t: 'ESC', x: 587, y: 235, w: 100 },
  { n: 2, t: 'Мотори', x: 19, y: 134, w: 112 },
  { n: 1, t: 'Рама', x: 19, y: 269, w: 112 },
];
// Лінії-виноски (SVG з Figma)
const leaders = [
  { x: 506, y: 190, w: 49, h: 175, vb: '0 0 50 176', d: 'M0.353516 0.353546L25.3535 25.3535V155.354L49.3535 175.354' },
  { x: 387, y: 198, w: 200, h: 55, vb: '0 0 201 56', d: 'M0.172119 0.469452L150.172 55.4695H200.172' },
  { x: 385, y: 153, w: 148, h: 8, vb: '0 0 149 9', d: 'M0.0383301 0.498535L104.038 8.49854H148.038' },
  { x: 394, y: 59, w: 163, h: 33, vb: '0 0 164 34', d: 'M0.137939 33.5L115.138 0.5H163.138' },
  { x: 131, y: 152, w: 74, h: 78, vb: '0 0 75 79', d: 'M0 0.5H25L74 78.5' },
  { x: 131, y: 277, w: 176, h: 10, vb: '0 0 177 11', d: 'M0 10.4984H50L176 0.498444' },
];
const pct = (v: number, base: number) => `${(v / base) * 100}%`;

export default function Home() {
  const [stats, setStats] = useState<{ products: number; categories: number; voltages: number } | null>(null);
  useEffect(() => { api.stats().then(setStats).catch(() => undefined); }, []);
  return (
    <>
      <section className="hero">
        <div className="hero__intro">
          <p className="muted">Каталог FPV-компонентів</p>
          <h1 className="h-hero">Зберіть свій дрон<br />із сумісних<br />деталей</h1>
          <p className="hero__lead">Обирайте раму, мотори, ESC, польотний контролер, пропелери й акумулятор. Порівнюйте характеристики та розраховуйте вартість збірки в одному місці.</p>
          <div style={{ display: 'flex', gap: 12, flexWrap: 'wrap' }}>
            <Link to="/catalog" className="btn btn--primary">Почати збірку <Icon name="arrowRight" /></Link>
            <Link to="/drones" className="btn btn--secondary">Готові збірки</Link>
          </div>
          <dl className="stats">
            <div><dt>{stats?.products ?? '—'}</dt><dd>компонентів</dd></div>
            <div><dt>{stats?.categories ?? '—'}</dt><dd>категорій</dd></div>
            <div><dt>{stats?.voltages ?? '—'}</dt><dd>типи напруги</dd></div>
          </dl>
        </div>

        <div className="anatomy">
          <div className="anatomy__stage" style={{ aspectRatio: `${W} / ${H}` }}>
            <Img id="drone" label="Розібраний дрон" alt="Розібраний FPV-дрон" className="anatomy__photo"
              />
            {leaders.map((l, i) => (
              <svg key={i} className="leader" viewBox={l.vb} preserveAspectRatio="none" aria-hidden="true"
                style={{ left: pct(l.x, W), top: pct(l.y, H), width: pct(l.w, W), height: pct(l.h, H) }}>
                <path d={l.d} fill="none" stroke="currentColor" vectorEffect="non-scaling-stroke" />
              </svg>
            ))}
            {labels.map((l) => (
              <div key={l.n} className="tag" style={{ left: pct(l.x, W), top: pct(l.y, H), width: pct(l.w, W) }}>
                <b>{l.n}</b><span>{l.t}</span>
              </div>
            ))}
          </div>
          <p className="muted">Шість основних компонентів. Приймач і відеосистема підбираються окремо.</p>
        </div>
      </section>

      <section className="strip-wrap">
        <div className="strip">
          <Icon name="bookOpen" />
          <div className="strip__text">
            <h2>Вперше збираєте FPV-дрон?</h2>
            <p className="muted">Почніть з основ: як влаштований дрон, за що відповідає ESC і чому важлива напруга. Пояснюємо просто та послідовно.</p>
          </div>
          <Link to="/learn" className="btn btn--secondary">Перейти до навчання <Icon name="arrowRight" /></Link>
        </div>
      </section>
    </>
  );
}
