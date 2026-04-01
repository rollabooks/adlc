# Specifiche Cover Amazon KDP

## Cover eBook (Kindle)

| Proprietà | Requisito |
|-----------|-----------|
| Formato | JPEG o TIFF |
| Dimensione ideale | 1600 × 2560 px |
| Rapporto | 1:1.6 |
| Dimensione minima | 1000 × 1600 px |
| Dimensione massima | 10000 × 10000 px |
| Peso massimo | 50 MB |
| Spazio colore | RGB (non CMYK), sRGB consigliato |
| DPI | 300 DPI consigliato (non obbligatorio) |
| Contenuto | Solo fronte, niente dorso né retro |

### Note eBook

- Il titolo sulla cover deve corrispondere al titolo nei metadati
- Evitare bordi bianchi stretti (Amazon li aggiunge automaticamente nell'anteprima)
- Il testo deve essere leggibile anche a dimensione miniatura (circa 300px di altezza)

## Cover Cartaceo (KDP Print)

La cover cartacea è un **unico file PDF** che include: retro copertina + dorso + fronte copertina.

| Proprietà | Requisito |
|-----------|-----------|
| Formato | PDF |
| Spazio colore | CMYK consigliato, RGB accettato |
| DPI | 300 DPI obbligatorio |
| Abbondanza (bleed) | 3.2 mm (0.125") per ogni lato |
| Dorso | Calcolato in base al numero di pagine |

### Calcolo dimensioni

La larghezza totale del file PDF si calcola così:

```
larghezza = abbondanza + retro + dorso + fronte + abbondanza
altezza   = abbondanza + altezza trim + abbondanza
```

#### Formati trim comuni

| Formato | Larghezza trim | Altezza trim |
|---------|---------------|--------------|
| 5" × 8" | 127 mm | 203.2 mm |
| 5.25" × 8" | 133.4 mm | 203.2 mm |
| 5.5" × 8.5" | 139.7 mm | 215.9 mm |
| 6" × 9" | 152.4 mm | 228.6 mm |
| 7" × 10" | 177.8 mm | 254 mm |
| 8.5" × 11" | 215.9 mm | 279.4 mm |

#### Calcolo dorso (spine)

- **Carta bianca**: spessore dorso = numero pagine × 0.0572 mm
- **Carta crema**: spessore dorso = numero pagine × 0.0635 mm

Esempio: libro 300 pagine su carta bianca → dorso = 300 × 0.0572 = 17.16 mm

#### Esempio dimensioni complete

Libro 6" × 9", 300 pagine, carta bianca:

```
abbondanza = 3.2 mm
fronte/retro = 152.4 mm
dorso = 17.16 mm

larghezza PDF = 3.2 + 152.4 + 17.16 + 152.4 + 3.2 = 328.36 mm
altezza PDF   = 3.2 + 228.6 + 3.2 = 235.0 mm
```

### Zone sicure (cartaceo)

- **Testo e elementi importanti**: almeno 6.4 mm (0.25") dal bordo di taglio
- **Dorso**: il testo sul dorso è permesso solo se il libro ha ≥ 79 pagine (carta crema) o ≥ 101 pagine (carta bianca)

## Struttura cartella

```
covers/
  specs.md              ← Questo file
  assets/               ← Elementi grafici condivisi tra lingue
    logo.png            ← Logo autore/editore
    background.png      ← Sfondo, pattern, texture
  templates/            ← Template sorgente editabili
    ebook-template.psd  ← Template Photoshop eBook
    print-template.ai   ← Template Illustrator cartaceo
  <lang>/               ← Cover finali per lingua
    ebook-cover.png     ← Sorgente eBook (1600×2560 px)
    print-cover.pdf     ← Cover completa cartaceo
```

## Integrazione con il build

Il build EPUB (`build-ebook.ps1`) cerca automaticamente:
1. `covers/<lang>/ebook-cover.png`
2. Converte in JPEG ottimizzato per Kindle → `ebook/cover.jpg`
3. Lo include nell'EPUB come cover-image

Il PDF LaTeX gestisce la cover separatamente (file KDP Print è esterno al PDF del blocco libro).
