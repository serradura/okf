---
type: Constraint
title: Exactly two runtime dependencies
description: "`mcp` and `okf`, nothing else — rack and webrick arrive through okf and must never be named here — with both floors held to one rule: the floor tracks what the suite proves."
tags: [dependencies, gemspec, constraint]
generated:
  by: human:maintainer
  at: 2026-08-19T12:00:00Z
resource: okf-mcp.gemspec
---

# The two

`mcp` (the official SDK) and `okf` (the kernel). That is the whole list, and
`test/unit/gemspec_test.rb` pins it.

**rack and webrick arrive via okf.** Naming either one here would be the
mistake that looks like diligence: this gem uses both — the Rack seam and the
WEBrick bridge — but it uses them *because okf already depends on them*, and a
second declaration is a second version constraint to keep in sync with a gem
that owns the answer.

A third runtime dependency is a design decision, held to the same bar the
kernel holds its own: argue it, do not add it for convenience — and
[kernel-first](kernel-first.md) is usually the reason one is not needed.

# The floor tracks what the suite proves

One rule covers both, and it is the reason the pins are not round numbers.

**`mcp` is pinned pessimistically (`~>`)**, and the floor is not a guess about
compatibility. It is the oldest version the tests actually pass on. The listen
and modern-path tests exercise the SEP-2575 wire, which 1.0 and 1.1 never
served, so against those versions the tests fail and the floor cannot admit
them.

`rake test:sdk_floor` is what makes that sentence true rather than hopeful. It
runs the whole suite against the oldest SDK the pin admits, and CI runs it on
the floor Ruby. Every other job resolves the *newest* admissible SDK, so without
that leg the ceiling was proven on seven Rubies and the floor on none — and the
floor is the half the gemspec promises an adopter.

The gemspec drill used to cover the gap differently, by refusing any floor older
than the SDK the suite had resolved. That forced the floor up to whatever
bundler fetched, which makes the claim true by never admitting anything but the
newest release: an upstream publication nobody here asked for narrowed what an
adopter may install. It fired twice that way, and on both occasions the suite
passed against the very floor it was raising away from. **A rule that is kept by
shrinking what it has to cover is not being kept.** The drill now asks whether
the requirement *admits* the version CI ran, because a requirement that excludes
it would mean every assertion above it proved a resolution the gem refuses to
install with.

**The `okf` floor may lead the kernel checkout but never lag it.** It names the
kernel version that ships what this shell rides — `Search.prepare/with/across`,
registry groups, project-local discovery, `dirs`, `Bundle#directories`, the
slug grammar. An earlier floor once admitted a kernel this code raises
`NoMethodError` against, because `Bundle#directories` did not exist there: the
gem installed cleanly and broke on the first `dir` refusal.

That is the failure the rule closes, and why the floor moves when the code
starts calling something new — in the same commit, not at the next release.
