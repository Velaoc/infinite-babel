<!-- foundation:identity -->
# Infinite Babel

A deterministic infinite library in the style of libraryofbabel.info: every hex address maps to a stable, generated 4100-character page. No page content is ever stored the address is the only datum th

- Site: https://infinite-babel.api.holode.xyz
- Support: support@infinite-babel.api.holode.xyz
<!-- /foundation:identity -->

## What this is

A deterministic infinite library in the style of libraryofbabel.info: every hex address maps to a stable, generated 4100-character page. No page content is ever stored — the address is the only datum; the page is derived from it on every read.

## Who it is for

- visitor

## Main features

- **View a page by address** — open /books/:hex and receive the generated 4100-character page with its address shown
- **Navigate neighbors** — previous/next links move through hex address +/- 1; any address is valid
- **Random page** — generates a random hex address and redirects to its page
- **Search the library** — bounded deterministic scan from a start address for an exact phrase; returns the first page containing it or reports not found in the scanned window

## Core entities

- Page

## Run locally

```bash
bundle install
bin/rails db:prepare
bin/dev
```

Requires Ruby, PostgreSQL, and the usual Rails toolchain. See `bin/setup` if present.

## Demo

Nothing to seed — the library generates itself from addresses. A small curated vault of recovered texts at low addresses (e.g. 1, 2, 3) makes phrase-search demos land instantly.

## Deploy notes

Production `config.hosts` is derived from `domain` in `config/foundation.yml`. Keep that value aligned with the real host or every request will 403.
