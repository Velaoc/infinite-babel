<!-- foundation:identity -->
# Infinite Babel

A deterministic infinite library in the spirit of
[libraryofbabel.info](https://libraryofbabel.info). Every hex address is a
book: a 4,100-character page is derived from the address alone. **Nothing is
ever stored** — the address is the only datum, and the same address yields
the same page on every machine, forever.

## What you get

- **Read any book** — open `/books/<hex>` and the page is generated on
  demand. Any hex string is valid; the library is total.
- **Navigate** — every book has a neighbor in both directions (hex address
  ± 1), plus a random door into the stacks.
- **Search** — a bounded deterministic scan forward from an address finds
  the first book containing a phrase. Hits redirect to their stable address.
- **A curated vault** — addresses `1`, `2`, and `3` carry recovered texts,
  so phrase-search demos land instantly.

## How it works

`app/services/babel_generator.rb` turns a hex address into a deterministic
stream of characters via a splitmix64 PRNG seeded from the address. Pages are
exactly 4,100 characters, like the original library. `app/models/book.rb`
adds the locator address (`<hex>.1.wall1.shelf1.volume1`), adjacency in hex
space, and the bounded search. No database rows are involved in reading a
book; the app boots and serves the entire library with an empty database.

## Run it

```bash
bin/setup
bin/rails server
```

Open http://localhost:3000 — you're in the library.

## Deploy

This repo is public and forkable. Point it at any Rails host (the
foundation's Kamal config lives in `config/deploy.yml`); the live preview
at `<slug>.demo.holode.xyz` wipes daily at 3AM Mexico City — the repo is the
keeper.

## License

MIT — see [LICENSE](LICENSE).
<!-- /foundation:identity -->
