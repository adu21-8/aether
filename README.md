# Aether

An offline trading journal for MetaTrader 5. Import your statement, tag what you
did, and hold yourself to the risk rules you actually set.

Everything lives in your browser. There is no account, no server, and no network
call — the app works with the wifi off, and your trading history never leaves
your device.

This is a passion project of mine because ever since i started trading i was always
looking for a journal or a dashboard where i could track my progress put in my rules
do all that but they were never free or if they were then they were sketchy af

The parser is fully developed by Claude Opus 4.8 and Fable 5, I made the UI with little
bug fixes using claude.

If you find any bugs please lmk at morayyan.abbasx@gmail.com ALSO theres a website version
where no download is needed, everything is still stored inside your browser so same security
the URL is https://aether-trade.netlify.app/

## What it does

- **Import** an MT5 *Trade History Report* (`.html`, the file MT5 exports from
  Toolbox → History → right-click → Report). Handles UTF-16 exports.
- **Rule engine** — you define your risk model (per-trade cap, daily and weekly
  loss caps, profit scaling, forced break after a stopout). Every trade is
  judged against it and flagged when it breaks one. A status banner tells you
  whether you're clear to trade, how much loss room is left, and counts down
  the cooldown after a stopout.
- **Dashboard** — today, this week and this month at a glance, plus an equity
  curve that shows what following your rules is worth against what breaking
  them has cost.
- **Insights** — R-multiple distribution, per-instrument and per-setup
  performance, rules followed vs broken, revenge trades, drawdown episodes,
  a weekday × hour heatmap and day-quality stats.
- **Trade log** — tag setups, emotion, screenshots and notes per trade.
- **Plan & Tools** — a position-size calculator, pre-trade plans you can link
  to the trade that resulted, and a watchlist.
- **Rules & Levels** — edit your risk rules and keep key levels per instrument.
- **Daily journal** — write a reflection each day; simple markdown supported.
- **Checklist** — live status against your caps, plus a pre-trade check you
  tick through before you enter.
- **Works on your phone** — a bottom tab bar, a trade list built for small
  screens, and a trade detail sheet you can swipe away.
- **Sample data** — no statement handy? Load a fabricated account (six weeks of
  trades, a rule-breaking day, plans and a journal entry) and explore every
  page. One click removes it, and importing a real statement clears it too.
- **CSV export** — the full enriched trade log (R, session, setups, emotion,
  violations, notes) for your own spreadsheets.

## Getting started

It's a static site — no build step.

```bash
python3 -m http.server 8655
```

Then open `http://localhost:8655`. To deploy, upload the folder to any static
host.

  **OR**

Use the web app version at : https://aether-trade.netlify.app/

First run: go to **Rules & Levels** and set your caps and setups. They default
to a small-account model; they are meant to be changed. Then import your
statement from **Data & Settings**.

Or grab the latest download from
[Releases](https://github.com/adu21-8/aether/releases), unzip it, and serve the
folder the same way.

## Notes

- **Your data is only in this browser.** Clearing site data erases it. Use
  *Export full backup* from **Data & Settings** regularly — Aether reminds you every
  few imports if you haven't.
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
| `deploy.sh` | Deploys the site to Netlify |

## Not included

No AI coaching, no cloud sync, no accounts. Aether records what you did and
measures it against your own rules — it does not tell you what to trade.
