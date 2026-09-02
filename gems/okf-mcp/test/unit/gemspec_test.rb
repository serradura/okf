# frozen_string_literal: true

require "test_helper"
require "mcp"

# The declared `okf` floor is the one dependency claim nothing else can check.
# The Gemfile develops this shell against the kernel *checkout* next door, so
# every suite here runs against whatever `okf/lib/okf/version.rb` currently
# says — a surface published after the floor is used freely, stays green in CI,
# and fails on a host that resolved the floor instead. That is a publish-time
# failure with no earlier symptom, which is what this test moves forward.
class OKF::MCP::GemspecTest < OKF::TestCase
  GEM_ROOT = File.expand_path("../..", __dir__)

  # The floor may lead the kernel (okf-mcp can require an unreleased okf and
  # wait for it) but it may never lag: a lagging floor admits a kernel this
  # code raises NameError against. Equality is the normal state — the same PR
  # that bumps okf moves this line.
  test "the okf floor is not older than the kernel this suite resolves against" do
    assert_operator floor, :>=, Gem::Version.new(OKF::VERSION),
      "okf-mcp.gemspec floors okf at #{floor}, but this suite runs against okf #{OKF::VERSION}: " \
      "the shell may already read surfaces #{floor} never published. Move the floor to " \
      "#{OKF::VERSION} (see the RELEASE OBLIGATION comment in the gemspec)."
  end

  # The SDK claim looks like the kernel one above and is not the same claim,
  # which is what went wrong here.
  #
  # The kernel arrives from a *checkout*, so this code can start calling a
  # surface the moment it is written and the floor must follow it. The SDK
  # arrives from RubyGems, so nothing here can call an mcp surface it was not
  # written against. The danger is therefore not a floor that lags the code. It
  # is a requirement that excludes the version CI actually ran, which would mean
  # the suite proves a resolution the gem refuses to install with.
  #
  # This used to assert `mcp_floor >= MCP::VERSION`, a stronger claim and the
  # wrong one: it ratcheted the floor to whatever bundler happened to resolve,
  # so an upstream release nobody here asked for narrowed what an adopter may
  # install. It fired twice that way, and on both occasions the suite passed
  # against the very floor it was raising away from.
  #
  # `rake test:sdk_floor` is what closes the gap that ratchet was covering for.
  test "the mcp requirement is pessimistic" do
    refute_nil mcp_pin, "okf-mcp.gemspec declares no `~>` pin on mcp: #{mcp_requirement}"
  end

  test "the mcp requirement admits the SDK this suite resolves against" do
    resolved = Gem::Version.new(::MCP::VERSION)
    assert mcp_requirement.satisfied_by?(resolved),
      "okf-mcp.gemspec requires mcp #{mcp_requirement}, which does not admit the mcp #{resolved} " \
      "this suite just ran against: every assertion above proves a resolution the gem refuses to " \
      "install with."
  end

  private

  def floor
    dep = spec.dependencies.find { |d| d.name == "okf" }
    refute_nil dep, "okf-mcp.gemspec declares no okf dependency"
    requirement = dep.requirement.requirements.find { |op, _| op == ">=" }
    refute_nil requirement, "the okf dependency declares no `>=` floor: #{dep.requirement}"
    requirement.last
  end

  def mcp_requirement
    dep = spec.dependencies.find { |d| d.name == "mcp" }
    refute_nil dep, "okf-mcp.gemspec declares no mcp dependency"
    dep.requirement
  end

  # The pin is pessimistic (`~>`), so the floor is that requirement's version
  # rather than a separate `>=` line like okf's.
  def mcp_pin
    mcp_requirement.requirements.find { |op, _| op == "~>" }
  end

  def spec
    # `spec.files` comes from `git ls-files` with chdir, so the working
    # directory it is evaluated in decides the answer.
    @spec ||= Dir.chdir(GEM_ROOT) { Gem::Specification.load(File.join(GEM_ROOT, "okf-mcp.gemspec")) }
  end
end
