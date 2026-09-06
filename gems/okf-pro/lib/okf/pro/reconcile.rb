# frozen_string_literal: true

module OKF
  module Pro
    # Rule 1 — writing is reconciliation.
    #
    # Fires on Write, not Edit: a new concept is the moment a claim enters the
    # corpus, and the moment both it and whatever it collides with are cheapest
    # to hold in one head. Its reach is bounded by the filename's vocabulary,
    # which is exactly the limit the rule states about itself — it catches
    # collisions as well as your search words do, and no better.
    module Reconcile
      module_function

      def search(target, event)
        return [] if target.nil?
        return [] unless event.tool_name == "Write"
        return [] if target.rel.start_with?("journal/")
        return [] if NO_RECONCILE.include?(target.basename)
        return [] unless new_concept?(target)

        hits = terms(target).map { |term| block_for(target, term) }.compact
        return [] if hits.empty?

        [ "RULE 1 — reconciliation. Existing concepts share this new concept's vocabulary. " \
          "Read them now: contradiction, supersession, or duplicate? Deprecate the loser at this " \
          "moment, or file a conflict line on board.md. Do not simply continue.\n#{hits.join("\n")}" ]
      end

      def terms(target)
        File.basename(target.rel, ".md").split("-")
            .reject { |t| discardable?(t) }
            .first(4)
      end

      # A purely numeric segment is dropped, which is what `2` and `0` were
      # when this was measured. A number in a filename is an ordinal or a date
      # part — `phase-2`, `round-3` — and searching the corpus for it returns
      # every other concept that happens to be numbered, which is a fact about
      # the naming convention and not about this claim.
      def discardable?(term)
        term.empty? || STOP_WORDS.include?(term.downcase) || term.match?(/\A\d+\z/)
      end

      def block_for(target, term)
        rows = matches(target, term)
        return nil if rows.empty?

        statuses = status_index(target.bundle)
        body = rows.map do |r|
          "    #{r[:id]}#{settled(statuses[r[:id]])}  ·  #{r[:type]}  ·  #{r[:title]}\n      #{r[:snippet]}"
        end
        "— '#{term}':\n#{body.join("\n")}"
      end

      # §5.4's `status`, made operative. The skill teaches `status: deprecated`
      # as the machine-readable half of Rule 1's supersession move — correct the
      # loser NOW, and mark it — and this is what makes that teaching worth
      # anything: a collision with a concept that has already been deprecated is
      # a collision somebody already settled, and re-litigating it is the cost
      # the marking exists to avoid.
      #
      # It annotates rather than filters. A deprecated concept is "kept for
      # links and history, no longer current" (§5.4), so it is still a real hit
      # and still worth reading — what changes is what the reader does about it.
      # Filtering it out would hide the evidence that the question was answered.
      def settled(status)
        status == "deprecated" ? "  [deprecated — this collision was already settled]" : ""
      end

      def status_index(bundle)
        bundle.concepts.each_with_object({}) { |concept, index| index[concept.id] = concept.status }
      end

      # The concept being written is excluded (it is not its own collision), and
      # so are the structural files: a hit in README or board.md means they quote
      # a concept, not that they assert against one.
      def matches(target, term)
        rows = ::OKF::Bundle::Search.call(target.bundle, term)
                                    .reject { |r| r[:id] == target.id }
                                    .reject { |r| NO_RECONCILE.include?("#{File.basename(r[:id])}.md") }
        return [] if rows.size > ceiling(target.bundle)

        rows.first(5)
      end

      # A term has to discriminate, and the count that decides it is taken
      # before the truncation — which is the whole defect. `first(5)` used to
      # run before anyone counted, so a term matching half the bundle and a
      # term matching five concepts arrived at the reader as the same block of
      # five rows. That is how `why`, `what` and `that` reported five hits each
      # on every write while looking exactly like a real collision.
      #
      # A term over the ceiling is dropped whole rather than truncated harder:
      # it is a fact about the bundle's vocabulary, and printing its first five
      # rows would present a property of the corpus as a property of this
      # concept.
      #
      # A fifth of the corpus is the rule — a term returning that much of the
      # bundle carries no information about the concept being written. The
      # floor is what keeps the rule honest where a corpus is small: a fifth of
      # eight concepts is under two, so without it the gate would fall silent
      # exactly where the bundle is small enough for reconciliation to be
      # cheap. Five is the floor because five is what a block shows — below it,
      # dropping a term would mean refusing to print a list the gate could have
      # printed whole.
      def ceiling(bundle)
        [ (bundle.concepts.size / 5.0).ceil, 5 ].max
      end

      # Is this Write the moment a claim enters the corpus, or a rewrite of one
      # already in it?
      #
      # `tool_name == "Write"` cannot tell those apart. At `PostToolUse` the
      # write has already happened, so the file exists either way, and the gate
      # fired on every rewrite of every concept — the second half of the recall
      # problem, and the half no word list reaches. Git is the only party that
      # remembers what was there first. `Records` already asks it at a door
      # where the answer matters, so this is the technique the gem has rather
      # than a new dependency.
      #
      # Only a clean "yes, tracked" is silence. No git, no repository, a git
      # that could not answer — all of them prompt, because the prompt IS the
      # refusal at this gate: failing closed here means asking, not staying
      # quiet, and a bundle outside version control is one where nothing else
      # remembers either.
      def new_concept?(target)
        IO.popen(
          [ "git", "-C", target.root, "ls-files", "--error-unmatch", "--", target.rel ],
          err: File::NULL, &:read
        )
        !$?.success?
      rescue Errno::ENOENT
        true
      end
    end
  end
end
