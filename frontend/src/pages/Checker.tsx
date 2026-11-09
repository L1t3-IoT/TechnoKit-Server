import { Link } from 'react-router-dom';
import { Icon, type IconName } from '../icons';
import Img from '../components/Img';

// Демонстраційні дані з макета. Пізніше замінюються реальною збіркою користувача та правилами сумісності.
type State = 'ok' | 'warn' | 'open';
const parts: { cat: string; marker?: string; name: string; l1: string; l2: string; price: string; qty: string; state: State; img: string }[] = [
  { cat: 'Рама', name: 'AX5 Carbon', l1: 'Пропелер до 5.2″ · колісна база 225 мм', l2: 'Stack 30.5 × 30.5 мм · кріплення моторів 16 × 16 мм', price: '$59.00', qty: '×1', state: 'ok', img: 'partFrame' },
  { cat: 'Мотори', marker: '/ перевірка струму', name: 'Vector 2207 / 1750KV', l1: '6S · кріплення 16 × 16 мм · вал 5 мм', l2: 'Піковий струм 48 А на мотор · сумарно 192 А у прикладі', price: '$79.60', qty: '×4', state: 'warn', img: 'partMotor' },
  { cat: 'ESC', name: 'Pulse 55A / 4-in-1', l1: '3–6S · 55 А на канал', l2: 'Кріплення 30.5 × 30.5 мм · розпіновку не перевірено', price: '$64.90', qty: '×1', state: 'open', img: 'partEsc' },
  { cat: 'Польотний контролер', name: 'Nexus F7', l1: '3–6S · процесор F7 · кріплення 30.5 × 30.5 мм', l2: 'Немає схеми шлейфа ESC і даних про цільову плату прошивки', price: '$54.90', qty: '×1', state: 'open', img: 'partFc' },
  { cat: 'Пропелери', name: 'Triad 5.1 × 4.3 × 3', l1: 'Діаметр 5.1″ · три лопаті · посадковий отвір 5 мм', l2: 'Комплект із 4 шт. · 2 CW / 2 CCW', price: '$3.49', qty: '×4', state: 'ok', img: 'partProp' },
  { cat: 'Акумулятор', marker: '/ перевірка струму', name: 'Volt 6S / 1300mAh', l1: '22.2 В номінальна · 25.2 В повна · заявлено 100C', l2: '1.3 А·год × 100C = 130 А — оцінка за маркуванням', price: '$52.90', qty: '×1', state: 'warn', img: 'partBattery' },
];

const Ok = ({ img, title, line, detail }: { img: string; title: string; line: string; detail: string }) => (
  <div className="check-card">
    <Img id={img} className="check-card__img" label="схема" />
    <Icon name="circleCheck" className="ic-ok" />
    <div className="check-card__body">
      <div className="check-card__head"><b>{title}</b><span className="t-ok">Пройдено</span></div>
      <p className="muted">{line}</p>
      <p className="muted">{detail}</p>
    </div>
  </div>
);

const alts: { icon: IconName; purpose: string; title: string; spec: string; text: string; price: string; action: string; img: string; open?: boolean }[] = [
  { icon: 'rotate3d', purpose: 'Зменште навантаження', title: 'Triad 5.0 × 3.5 × 3', spec: 'Діаметр 5.0″ · менший крок · отвір 5 мм', text: 'Менший крок може знизити струм, але це не підтверджено. Звірте виміряні тягу й струм із цим мотором на 6S.', price: '$3.49 / комплект', action: 'Порівняти пропелери', img: 'altProp' },
  { icon: 'batteryCharging', purpose: 'Перевірте ємність акумулятора', title: 'Volt 6S / 1800mAh', spec: 'Номінальна напруга 22.2 В · заявлено 100C · оцінка 180 А', text: 'Оцінка струму все ще нижча за 192 А. Звірте виміряну струмовіддачу, вагу, розміри та кріплення.', price: '$67.90 / акумулятор', action: 'Порівняти акумулятори', img: 'altBattery' },
  { icon: 'bookOpen', purpose: 'Уточніть відсутні дані', title: 'Перевірте проводку й прошивку', spec: 'Nexus F7 ↔ Pulse 55A / 4-in-1', text: 'За схемами обох плат звірте живлення, землю, сигнали й прошивку до підключення.', price: 'Документація', action: 'Список перевірок', img: 'altWiring', open: true },
];

export default function Checker() {
  return (
    <div className="page page--checker">
      <Link to="/catalog" className="backlink"><Icon name="arrowLeft" /> Назад до каталогу</Link>

      <div className="status-hero">
        <h2>1 попередження · 1 незавершена перевірка</h2>
        <p className="muted">Додано всі шість категорій компонентів. Перевірте допустимий струм, підключення FC–ESC і прошивку.</p>
      </div>
      <h1 className="h-checker">Перевірте сумісність деталей</h1>
      <p className="muted">Звірте кріплення, напругу, пропелери й проводку перед складанням.</p>
      <div className="notice"><Icon name="info" /><span className="muted">Демонстраційні товари, ціни й результати; обладнання не перевірялося. Керування неактивне. Звіряйте дані виробника.</span></div>

      <div className="toolbar-box">
        <b>BENCH_01 / 5-дюймовий фристайл</b>
        <div><button className="link-btn" disabled>Перейменувати збірку</button><button className="link-btn" disabled>Скинути приклад</button></div>
      </div>

      <div className="workspace">
        <section className="panel">
          <div className="panel__head"><h3>Обрані компоненти</h3><p className="muted">Приклад деталей і цін · USD</p></div>
          {parts.map((p) => (
            <div key={p.name} className={`prow prow--${p.state}`}>
              <Img id={p.img} className="prow__img" label="фото" />
              <div className="prow__info">
                <div><span className="muted">{p.cat}</span>{p.marker && <span className="muted prow__marker">{p.marker}</span>}</div>
                <b>{p.name}</b>
                <span className="muted">{p.l1}</span>
                <span className="muted">{p.l2}</span>
              </div>
              <div className="prow__price"><span>{p.price}</span><span className="muted">{p.qty} <Icon name="chevronDown" size={11} /></span></div>
              <button className={`btn btn--sm ${p.state === 'warn' ? 'btn--primary' : 'btn--secondary'} ${p.state === 'open' ? 'btn--info' : ''}`} disabled>
                Замінити <Icon name="repeat2" />
              </button>
            </div>
          ))}
          <div className="summary">
            <div className="summary__metrics">
              <div><span className="muted">Підсумок збірки</span><span className="muted">5-дюймовий фристайл / 6S / 12 окремих деталей</span></div>
              <div className="summary__total"><span className="muted">Вартість деталей у прикладі</span><strong>$314.79</strong></div>
            </div>
            <div className="summary__actions">
              <span className="muted">Без приймача, відеосистеми, проводки й кріплень. Доставка та податки не включені.</span>
              <Link to="/catalog" className="btn btn--primary btn--sm">Обрати ще деталі <Icon name="plus" /></Link>
            </div>
          </div>
        </section>

        <section className="results-col">
          <div className="panel panel--pad">
            <div className="rhead"><h3>Перевірка характеристик</h3><Icon name="sliders" /></div>
            <div className="legend">
              <span className="legend__ok">3 перевірки пройдено</span>
              <span className="legend__warn muted">1 попередження</span>
              <span className="legend__open">1 незавершена перевірка</span>
            </div>
            <p className="muted">Попередня оцінка, не допуск до польоту. Уточніть струм і підключення.</p>
          </div>

          <Ok img="checkMount" title="Схема кріплення" line="Stack 30.5 × 30.5 мм / мотори 16 × 16 мм" detail="Кріплення збігаються за даними прикладу. Перевірте довжину гвинтів і висоту Stack." />
          <Ok img="checkVoltage" title="Діапазон напруги" line="Акумулятор 6S / 25.2 В за повного заряду" detail="Мотори, ESC і FC підтримують 6S. Периферія, проводка й захист від стрибків напруги не перевірені." />

          <div className="warn-card">
            <Img id="checkCurrent" className="warn-card__img" label="схема струму" />
            <div className="warn-card__head"><span><Icon name="triangleAlert" className="ic-warn" /><b>Струмове навантаження</b></span><span className="t-warn">Попередження</span></div>
            <div className="metrics">
              <div><strong>192 А</strong><span className="muted2">4 × 48 А — піковий струм моторів</span><i className="bar bar--a" /></div>
              <div><strong>130 А</strong><span className="muted2">1.3 А·год × 100C — за маркуванням</span><i className="bar bar--b" /></div>
            </div>
            <p className="muted2">192 А — на 62 А понад оцінку акумулятора. C-рейтинг не є виміряною струмовіддачею; 55 А ESC — ліміт на канал, не акумулятора.</p>
            <p className="t-warn"><b>Нижче — пропелери з меншим навантаженням та інший акумулятор ↓</b></p>
          </div>

          <Ok img="checkProp" title="Зазор пропелерів" line="Пропелер 5.1″ / межа рами — 5.2″" detail="Діаметр у межах допуску прикладу. Перевірте посадку на вал і реальний зазор." />

          <div className="open-card">
            <Img id="checkWiring" className="warn-card__img" label="схема підключення" />
            <div className="warn-card__head"><span><Icon name="circleHelp" className="ic-info" /><b className="t-info">FC ↔ ESC: підключення й прошивка</b></span><b className="t-info">Не завершено</b></div>
            <p className="t-info">Невідомі розпіновка, полярність і цільова плата прошивки. Напруга та кріплення не гарантують сумісності.</p>
            <p className="t-info"><b>Звірте розпіновки й цільові плати прошивки у виробників ↗</b></p>
          </div>
        </section>
      </div>

      <section className="alts">
        <div className="alts__head">
          <h2 className="t-accent">Усуньте проблеми сумісності</h2>
          <p className="muted">Приклади, не перевірені заміни. Повторіть перевірку після кожної зміни.</p>
        </div>
        <div className="alts__grid">
          {alts.map((a) => (
            <article key={a.title} className={`alt${a.open ? ' alt--open' : ''}`}>
              <Img id={a.img} className="alt__img" label="фото" />
              <div className="alt__label t-accent"><Icon name={a.icon} />{a.purpose}</div>
              <h4>{a.title}</h4>
              <p className="muted">{a.spec}</p>
              <p className="muted">{a.text}</p>
              <div className="alt__foot">
                <span className="muted">{a.price}</span>
                <button className={`btn btn--sm ${a.open ? 'btn--secondary btn--info' : 'btn--primary'}`} disabled>{a.action} <Icon name="arrowUpRight" size={14} /></button>
              </div>
            </article>
          ))}
        </div>
      </section>

      <div className="reminder">
        <Icon name="ruler" />
        <div><b>Перед складанням</b><p className="muted">Звірте допуски, проводку, прошивку й виміряний струм із даними виробника. Для стендових тестів зніміть пропелери.</p></div>
      </div>
    </div>
  );
}
