import type { Product } from '../api';
import { categoryImage } from '../assets/images';
import Img from './Img';

/** Фото деталі; якщо його немає — зображення категорії з макета (або плейсхолдер). */
export default function ProductThumb({ p, className = '' }: { p: Pick<Product, 'imageUrl' | 'name' | 'categorySlug'>; className?: string }) {
  if (p.imageUrl) return <img src={p.imageUrl} alt={p.name} className={`img ${className}`} loading="lazy" />;
  return <Img id={categoryImage[p.categorySlug] ?? '__none'} alt={p.name} className={className} label="фото" />;
}
