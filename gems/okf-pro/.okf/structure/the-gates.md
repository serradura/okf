---
type: Component
title: The gates — one question each, and the two doors that ask them all
description: Nine files, each answering one invariant, plus `audit` (the CI door) and `state` (the readers' payload) which ask the same questions from a different side.
generated:
  by: human:maintainer
  at: 2026-08-19
---

# The files

| file | the law or the question |
|---|---|
| `lib/okf/pro/reconcile.rb` | **Law 1** — what already says this, while the write is still hot |
| `lib/okf/pro/budget.rb` | **Law 3** — the cap, and the dormancy question |
| `lib/okf/pro/closing.rb` | **Law 2** — the stop gate, and the session banner |
| `lib/okf/pro/snapshot.rb` | Law 2's counters, derived — a checker, never a generator |
| `lib/okf/pro/attestation.rb` | what still awaits the owner's read |
| `lib/okf/pro/pairing.rb` | the board↔work invariants, both directions |
| `lib/okf/pro/conformance.rb` | `okf validate` + `okf lint`, in process |
| `lib/okf/pro/audit.rb` | the CI door: the same invariants minus the tool event |
| `lib/okf/pro/state.rb` | the readers' payload — cheap by contract |

The laws themselves are [design/three-laws](/design/three-laws.md); this concept
is where each one is implemented.

# Snapshot is a checker, not a generator

`Snapshot.counters` recomputes every number from the board and the bundle;
`Snapshot.line` renders it; `Snapshot.parse` reads a line already written; and
`Snapshot.verify` compares the two and reports the difference. There is no
`--write`, and there deliberately never will be: a writer and a checker sharing
a code path agree trivially, which is exactly what Law 2's confession must not
be able to do.

# Conformance is the kernel's answer, not a second one

`Conformance.check` runs the kernel's validator and linter in process against
the target's bundle. Every conformance and curation question is okf's to answer
— this gem owns the policy on top. The one rule it adds is the contract's third
clause: `Linter.call` with no options skips `expired` and `stale` and still
reports `healthy?`, so `confession` surfaces what was not run rather than
reporting clean over a silent skip.

**The policy on top is a scope.** Four findings — `broken_link`,
`broken_index_entry`, `orphan`, `not_in_index`, held in `SET_SCOPED` — are
questions about a *set* of files asked after one of them. An index entry is
decided by the concept it names; an orphan by whether anything else links it.
At the per-edit door the write set is incomplete by definition, and no write
order avoids that: write the index first and the entry is broken, write the
concept first and it is the orphan. So `check(target, scope: :edit)` withholds
those four, and the per-edit door is the only caller that asks for it.

Withholding is not dropping, which is the same clause again. `deferral` says
how many were withheld and names the two doors that ask them with the write set
complete — `Closing.stop_gate`, through `Conformance.findings` on the bundle it
has already parsed, and `Audit`, which never scoped anything and needed no
change. `findings` takes a bundle and an optional `rel:` rather than a Target
because neither of those doors has an edited file to be the subject: without a
`rel` there is no "your edit" and no "elsewhere", and inventing the distinction
would file every finding under a heading saying somebody else did it.

# Rule 1 is narrowed by three tests, not weakened

`Reconcile.search` asks what already says this, and it was measured firing on
`why`, `what`, `that`, `its`, `move`, `2` and `0` — five concepts each, on every
write. That is the failure [a-rule-you-can-walk-past](/design/a-rule-you-can-walk-past.md)
names from the other end: a prompt present on every write carries what a prompt
that never appears carries, and this is the one gate whose whole job is to make
somebody go and read something.

Three tests narrow *which* writes it speaks on. None of them changes what it
asks.

**A term must be a word.** `STOP_WORDS` carries what the gate was measured
firing on, and a purely numeric segment is not a term at all — a number in a
filename is an ordinal or a date part, and the corpus answers it with everything
else that happens to be numbered. One word on that list, `move`, is a content
word rather than a function word; it is there by measurement, and `ceiling`
below is the instrument that should eventually replace it, because a bundle
about moving house has no more discriminating word.

**A term must discriminate.** `matches` counts before it truncates, which is the
defect stated as a fix: `first(5)` used to run before anyone counted, so a term
hitting half the bundle and a term hitting five concepts reached the reader as
the same five rows. A term matching more than `ceiling` — a fifth of the corpus,
never fewer than the five rows a block can print — is dropped whole. Truncating
it harder would present a property of the corpus as a property of this concept.

**The write must be new.** `tool_name == "Write"` was standing in for novelty
and cannot carry it: at `PostToolUse` the write has happened, so the file exists
whether it was created or replaced. `new_concept?` asks git instead — untracked
means new — which is the technique [the-recorder](/structure/the-recorder.md)
already uses at the commit door.

And the direction of the failure, which is the contract again: only a clean
"yes, tracked" buys silence. No git, no repository, a git that could not answer
— every one of them reconciles. At this gate the prompt **is** the refusal, so
failing closed means asking, and a bundle outside version control is one where
nothing else remembers what was there first either.

# Two doors, one set of invariants

`Audit.call` is the CI door. It asks `structure`, `conformance`, `curation`,
`snapshot` and `pairing` of a tree with no tool event in sight, and it reserves
exit 1 for *findings* — spelling "the checker broke" as 2, because a pipeline
that cannot tell those apart learns to ignore both. `ambiguous_layout` is its
refusal when it cannot tell which bundle it was pointed at.

`State.call` is the other side: what is on the board, in one call, cheap by
contract. `full: true` is the one parse it will pay for — the readers exist
because an agent working in a seeded bundle rediscovered the board by reading
raw markdown while the stop gate was already computing it.

# Pairing holds the one git shell-out

`Pairing.failures` asks both directions at once: a project with no board line,
a board line with no project, a target that does not resolve, a link to a
closed project, a read line gone stale. `MARKER` and `NEGATED` are a pair — the
second is why "never closed" is not read as a closure marker. `dirty_markdown?`
is the git shell-out, and it is the only one outside `records.rb`.
