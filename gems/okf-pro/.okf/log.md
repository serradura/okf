# Update Log

## 2026-09-06

* **Rule 1 stops firing on its own recall.** `reconcile-search` was blocking on
  `why`, `what`, `that`, `its`, `move`, `2` and `0`, five hits each, on every
  write — and a prompt present on every write carries what no prompt carries.
  Three narrowings, none of them touching what the rule asks: the stop-word list
  grows by what was measured and drops purely numeric segments, a term matching
  more than a fifth of the corpus is dropped whole because the count is now
  taken before the truncation to five, and novelty is asked of git rather than
  inferred from `tool_name == "Write"`, which at `PostToolUse` cannot tell a new
  concept from a rewrite. A git that cannot answer still prompts
  ([structure/the-gates](/structure/the-gates.md)).

## 2026-08-30

* **A per-edit check now only asks what one edit can answer.** Four of
  `Conformance`'s findings — `broken_link`, `broken_index_entry`, `orphan`,
  `not_in_index` — are questions about a set of files, and no write order
  avoids them at the per-edit door: write the index first and its entry is
  broken, write the concept first and it is the orphan. They are withheld
  under `scope: :edit`, confessed by count rather than dropped, and asked at
  the Stop gate and in `audit` where the write set is complete
  ([structure/the-gates](/structure/the-gates.md)). The Stop gate ran no
  conformance at all before this, so half the change is an addition rather
  than a move.

* **The scaffold verbs go through `parse_flags` too, and the catalogue says so.**
  [capabilities/verbs](/capabilities/verbs.md) described the family by what it
  does *not* do: no `dir_argument`, because `setup` into an empty directory is
  the point. That omission read as an exemption from the parser as well, and it
  was one. `--help` reached the verb as its destination, so the generator
  answered the question by running. The paragraph now names both halves, and
  [testing/adding-a-verb](/testing/adding-a-verb.md) step 5 says it too. **A
  family defined only by its exception gets extended in the direction of the
  exception**, and the next reader pays for that.

## 2026-08-19

* **Every concept declares `generated:`.** The dates are read from git with
  `--follow`, so a rename is not mistaken for authorship — the first attempt
  stamped all 37 with the day the files *moved*, which is provenance invented
  rather than recorded, and was thrown away.

* **The structure and the catalogue moved into this bundle, and a test holds
  them to the code.** `AGENTS.md` carried a hand-maintained Map of `lib/**` that
  nothing checked, so a file could arrive, move or leave and the Map would keep
  reading plausibly. [Structure](/structure/) now owns it — one concept per
  layer, naming every file — and [Capabilities](/capabilities/) owns the
  catalogue of what the sixteen verbs and nine checks already answer, which is
  the list an agent has to read before writing a seventeenth.
  `test/unit/bundle_catalog_test.rb` is the pin, and it bites in both
  directions: a file no concept names, a concept naming a file that is gone, or
  a catalogue that disagrees with `CLI::USAGE` or `CLI::HOOK_NAMES`.
  [testing/adding-a-verb](/testing/adding-a-verb.md) is the walk a new surface
  owes, ending at the catalogue entry the pin will demand.

## 2026-08-17

* **okf-pro 1.0.0.** The prototype checker — carried inside a template
  repository that was cloned to start a bundle — becomes the fourth gem in this
  monorepo, entered through the okf plugin seam as `okf pro <cmd>` rather than a
  repository to fork. It ships no executable: a second entry point would be a
  second thing the scaffold's wrapper has to recognise, on the one code path
  where being wrong means a gate waves an edit through.

* **Three doors, and a contract that outranks them.** The same invariants are
  asked at the agent's tool boundary, at `git commit` against the *staged* tree,
  and again in CI, because each door sees edits the others structurally cannot.
  Blocking checks fail closed, feedback checks fail loud, and no check ever fails
  silent — the clause that shapes the code, since every defect this gem has had
  failed in the direction of silence
  ([contract/the-contract](/contract/the-contract.md)). Getting there closed
  three ways the plugin seam let an unchecked edit through
  ([seam/three-fail-opens](/seam/three-fail-opens.md)), the case where a shim on
  `PATH` passes every gate by exit status alone
  ([seam/identity-not-existence](/seam/identity-not-existence.md)), bundler
  scoping that switched every gate off inside a bundle that did not name this
  gem ([seam/bundler-scoping](/seam/bundler-scoping.md)), and the checker
  breaking its own third clause by reporting clean over checks it never ran
  ([contract/silent-skips](/contract/silent-skips.md)). The `hook` verb is the
  one place in this repo where exit 1 is *non-blocking* and 2 is the refusal
  ([contract/exit-codes](/contract/exit-codes.md)).

* **The CLI answers what is on the board, and writes the shapes with one form.**
  The prototype's surface was gates and nothing else, so an agent in a seeded
  bundle rediscovered state by reading raw markdown and reconstructed a line's
  grammar from the guides on every use. `state`, `board`, `snapshot`,
  `unverified` and `friction` answer, cheaply and in JSON when the consumer is an
  agent; `capture`, `promote`, `demote`, `journal open` and `close` write.
  Writers are additive and targeted, never regenerative — each computes its new
  text purely, declares the delta it intends, and a conservation guard refuses
  with nothing written when the actual delta differs in either direction
  ([design/derivation-that-writes](/design/derivation-that-writes.md)). A name a
  caller supplies is contained twice over
  ([contract/containment-directions](/contract/containment-directions.md)).

* **A recorder that neither gates nor lies.** `friction` writes down what was
  done by hand that a verb could have done, at paths that already run rather than
  at a new hook event, since `settings.json` is seeded and a registration added
  there would never reach an adopter through `upgrade`. It refuses nothing and
  still may not report a zero it did not count
  ([contract/telemetry-does-not-lie](/contract/telemetry-does-not-lie.md)).

* **`okf pro setup` replaces the template repository.** It writes the bundle and
  the governance around it, splitting what it may later rewrite from what becomes
  the adopter's by ownership rather than by subject
  ([scaffold/ownership-not-subject](/scaffold/ownership-not-subject.md)). It
  never refuses wholesale ([scaffold/collisions-and-refusals](/scaffold/collisions-and-refusals.md)),
  and no date ships in the generated tree, because dormancy measures a bundle's
  age by its oldest journal entry and a shipped entry makes a fresh clone read as
  an old one ([scaffold/no-date-ships](/scaffold/no-date-ships.md)).

* **The seeded README sells the practice, not the command set.** It is the only
  file in the generated tree addressed to the owner rather than the agent, and it
  carries what the skill never will: the exit, the limits, the price, and a week
  showing the system in use. The offer is that being good at any craft has a
  shape and you reach it by structuring how you work
  ([scaffold/the-adopters-manual](/scaffold/the-adopters-manual.md)).

* **The trust policy is the format's, not this gem's.** "Awaiting the owner's
  read" is derived from OKF v0.2 §5.3's tiers rather than from a truthiness test
  on `verified:`, across all four call sites at once — they cannot move
  separately ([trust/read-owed-rule](/trust/read-owed-rule.md)). A
  `process:`-verified briefing is machine-confirmed and still owes the owner a
  read. A scalar `verified:` is conformant and unreadable, which is the worst
  direction to fail in ([trust/scalar-verified](/trust/scalar-verified.md)).
  `freshness` is gone: `stale_after` is the format's own field, and a second
  implementation disagreeing by a day was worse than none.
