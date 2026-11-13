import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { Icon } from '../icons';
import Img from '../components/Img';

const lessons = [
  { n: '01', title: 'Дізнайтеся, як влаштований дрон', desc: 'Рама, мотори, ESC, контролер, пропелери, акумулятор і FPV-система: роль кожної деталі.', meta: 'Для початківців / 8 хв', progress: 0 },
  { n: '02', title: 'Основи сумісності компонентів', desc: 'Звіряйте кріплення, зазори, напругу та протоколи. Однаковий роз’єм не гарантує сумісності.', meta: 'Для початківців / 10 хв', progress: 0 },
  { n: '03', title: 'Підберіть збалансований комплект деталей', desc: 'Рама → пропелер → мотор → ESC → акумулятор. Звіряйте поєднання з тестами виробника.', meta: 'Для початківців / 15 хв', progress: 0 },
  { n: '04', title: 'Підготуйте робоче місце до складання', desc: 'Підготуйте інструменти й схеми. Сплануйте проводку, ізоляцію та перевірку полярності.', meta: 'Для початківців / 12 хв', progress: 0 },
  { n: '05', title: 'Безпечне поводження з LiPo', desc: 'Заряджайте LiPo під наглядом за інструкцією. Не використовуйте пошкоджені чи здуті акумулятори.', meta: 'Для початківців / 10 хв', progress: 0 },
  { n: '06', title: 'Перевірка перед польотом', desc: 'Перевірте кріплення, керування й failsafe. Для стендових тестів зніміть пропелери.', meta: 'Для початківців / 10 хв', progress: 0 },
];
const KEY = 'technokit:lessons:v1';

export default function Learn() {
  // Прогрес зберігається в браузері; спочатку жоден урок не пройдено.
  const [doneSet, setDoneSet] = useState<string[]>(() => {
    try { const v = JSON.parse(localStorage.getItem(KEY) ?? '[]'); return Array.isArray(v) ? v.filter((x) => typeof x === 'string') : []; } catch { return []; }
  });
  useEffect(() => { try { localStorage.setItem(KEY, JSON.stringify(doneSet)); } catch { /* ignore */ } }, [doneSet]);
  const toggle = (n: string) => setDoneSet((cur) => (cur.includes(n) ? cur.filter((x) => x !== n) : [...cur, n]));
  const isDone = (n: string) => doneSet.includes(n);
  const done = lessons.filter((l) => isDone(l.n)).length;
  const next = lessons.find((l) => !isDone(l.n));

  return (
    <div className="page-flush">
      <section className="progress-band">
        <div className="progress-band__in">
          <h1 className="h-page">Навчання</h1>
          <p className="muted">{next ? `${done ? 'Продовжуйте' : 'Почніть з'} урок${done ? '' : 'у'} ${Number(next.n)}: ${next.title.charAt(0).toLowerCase()}${next.title.slice(1)}.` : 'Усі уроки пройдено. Перейдіть до вибору деталей і перевірки збірки.'}</p>
          <div className="progress-band__row"><span className="muted">Пройдено {done} з {lessons.length}</span><span className="muted">{next ? `Далі — урок ${Number(next.n)}` : 'Готово'}</span></div>
          <div className="track track--lg"><i style={{ width: `${(done / lessons.length) * 100}%` }} /></div>
          <a href="#lessons" className="btn btn--primary btn--xs">{done ? 'Продовжити урок' : 'Почати навчання'} <Icon name="arrowRight" /></a>
        </div>
      </section>

      <section id="lessons" className="lessons">
        <h2 className="h-page">Уроки</h2>
        <p className="muted">Проходьте уроки послідовно. Тримайте документацію виробника під рукою.</p>
        <div className="lgrid">
          {lessons.map((l, i) => {
            const ok = isDone(l.n);
            const progress = ok ? 100 : 0;
            return (
            <article key={l.n} className="lesson">
              <header><span className="lesson__n">{l.n}</span></header>
              <div className="lesson__body">
                <h3>{l.title}</h3>
                <Img id={`lesson${i + 1}`} className="lesson__img" label={`Урок ${l.n}`} />
                <p className="muted">{l.desc}</p>
                <div className="lprog">
                  <div><span>{ok ? 'Пройдено' : 'Прогрес'}</span><b className={ok ? 't-accent' : ''}>{progress}%</b></div>
                  <div className="track"><i style={{ width: `${progress}%` }} /></div>
                </div>
              </div>
              <footer>
                <span className="muted">{l.meta}</span>
                <button className="read" aria-pressed={ok} onClick={() => toggle(l.n)} title={ok ? 'Зняти позначку «пройдено»' : 'Позначити урок пройденим'}>{ok ? 'Пройдено' : 'Читати урок'} <Icon name={ok ? 'circleCheck' : 'arrowRight'} size={14} /></button>
              </footer>
            </article>
            );
          })}
        </div>
      </section>

      <section className="before">
        <div className="safety">
          <Icon name="shieldAlert" className="t-accent" />
          <div>
            <b className="t-accent">Перед подачею живлення</b>
            <p className="muted">Ці уроки — вступ, а не повна інструкція зі складання чи польоту. Керуйтеся характеристиками й інструкціями виробника щодо сумісності, складання та безпеки. Якщо параметр, підключення або дія незрозумілі, зупиніться й проконсультуйтеся з досвідченим збирачем до подачі живлення.</p>
          </div>
        </div>
        <div className="practice">
          <div>
            <h2>Оберіть деталі й перевірте сумісність</h2>
            <p className="muted">Після уроків перегляньте список обраних деталей. Порівняння — лише початкова перевірка, а не підтвердження безпеки.</p>
          </div>
          <div className="practice__actions">
            <Link to="/catalog" className="btn btn--secondary">Обрати деталі <Icon name="arrowUpRight" /></Link>
            <Link to="/checker" className="btn btn--secondary">Перевірка сумісності <Icon name="arrowUpRight" /></Link>
            <Link to="/checker" className="btn btn--tertiary">Перевірити збірку <Icon name="arrowUpRight" /></Link>
          </div>
        </div>
      </section>
    </div>
  );
}
