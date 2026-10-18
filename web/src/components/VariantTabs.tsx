import { availableVariants, variantLabels, type Variant } from '@mpi-informatique/exercices-core';

export function VariantTabs({ variant, documentType, onChange }: { variant: Variant; documentType?: string; onChange: (variant: Variant) => void }) {
  const variants = availableVariants(documentType);
  const labels = variantLabels(documentType);
  return <div role="tablist" aria-label="Version du document" className="variant-tabs">
    {variants.map(value => <button key={value} id={`variant-${value}`} className={variant === value ? 'active' : ''} role="tab" aria-selected={variant === value} aria-controls="pdf-preview" tabIndex={variant === value ? 0 : -1} onClick={() => onChange(value)} onKeyDown={event => {
      if (!['ArrowLeft', 'ArrowRight', 'Home', 'End'].includes(event.key)) return;
      event.preventDefault();
      const next = event.key === 'Home' ? variants[0]! : event.key === 'End' ? variants.at(-1)! : variants[(variants.indexOf(variant) + (event.key === 'ArrowLeft' ? -1 : 1) + variants.length) % variants.length]!;
      onChange(next);
      (event.currentTarget.parentElement?.children[variants.indexOf(next)] as HTMLButtonElement)?.focus();
    }}>{labels[value]}</button>)}
  </div>;
}
