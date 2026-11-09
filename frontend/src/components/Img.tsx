import { images } from '../assets/images';

/** Фото з макета або плейсхолдер, якщо файл ще не додано. */
export default function Img({ id, alt = '', className = '', label }: { id: string; alt?: string; className?: string; label?: string }) {
  const src = images[id];
  if (src) return <img src={src} alt={alt} className={`img ${className}`} loading="lazy" />;
  return <div className={`img ph ${className}`} role="img" aria-label={alt || label || 'Зображення'}><span>{label ?? 'фото'}</span></div>;
}
