# frozen_string_literal: true

require "test_helper"

# Rule 1. The gate's reach is bounded by the filename's vocabulary, which is
# the limit the rule states about itself — it catches collisions as well as
# your search words do, and no better. These tests pin the boundary rather
# than pretend it is not there.
class ReconcileTest < OKF::Pro::TestCase
  # Staged is tracked as far as `ls-files --error-unmatch` is concerned, and a
  # commit would need an identity this suite does not configure.
  def track_everything(dir)
    system("git", "-C", dir, "add", "-A", out: File::NULL, err: File::NULL)
  end

  def bundle_with_terms(b)
    b.concept("glossary/binding-estimate.md", type: "Term",
      body: "# Definition\n\nA binding estimate fixes the price for the listed inventory.\n")
    b.concept("reference/movers-quote.md", type: "Briefing",
      body: "# Summary\n\nThe quote is a binding estimate and cannot change at delivery.\n")
  end

  def test_reports_concepts_that_share_the_vocabulary
    with_bundle do |b|
      bundle_with_terms(b)
      target = OKF::Pro::Target.for(write_event(b.path, "reference/binding-estimate-notes.md"))

      refusal = OKF::Pro::Reconcile.search(target, write_event(b.path, "reference/binding-estimate-notes.md"))

      assert_equal 1, refusal.size
      assert_match(/RULE 1 — reconciliation/, refusal.first)
      assert_match(%r{glossary/binding-estimate}, refusal.first)
      assert_match(%r{reference/movers-quote}, refusal.first)
    end
  end

  def test_says_nothing_when_the_vocabulary_is_new
    with_bundle do |b|
      bundle_with_terms(b)
      e = write_event(b.path, "learnings/kettle-descaling.md")

      assert_empty OKF::Pro::Reconcile.search(OKF::Pro::Target.for(e), e)
    end
  end

  # Editing an existing concept is not the moment a claim enters the corpus.
  # Firing here would make every touch of every file a reconciliation prompt.
  def test_ignores_edits_and_fires_only_on_writes
    with_bundle do |b|
      bundle_with_terms(b)
      e = edit_event(b.path, "reference/binding-estimate-notes.md")

      assert_empty OKF::Pro::Reconcile.search(OKF::Pro::Target.for(e), e)
    end
  end

  def test_a_concept_is_not_its_own_collision
    with_bundle do |b|
      bundle_with_terms(b)
      e = write_event(b.path, "glossary/binding-estimate.md")
      refusal = OKF::Pro::Reconcile.search(OKF::Pro::Target.for(e), e)

      # movers-quote still collides; the file being written must not.
      assert_equal 1, refusal.size
      refute_match(/glossary\/binding-estimate .*·/, refusal.first)
      assert_match(%r{reference/movers-quote}, refusal.first)
    end
  end

  # A hit in README or board.md means they quote a concept, not that they
  # assert against one. A gate that reports the README every time is one
  # people learn to scroll past.
  def test_structural_files_are_not_collisions
    with_bundle do |b|
      bundle_with_terms(b)
      dir = b.path
      File.write(File.join(dir, "README.md"),
        "---\ntype: Overview\ntitle: README\ndescription: x\n---\n\n" \
        "# Readme\n\nMentions a binding estimate at length, twice, binding estimate.\n")
      e = write_event(dir, "learnings/binding-lessons.md")
      refusal = OKF::Pro::Reconcile.search(OKF::Pro::Target.for(e), e)

      refute_empty refusal
      refute_match(/README/, refusal.first)
    end
  end

  def test_structural_files_are_not_reconciled_themselves
    with_bundle do |b|
      bundle_with_terms(b)
      %w[board.md log.md index.md README.md CLAUDE.md].each do |name|
        e = write_event(b.path, name)

        assert_empty OKF::Pro::Reconcile.search(OKF::Pro::Target.for(e), e), "#{name} should not reconcile"
      end
    end
  end

  # A journal entry is a record of a day, not a claim about the world. It
  # cannot contradict anything, so it is exempt.
  def test_journal_entries_are_exempt
    with_bundle do |b|
      bundle_with_terms(b)
      e = write_event(b.path, "journal/2026-08-12.md")

      assert_empty OKF::Pro::Reconcile.search(OKF::Pro::Target.for(e), e)
    end
  end

  # ── novelty, asked of git ─────────────────────────────────────────────────

  # `tool_name == "Write"` was doing the work of "is this new", and at
  # PostToolUse it cannot: the write has already happened, so the file exists
  # whether it was created or replaced. Every rewrite of every concept fired.
  def test_a_rewrite_of_a_tracked_concept_does_not_fire
    with_bundle(git: true) do |b|
      bundle_with_terms(b)
      dir = b.path
      track_everything(dir)
      e = write_event(dir, "glossary/binding-estimate.md")

      assert_empty OKF::Pro::Reconcile.search(OKF::Pro::Target.for(e), e)
    end
  end

  # And the pin that keeps the novelty test from being a mute button: the same
  # tracked bundle, a path git has never seen, still reconciles.
  def test_a_new_concept_in_a_tracked_bundle_still_fires
    with_bundle(git: true) do |b|
      bundle_with_terms(b)
      dir = b.path
      track_everything(dir)
      e = write_event(dir, "reference/binding-estimate-notes.md")

      refute_empty OKF::Pro::Reconcile.search(OKF::Pro::Target.for(e), e)
    end
  end

  # A git that cannot answer prompts anyway — every other test in this file is
  # an instance, since none of their bundles is a repository at all. The prompt
  # IS the refusal at this gate, so failing closed means asking.
  def test_a_bundle_outside_version_control_still_reconciles
    with_bundle do |b|
      bundle_with_terms(b)
      e = write_event(b.path, "reference/binding-estimate-notes.md")

      refute_empty OKF::Pro::Reconcile.search(OKF::Pro::Target.for(e), e)
    end
  end

  # ── a term has to discriminate ────────────────────────────────────────────

  # The count is taken before the truncation, which is the whole defect: five
  # rows out of twelve hits and five rows out of five looked identical to the
  # reader. A term over the ceiling is dropped whole rather than truncated
  # harder — its hits are a fact about the corpus, not about this concept.
  def test_a_term_matching_more_than_the_ceiling_is_dropped_whole
    with_bundle do |b|
      12.times do |i|
        b.concept("reference/haulage-note-#{i}.md", type: "Briefing",
          body: "# Note #{i}\n\nEvery note in this fixture mentions haulage.\n")
      end
      b.concept("glossary/binding-estimate.md", type: "Term",
        body: "# Definition\n\nA binding estimate fixes the listed price.\n")
      e = write_event(b.path, "reference/haulage-binding-estimate.md")
      target = OKF::Pro::Target.for(e)

      assert_empty OKF::Pro::Reconcile.matches(target, "haulage"),
        "a term returning most of the bundle carries no information about this concept"
      refute_empty OKF::Pro::Reconcile.matches(target, "binding")

      refusal = OKF::Pro::Reconcile.search(target, e)

      refute_empty refusal, "a genuine collision still blocks"
      refute_match(/haulage/, refusal.first)
      assert_match(%r{glossary/binding-estimate}, refusal.first)
    end
  end

  # The floor under the ratio. A fifth of a small corpus is less than one, so
  # without it every term would be over the ceiling and the gate would fall
  # silent exactly where the bundle is small enough for reconciliation to be
  # cheap.
  def test_a_small_bundle_is_not_silenced_by_the_ratio
    with_bundle do |b|
      bundle_with_terms(b)
      target = OKF::Pro::Target.for(write_event(b.path, "reference/binding-estimate-notes.md"))

      assert_operator OKF::Pro::Reconcile.ceiling(target.bundle), :>=, 5
      refute_empty OKF::Pro::Reconcile.matches(target, "binding")
    end
  end

  # ── the words it was measured firing on ───────────────────────────────────

  def test_the_words_measured_firing_are_stop_words
    with_bundle do |b|
      bundle_with_terms(b)
      target = OKF::Pro::Target.for(write_event(b.path, "learnings/why-what-that-its-move-quote.md"))

      assert_equal %w[quote], OKF::Pro::Reconcile.terms(target)
    end
  end

  # `2` and `0` were terms. A number in a filename is an ordinal or a date
  # part, and searching for it returns whatever else happens to be numbered.
  def test_a_purely_numeric_segment_is_not_a_term
    with_bundle do |b|
      bundle_with_terms(b)
      target = OKF::Pro::Target.for(write_event(b.path, "reference/phase-2-binding-review.md"))

      assert_equal %w[phase binding review], OKF::Pro::Reconcile.terms(target)
    end
  end

  def test_terms_drop_stop_words_and_cap_at_four
    with_bundle do |b|
      bundle_with_terms(b)
      target = OKF::Pro::Target.for(write_event(b.path, "learnings/the-cost-of-a-late-and-slow-quote.md"))

      terms = OKF::Pro::Reconcile.terms(target)

      assert_equal 4, terms.size
      refute_includes terms, "the"
      refute_includes terms, "of"
      refute_includes terms, "a"
    end
  end

  def test_a_nil_target_has_no_opinion
    assert_empty OKF::Pro::Reconcile.search(nil, event)
  end

  # §5.4 made operative. The skill teaches `status: deprecated` as the
  # machine-readable half of Rule 1's supersession move, and this is what makes
  # the teaching worth anything: a collision with something already deprecated
  # is a collision somebody already settled, and the reader is told so instead
  # of re-litigating it. It is annotated, not filtered — §5.4 keeps a
  # deprecated concept "for links and history", so it is still a real hit.
  def test_a_deprecated_collision_says_it_was_already_settled
    with_bundle do |b|
      b.concept("glossary/binding-estimate.md", type: "Term", status: "deprecated",
        body: "# Definition\n\nA binding estimate fixes the listed price.\n")
      target = OKF::Pro::Target.for(write_event(b.path, "reference/binding-estimate-notes.md"))

      messages = OKF::Pro::Reconcile.search(target, write_event(b.path, "reference/binding-estimate-notes.md"))

      refute_empty messages
      assert_match(/glossary\/binding-estimate\s+\[deprecated — this collision was already settled\]/, messages.first)
    end
  end

  # And the pin that keeps the annotation from being noise: an ordinary
  # collision carries no marker at all. `status` is absent from almost every
  # concept in a real bundle, and §5.4 makes that mean `stable`.
  def test_an_ordinary_collision_carries_no_marker
    with_bundle do |b|
      b.concept("glossary/binding-estimate.md", type: "Term",
        body: "# Definition\n\nA binding estimate fixes the listed price.\n")
      target = OKF::Pro::Target.for(write_event(b.path, "reference/binding-estimate-notes.md"))

      messages = OKF::Pro::Reconcile.search(target, write_event(b.path, "reference/binding-estimate-notes.md"))

      refute_empty messages
      refute_match(/deprecated/, messages.first)
    end
  end
end
