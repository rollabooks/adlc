## Lezioni Apprese
- Specificare l'ordine di implementazione (storage → logic → UI → main → tests)
  migliora la coerenza del codice generato
- I test con tmp_path devono sempre creare un'istanza fresh di Storage
- argparse con subparsers richiede set_defaults(func=...) per il routing
- L'IA tende a dimenticare la conferma y/N sulla cancellazione: metterla nei vincoli