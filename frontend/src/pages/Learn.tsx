import { Link } from 'react-router-dom';
import { Icon } from '../icons';
import Img from '../components/Img';

const lessons = [
  { n: '01', title: 'Дізнайтеся, як влаштований дрон', desc: 'Рама, мотори, ESC, контролер, пропелери, акумулятор і FPV-система: роль кожної деталі.', meta: 'Для початківців / 8 хв', progress: 100 },
  { n: '02', title: 'Основи сумісності компонентів', desc: 'Звіряйте кріплення, зазори, напругу та протоколи. Однаковий роз’єм не гарантує сумісності.', meta: 'Для початківців / 10 хв', progress: 100 },
  { n: '03', title: 'Підберіть збалансований комплект деталей', desc: 'Рама → пропелер → мотор → ESC → акумулятор. Звіряйте поєднання з тестами виробника.', meta: 'Для початківців / 15 хв', progress: 0 },
  { n: '04', title: 'Підготуйте робоче місце до складання', desc: 'Підготуйте інструменти й схеми. Сплануйте проводку, ізоляцію та перевірку полярності.', meta: 'Для початківців / 12 хв', progress: 0 },
  { n: '05', title: 'Безпечне поводження з LiPo', desc: 'Заряджайте LiPo під наглядом за інструкцією. Не використовуйте пошкоджені чи здуті акумулятори.', meta: 'Для початківців / 10 хв', progress: 0 },
  { n: '06', title: 'Перевірка перед польотом', desc: 'Перевірте кріплення, керування й failsafe. Для стендових тестів зніміть пропелери.', meta: 'Для початківців / 10 хв', progress: 0 },
];
const done = lessons.filter((l) => l.progress === 100).length;
const next = lessons.find((l) => l.progress < 100)!;

export default function Learn() {
  return (
    <div className="page-flush">
      <section className="progress-band">
        <div className="progress-band__in">
          <h1 className="h-page">Навчання</h1>
          <p className="muted">Продовжуйте урок {Number(next.n)}: підберіть збалансований комплект деталей.</p>
          <div className="progress-band__row"><span className="muted">Пройдено {done} з {lessons.length}</span><span className="muted">Далі — урок {Number(next.n)}</span></div>
          <div className="track track--lg"><i style={{ width: `${(done / lessons.length) * 100}%` }} /></div>
          <a href="#lessons" className="btn btn--primary btn--xs">Продовжити урок <Icon name="arrowRight" /></a>
        </div>
      </section>

      <section id="lessons" className="lessons">
        <h2 className="h-page">Уроки</h2>
        <p className="muted">Проходьте уроки послідовно. Тримайте документацію виробника під рукою.</p>
        <div className="lgrid">
          {lessons.map((l, i) => (
            <article key={l.n} className="lesson">
              <header><span className="lesson__n">{l.n}</span></header>
              <div className="lesson__body">
                <h3>{l.title}</h3>
                <Img id={`lesson${i + 1}`} className="lesson__img" label={`Урок ${l.n}`} />
                <p className="muted">{l.desc}</p>
                <div className="lprog">
                  <div><span>{l.progress === 100 ? 'Пройдено' : 'Прогрес'}</span><b className={l.progress === 100 ? 't-accent' : ''}>{l.progress}%</b></div>
                  <div className="track"><i style={{ width: `${l.progress}%` }} /></div>
                </div>
              </div>
              <footer>
                <span className="muted">{l.meta}</span>
                <button className="read">{l.progress === 100 ? 'Пройдено' : 'Читати урок'} <Icon name="arrowRight" size={14} /></button>
              </footer>
            </article>
          ))}
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
