import { useEffect, useMemo, useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { api, formatPrice, type Check, type CheckResponse, type Status, type Suggestion } from '../api';
import { Icon, type IconName } from '../icons';
import Img from '../components/Img';
import ProductThumb from '../components/ProductThumb';
import { useAuth } from '../state/auth';
import { useBuild } from '../state/build';

const SLOTS: [string, string][] = [
  ['frames', 'Рама'], ['motors', 'Мотори'], ['esc', 'ESC'], ['flight-controllers', 'Польотний контролер'],
  ['props', 'Пропелери'], ['batteries', 'Акумулятор'],
];
const CHECK_IMG: Record<string, string> = { mount: 'checkMount', voltage: 'checkVoltage', current: 'checkCurrent', prop: 'checkProp', wiring: 'checkWiring', completeness: 'checkMount' };
const ALT_IMG: Record<string, string> = { props: 'altProp', batteries: 'altBattery', wiring: 'altWiring' };
const ALT_ICON: Record<string, IconName> = { props: 'rotate3d', batteries: 'batteryCharging', wiring: 'bookOpen' };
const ROW_CLASS: Partial<Record<Status, string>> = { warn: 'prow--warn', fail: 'prow--fail', open: 'prow--open' };
const money = (c: number) => `${c < 0 ? '−' : '+'}${formatPrice(Math.abs(c))}`;

function StatusCard({ c }: { c: Check }) {
  const img = <Img id={CHECK_IMG[c.id]} className={c.status === 'ok' ? 'check-card__img' : 'warn-card__img'} label="схема" />;
  if (c.status === 'ok') {
    return (
      <div className="check-card">
        {img}<Icon name="circleCheck" className="ic-ok" />
        <div className="check-card__body">
          <div className="check-card__head"><b>{c.title}</b><span className="t-ok">Пройдено</span></div>
          <p className="muted">{c.line}</p><p className="muted">{c.detail}</p>
        </div>
      </div>
    );
  }
  if (c.status === 'idle') {
    return (
      <div className="idle-card">
        <div className="check-card__head"><b className="muted">{c.title}</b><span className="muted">Очікує деталі</span></div>
        <p className="muted">{c.detail}</p>
      </div>
    );
  }
  const kind = c.status === 'open' ? 'open' : c.status === 'fail' ? 'fail' : 'warn';
  const label = { open: 'Не завершено', fail: 'Несумісно', warn: 'Попередження' }[kind];
  const cls = { open: 't-info', fail: 't-fail', warn: 't-warn' }[kind];
  return (
    <div className={`${kind}-card`}>
      {img}
      <div className="warn-card__head">
        <span><Icon name={kind === 'open' ? 'circleHelp' : 'triangleAlert'} className={kind === 'open' ? 'ic-info' : kind === 'fail' ? 'ic-fail' : 'ic-warn'} /><b className={kind === 'open' ? 't-info' : undefined}>{c.title}</b></span>
        <b className={cls}>{label}</b>
      </div>
      {c.metrics && (
        <div className="metrics">
          {c.metrics.map((m, i) => (
            <div key={i}><strong>{m.value}</strong><span className="muted2">{m.label}</span><i className={`bar ${i === 0 ? 'bar--a' : 'bar--b'}`} style={{ width: `${Math.max(8, m.ratio * 100)}%` }} /></div>
          ))}
        </div>
      )}
      <p className={kind === 'open' ? 't-info' : 'muted2'}>{c.detail}</p>
    </div>
  );
}

export default function Checker() {
  const { items, name, serverId, setQuantity, remove, clear, rename, setServerId, add } = useBuild();
  const { user } = useAuth();
  const navigate = useNavigate();
  const [data, setData] = useState<CheckResponse | null>(null);
  const [error, setError] = useState('');
  const [msg, setMsg] = useState('');
  const [editing, setEditing] = useState(false);
  const [showList, setShowList] = useState(false);

  const payload = useMemo(() => items.map((i) => ({ productId: i.product.id, quantity: i.quantity })), [items]);
  const key = JSON.stringify(payload);
  useEffect(() => {
    let alive = true;
    const t = setTimeout(() => {
      api.check(payload).then((r) => { if (alive) { setData(r); setError(''); } }).catch((e) => alive && setError(e.message));
    }, 150);
    return () => { alive = false; clearTimeout(t); };
  }, [key]); // eslint-disable-line react-hooks/exhaustive-deps

  const report = data?.report;
  const byCat = (slug: string) => items.find((i) => i.product.categorySlug === slug);
  const aio = byCat('flight-controllers')?.product.specs.aio === true;
  const slots = SLOTS.filter(([s]) => !(s === 'esc' && aio));
  const problems = report?.checks.filter((c) => c.status === 'fail' || c.status === 'warn') ?? [];
  const rest = report?.checks.filter((c) => c.status !== 'fail' && c.status !== 'warn') ?? [];
  const ordered = report ? [...report.checks.filter((c) => c.status === 'fail'), ...report.checks.filter((c) => c.status === 'warn'), ...rest] : [];
  void problems;

  const save = async () => {
    if (!user) { navigate('/login?next=/checker'); return; }
    try {
      let id = serverId;
      if (!id) { id = (await api.createBuild(name)).id; setServerId(id); } else await api.renameBuild(id, name);
      await api.saveBuildItems(id, payload);
      setMsg('Збірку збережено в «Мої збірки»');
    } catch (e) { setMsg((e as Error).message); }
  };
  const apply = async (s: Suggestion) => {
    if (!s.product) { setShowList((v) => !v); return; }
    const r = await api.hydrate([{ productId: s.product.id, quantity: 1 }]);
    if (r.items[0]) add(r.items[0].product);
  };

  return (
    <div className="page page--checker">
      <Link to="/catalog" className="backlink"><Icon name="arrowLeft" /> Назад до каталогу</Link>

      <div className="status-hero">
        <h2>{report?.headline ?? 'Перевірка збірки…'}</h2>
        <p className="muted">{report?.subline ?? ''}</p>
      </div>
      <h1 className="h-checker">Перевірте сумісність деталей</h1>
      <p className="muted">Звірте кріплення, напругу, пропелери й проводку перед складанням.</p>
      <div className="notice"><Icon name="info" /><span className="muted">Попередня оцінка за даними каталогу, а не допуск до польоту. Деталі з позначкою «орієнтовні дані» звіряйте з виробником; ціни — орієнтовні, USD.</span></div>
      {error && <p className="error">{error}</p>}

      <div className="toolbar-box">
        {editing ? (
          <input className="name-input" autoFocus defaultValue={name} maxLength={80} aria-label="Назва збірки"
            onBlur={(e) => { rename(e.currentTarget.value.trim() || name); setEditing(false); }}
            onKeyDown={(e) => e.key === 'Enter' && e.currentTarget.blur()} />
        ) : <b>{name}</b>}
        <div>
          <button className="link-btn" onClick={() => setEditing(true)}>Перейменувати збірку</button>
          <button className="link-btn" onClick={save} disabled={!items.length}>{user ? 'Зберегти збірку' : 'Увійти, щоб зберегти'}</button>
          <button className="link-btn" onClick={() => { clear(); setMsg(''); }} disabled={!items.length}>Очистити збірку</button>
        </div>
      </div>
      {msg && <p className="muted save-msg" role="status">{msg}</p>}

      <div className="workspace">
        <section className="panel">
          <div className="panel__head"><h3>Обрані компоненти</h3><p className="muted">Ціни · USD</p></div>
          {slots.map(([slug, label]) => {
            const it = byCat(slug);
            if (!it) {
              return (
                <div key={slug} className="prow prow--empty">
                  <div className="prow__img prow__img--empty"><Icon name="plus" /></div>
                  <div className="prow__info"><span className="muted">{label}</span><b className="muted">Не обрано</b></div>
                  <span />
                  <Link to={`/catalog?category=${slug}`} className="btn btn--sm btn--secondary">Обрати <Icon name="plus" /></Link>
                </div>
              );
            }
            const st = report?.rowStatus[slug] ?? 'ok';
            const firstIssue = report?.checks.find((c) => c.slots.includes(slug) && (c.status === 'warn' || c.status === 'fail' || c.status === 'open'));
            const p = it.product;
            return (
              <div key={slug} className={`prow ${ROW_CLASS[st] ?? ''}`}>
                <ProductThumb p={p} className="prow__img" />
                <div className="prow__info">
                  <div><span className="muted">{label}</span>{firstIssue && <span className="muted prow__marker">/ {firstIssue.title.toLowerCase()}</span>}{!p.verified && <span className="tag-approx">орієнтовні дані</span>}</div>
                  <b>{p.name}</b>
                  {p.cardSpecs.map((s) => <span key={s.label} className="muted">{s.label}: {s.value}</span>)}
                </div>
                <div className="prow__price">
                  <span>{formatPrice(p.priceCents * it.quantity)}</span>
                  <label className="muted qty">×<select value={it.quantity} onChange={(e) => setQuantity(p.id, Number(e.target.value))} aria-label={`Кількість: ${p.name}`}>
                    {Array.from({ length: 8 }, (_, i) => i + 1).map((n) => <option key={n} value={n}>{n}</option>)}
                  </select></label>
                </div>
                <div className="prow__actions">
                  <Link to={`/catalog?category=${slug}&replace=1`} className={`btn btn--sm ${st === 'warn' || st === 'fail' ? 'btn--primary' : 'btn--secondary'} ${st === 'open' ? 'btn--info' : ''}`}>
                    Замінити <Icon name="repeat2" />
                  </Link>
                  <button className="link-btn" onClick={() => remove(p.id)} aria-label={`Прибрати: ${p.name}`}>Прибрати</button>
                </div>
              </div>
            );
          })}
          <div className="summary">
            <div className="summary__metrics">
              <div><span className="muted">Підсумок збірки</span><span className="muted">{report ? `${report.unitCount} окремих деталей · вага деталей ≈ ${report.weightG} г` : '—'}</span></div>
              <div className="summary__total"><span className="muted">Вартість деталей</span><strong>{formatPrice(report?.totalCents ?? 0)}</strong></div>
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
              <span className="legend__ok">{report?.counts.ok ?? 0} перевірок пройдено</span>
              {!!report?.counts.fail && <span className="legend__fail">{report.counts.fail} несумісн.</span>}
              <span className="legend__warn muted">{report?.counts.warn ?? 0} попереджень</span>
              <span className="legend__open">{report?.counts.open ?? 0} незавершених</span>
            </div>
            <p className="muted">Попередня оцінка, не допуск до польоту. Уточніть струм і підключення.</p>
          </div>
          {!items.length && (
            <div className="idle-card">
              <p className="muted">Збірка порожня. <Link to="/catalog" className="t-accent"><b>Оберіть деталі в каталозі</b></Link> або <Link to="/drones" className="t-accent"><b>почніть із готової збірки</b></Link>.</p>
            </div>
          )}
          {ordered.map((c) => <StatusCard key={c.id} c={c} />)}
        </section>
      </div>

      {!!data?.suggestions.length && (
        <section className="alts">
          <div className="alts__head">
            <h2 className="t-accent">Усуньте проблеми сумісності</h2>
            <p className="muted">Заміни підібрано з каталогу: кожна покращує перевірку й не створює нових помилок за даними каталогу. Повторіть перевірку після кожної зміни.</p>
          </div>
          <div className="alts__grid">
            {data.suggestions.map((s) => (
              <article key={s.slot} className={`alt${s.slot === 'wiring' ? ' alt--open' : ''}`}>
                <Img id={ALT_IMG[s.slot] ?? '__none'} className="alt__img" label="фото" />
                <div className="alt__label t-accent"><Icon name={ALT_ICON[s.slot] ?? 'sliders'} />{s.purpose}</div>
                <h4>{s.product?.name ?? 'Перевірте проводку й прошивку'}</h4>
                <p className="muted">{s.spec}</p>
                <p className="muted">{s.text}</p>
                <div className="alt__foot">
                  <span className="muted">{s.product ? `${money(s.priceDeltaCents)} до збірки` : 'Документація'}</span>
                  <button className={`btn btn--sm ${s.slot === 'wiring' ? 'btn--secondary btn--info' : 'btn--primary'}`} onClick={() => apply(s)}>{s.action} <Icon name="arrowUpRight" size={14} /></button>
                </div>
              </article>
            ))}
          </div>
          {showList && (
            <ol className="checklist muted">{data.wiringChecklist.map((t) => <li key={t}>{t}</li>)}</ol>
          )}
        </section>
      )}

      <div className="reminder">
        <Icon name="ruler" />
        <div><b>Перед складанням</b><p className="muted">Звірте допуски, проводку, прошивку й виміряний струм із даними виробника. Для стендових тестів зніміть пропелери.</p></div>
      </div>
    </div>
  );
}
