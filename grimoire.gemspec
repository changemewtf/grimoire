Gem::Specification.new do |gem|
  gem.name    = "grimoire"
  gem.version = "0.0.5"
  gem.date    = Date.today.to_s

  gem.summary = "cantrips and enchantments for general wizardry"
  gem.description = "this gem is an experiment in generalized problem-solving; I wonder if I will regret extracting code into it"

  gem.authors  = ["Max Cantor"]
  gem.email    = "max@maxcantor.net"
  gem.homepage = "http://github.com/mcantor/grimoire"

  gem.add_development_dependency      "rspec", [">= 3.5.0"]
  gem.add_development_dependency        "pry", [">= 0.10.4"]
  gem.add_development_dependency "pry-byebug", [">= 3.4.2"]

  gem.files = Dir['{exe,lib,spec}/**/*', 'README.md'] & `git ls-files -z`.split("\0")
end
