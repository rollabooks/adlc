# Capitolo 10 — HALT Triggers: il freno di emergenza

Ci sono zone in ogni progetto che non dovresti mai modificare di impulso. Lo schema del database. Il codice di autenticazione. I file di configurazione con le credenziali. Le pipeline CI/CD. Sono le zone dove un errore ha effetti che si propagano lontano e che possono essere difficili o impossibili da annullare.

Gli HALT trigger sono il meccanismo con cui AI-DLC presidia queste zone. Definiscono pattern di path che, quando vengono toccati dall'agente, attivano un blocco automatico e richiedono una conferma esplicita prima di procedere.

Non è un sistema di permessi — l'agente può comunque modificare quei file, con la tua autorizzazione. È un sistema di consapevolezza: garantisce che nessuna modifica ad alto impatto avvenga per inerzia o per errore.

---

## 10.1 Il file `halt-triggers.yaml`

Il file si trova in `.ai-dlc/halt-triggers.yaml` ed è incluso nel framework. Non devi crearlo — è già lì dopo `init`.

```yaml
version: 1

triggers:
  - id: schema
    patterns:
      - "**/migrations/**"
      - "**/schema/**"
      - "**/*.sql"
      - "**/prisma/schema.prisma"
      - "**/alembic/**"
      - "**/db/changesets/**"
    reason: Database schema migrations and structural changes
    risk: HIGH

  - id: auth
    patterns:
      - "**/auth/**"
      - "**/authn/**"
      - "**/authorization/**"
      - "**/middleware/auth*"
      - "**/oauth/**"
      - "**/sso/**"
    reason: Authentication and authorization logic
    risk: HIGH+

  - id: secrets
    patterns:
      - "**/.env*"
      - "**/secrets/**"
      - "**/*.pem"
      - "**/*.key"
      - "**/credentials.*"
    reason: Secret material and credentials
    risk: HIGH+

  - id: infra
    patterns:
      - "**/terraform/**"
      - "**/k8s/**"
      - "**/helm/**"
      - "**/Dockerfile*"
      - "**/docker-compose*.yml"
      - "**/*.tf"
      - "**/cloudformation/**"
    reason: Production infrastructure definitions
    risk: HIGH

  - id: cicd
    patterns:
      - ".github/workflows/**"
      - "**/.gitlab-ci.yml"
      - "**/Jenkinsfile"
      - "**/.circleci/**"
      - "**/azure-pipelines*.yml"
    reason: Build and deployment pipelines
    risk: HIGH

  - id: framework
    patterns:
      - ".ai-dlc/modules/**"
      - "AGENTS.md"
      - "CLAUDE.md"
      - "GEMINI.md"
      - "OPENCLAW.md"
      - ".github/copilot-instructions.md"
    reason: AI-DLC framework files and startup contracts
    risk: HIGH
```

Sei trigger predefiniti che coprono le zone più comunemente sensibili di qualsiasi progetto software.

---

## 10.2 Come funziona il trigger in una sessione

Quando l'agente determina che una modifica toccherà un path che corrisponde a un pattern, si ferma prima di fare qualsiasi cosa:

```
⚠ HALT — trigger: auth (HIGH+)

File: src/middleware/auth.ts
Pattern match: **/middleware/auth*
Reason: Authentication and authorization logic

Proposta: estrarre la logica di verifica JWT in una funzione separata
`verifyToken(token: string): Promise<JWTPayload>` per rendere
il middleware testabile in isolamento.

Rischi:
- La funzione estratta deve mantenere lo stesso comportamento di
  lancio dell'eccezione (`JwtVerifyError`) su token non valido
- I test di integrazione esistenti coprono il path positivo;
  aggiungere test per token scaduto e token con audience sbagliata

Minimum model level: 6 (risk floor auth)

Conferma esplicita richiesta. Procedi?
```

Il flusso è sempre lo stesso: path rilevato → HALT → presentazione del piano con rischi → attesa di conferma esplicita.

---

## 10.3 Override di progetto

I trigger predefiniti sono pensati per la maggior parte dei progetti. Ma ogni progetto ha le sue zone sensibili. TaskFlow API, per esempio, ha un modulo di billing che non è coperto dai trigger predefiniti ma che il team vuole proteggere allo stesso modo.

Gli override di progetto vivono in `.ai-dlc/project/halt-triggers.yaml` — questo file non esiste di default, lo crei quando ne hai bisogno.

```yaml
version: 1

triggers:
  - id: billing
    patterns:
      - "**/billing/**"
      - "**/payments/**"
      - "**/invoices/**"
      - "**/stripe/**"
    reason: Payment and billing logic - financial impact
    risk: HIGH+

  - id: reports
    patterns:
      - "**/reports/generators/**"
    reason: Report generators produce data for customers - accuracy critical
    risk: HIGH
```

Il file di progetto si sovrappone a quello del framework: i trigger che definisci si aggiungono a quelli predefiniti. Non sostituiscono — estendono.

---

## 10.4 Rimuovere un trigger predefinito

A volte un trigger predefinito è troppo aggressivo per il tuo progetto. Per esempio, se stai lavorando intensamente sullo schema del database durante la fase di design iniziale, il trigger `schema` potrebbe rallentare eccessivamente il lavoro.

Puoi disattivarlo nel file di override usando `disable`:

```yaml
version: 1

# Disattiva il trigger schema durante la fase di design intensivo
disable:
  - schema

triggers:
  - id: billing
    patterns:
      - "**/billing/**"
    reason: Payment logic
    risk: HIGH+
```

> **Attenzione:** disattivare un trigger non è una cosa da fare di default. Fallo consapevolmente, per un periodo definito, e riattivalo quando la fase intensiva finisce. Un trigger disattivato è una zona senza rete di sicurezza.

---

## 10.5 Pattern POSIX e come scriverli

I pattern usano la sintassi glob POSIX, la stessa usata da `.gitignore` e dalla maggior parte dei sistemi CI.

| Pattern | Matcha |
|---|---|
| `**/auth/**` | Qualsiasi file in qualsiasi cartella chiamata `auth` |
| `**/middleware/auth*` | File che iniziano con `auth` dentro qualsiasi cartella `middleware` |
| `**/*.sql` | Qualsiasi file `.sql` in qualsiasi punto del progetto |
| `src/db/**` | Qualsiasi file dentro `src/db/` |
| `.github/workflows/**` | Qualsiasi file dentro `.github/workflows/` |

Per testare se un path corrisponde a un pattern prima di aggiungere il trigger, puoi chiedere all'agente:

> "Il path `src/services/billingService.ts` corrisponderebbe al pattern `**/billing/**`?"

L'agente risponde basandosi sulla sintassi glob — è più rapido che testare a mano.

---

## 10.6 Gli HALT trigger non si disattivano con i Modes

È un punto che vale la pena ribadire perché genera confusione: i Modes (LITE, RAPID, FAST) riducono la cerimonia per le operazioni normali, ma non disattivano mai gli HALT trigger.

Anche in Mode FAST — il mode con meno cerimonia — un path che corrisponde a un trigger viene bloccato e richiede conferma. La ragione è semplice: il rischio di un percorso di autenticazione o di uno schema di database non cambia in base a quanto velocemente vuoi lavorare quel giorno.

Se stai lavorando intensivamente in una zona HALT e le conferme ti rallentano, la soluzione giusta non è abbassare il Mode — è disattivare temporaneamente il trigger specifico nel file di override di progetto, consapevolmente.

---

## 10.7 Cosa succede se l'agente sbaglia il rilevamento

Il rilevamento dei trigger è basato sul path che l'agente *intende* modificare, non su quello che effettivamente modifica. Se l'agente ha pianificato di modificare `src/middleware/auth.ts` ma poi produce codice che va in `src/utils/tokenHelper.ts`, il trigger è stato attivato correttamente — il piano toccava un path protetto.

Può capitare che il trigger sia attivato per un path che poi non viene modificato (falso positivo). In quel caso, dopo la conferma, l'agente esegue normalmente. Il falso positivo non è un problema — è meglio un blocco in più che uno in meno.

Se noti che un trigger si attiva sistematicamente per operazioni che non meritano quel livello di attenzione, valuta di aggiustare il pattern nel file di override.

---

## Riepilogo

- Gli HALT trigger definiscono pattern di path che bloccano l'agente e richiedono conferma esplicita prima di qualsiasi modifica.
- I sei trigger predefiniti coprono: schema DB, auth, secrets, infra, CI/CD, framework AI-DLC.
- Gli override di progetto in `.ai-dlc/project/halt-triggers.yaml` estendono (o disattivano) i trigger predefiniti per le esigenze specifiche del progetto.
- I trigger non si disattivano mai con i Modes — sono il livello di sicurezza che rimane costante indipendentemente dalla velocità con cui stai lavorando.
- Un falso positivo (trigger attivato per path poi non modificato) è accettabile e preferibile al contrario.

Chiudiamo la Parte III con il capitolo sui vincoli SEC e PERF: la libreria riusabile di requisiti di sicurezza e performance che l'agente rilega prima di ogni operazione critica.
