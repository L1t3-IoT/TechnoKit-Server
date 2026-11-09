/**
 * Усі фото макета. Поки значення null — показується плейсхолдер.
 * Коли будуть файли: покладіть їх у frontend/public/images/ і вкажіть шлях, напр.:
 *   drone: '/images/drone-exploded.webp'
 */
export const images: Record<string, string | null> = {
  drone: null,            // Головна: розібраний дрон (500×384)
  // Навчання (381×180)
  lesson1: null, lesson2: null, lesson3: null, lesson4: null, lesson5: null, lesson6: null,
  // Перевірка збірки: мініатюри деталей (88×68)
  partFrame: null, partMotor: null, partEsc: null, partFc: null, partProp: null, partBattery: null,
  // Перевірка збірки: ілюстрації перевірок
  checkMount: null, checkVoltage: null, checkProp: null, checkCurrent: null, checkWiring: null,
  // Перевірка збірки: картки «Усуньте проблеми» (391×130)
  altProp: null, altBattery: null, altWiring: null,
};
