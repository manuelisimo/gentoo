# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="Changelog.md README.md"

inherit ruby-fakegem eapi7-ver

DESCRIPTION="RSpec's official Ruby on Rails plugin"
HOMEPAGE="http://rspec.info/"
SRC_URI="https://github.com/rspec/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="3"
KEYWORDS="~amd64"
IUSE=""

SUBVERSION="$(ver_cut 1-2)"

ruby_add_rdepend ">=dev-ruby/activesupport-3.0:*
	>=dev-ruby/actionpack-3.0:*
	>=dev-ruby/railties-3.0:*
	=dev-ruby/rspec-${SUBVERSION}*"

# Depend on the package being already installed for tests, because
# requiring ammeter will load it, and we need a consistent set of rspec
# and rspec-rails for that to work.
ruby_add_bdepend "test? (
	>=dev-ruby/capybara-2.2.0
	>=dev-ruby/ammeter-1.1.2
	~dev-ruby/rspec-rails-${PV}
)"

all_ruby_prepare() {
	# Remove .rspec options to avoid dependency on newer rspec when
	# bootstrapping.
	rm -f .rspec || die

	# Avoid bundler-specific specs.
	rm -f spec/sanity_check_spec.rb || die

	# Avoid broken controller generator specs for now.
	rm -fr spec/generators/rspec || die

	# Avoid loading rspec/rails explicitly since ammeter/init will also
	# do this and loading it twice causes an error
	sed -i -e '/rspec\/rails/ s:^:#:' spec/spec_helper.rb || die
}
