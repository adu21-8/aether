# Aether

An offline trading journal for MetaTrader 5. Import your statement, tag what you
did, and hold yourself to the risk rules you actually set.

Everything lives in your browser. There is no account, no server, and no network
call — the app works with the wifi off, and your trading history never leaves
your device.

## What it does

- **Import** an MT5 *Trade History Report* (`.html`, the file MT5 exports from
  Toolbox → History → right-click → Report). Handles UTF-16 exports.
- **Rule engine** — you define your risk model (per-trade cap, daily and weekly
  loss caps, profit scaling, forced break after a stopout). Every trade is
  judged against it and flagged when it breaks one.
- **Analytics** — equity curve, discipline-adjusted curve (what your account
  would look like if every rule-breaking trade were skipped), R-multiple
  distribution, weekday × hour heatmap, drawdown episodes, per-setup and
  per-emotion performance, day-quality stats.
- **Trade log** — tag setups, emotion, screenshots and notes per trade.
- **Plan & tools** — pre-trade plans you can link to the trade that resulted,
  a watchlist, position-size calculator, and key levels per instrument.
- **Daily journal** — write a reflection each day; simple markdown supported.
- **Checklist** — live pooled status against your caps, plus a pre-trade check.

## Getting started

It's a static site — no build step.

```bash
python3 -m http.server 8655
```

Then open `http://localhost:8655`. To deploy, upload the folder to any static
host.

First run: go to **Import → Your trading rules** and set your caps and setups.
They default to a small-account model; they are meant to be changed. Then import
your statement from the **Import** tab.

## Notes

- **Your data is only in this browser.** Clearing site data erases it. Use
  *Export full backup* from the Import tab regularly.
- Instruments are discovered from what you import — you don't configure them,
  though you can list extras up front before your first import.
- The account currency is read from your statement, so amounts display in the
  currency you actually trade.
- Installable as a PWA; the service worker caches the shell for offline use.

## Files

| File | Purpose |
|---|---|
| `index.html` | The entire app — markup, styles, and logic in one file |
| `sw.js` | Service worker, caches the app shell for offline use |
| `manifest.webmanifest` | PWA metadata |
| `icon*.png`, `icon.svg` | App icons |

## Not included

No AI coaching, no cloud sync, no accounts. Aether records what you did and
measures it against your own rules — it does not tell you what to trade.
