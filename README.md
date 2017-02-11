# Grimoire

> **grimoire** (n.) /grimˈwɑr/
> a manual of magic or witchcraft used by witches and sorcerers

This gem is meant to be used as a personal extension to the standard library.

That is, I install it as a dependency on all of my projects, so that my tools
are never more than a `require` statement away. Therefore, this package should
include only features that I personally find useful enough to be universally
available throughout my projects.

To achieve this pattern, I use a script to create new projects that copies a
default Gemfile into the directory:

```ruby
# frozen_string_literal: true
source "https://rubygems.org"

gem "rspec"
gem "pry"
gem "pry-byebug"
gem "grimoire", github: "mcantor/grimoire", branch: "master"
```

However, since I want to be able to actively develop `grimoire` as I use it,
I configure Bundler to build from my local checkout:

```sh
bundle config local.grimoire /Users/mcantor/src/grimoire
```

This way, when I update the package, I can simply bump the gemspec version,
commit locally, and run `bundle` to start using the new features.

# Features

## Data Directories

Easy config/test data loader. Currently supports YAML only.

```ruby
require "grimoire/data_dir"

class Application
  data_dir

  def print_names
    puts names.join ", " #=> "Wash, Book"
  end
end

```

```yaml
# data/names.yaml
- Wash
- Book
```

## Data Objects

Static, behavior-less objects that hold information and
support multiple convenient types of access.

Very useful when combined with Data Directories.

```ruby
require "grimoire/data_objects"

food = DataObject.new hey: "you"
p food[:hey] #=> "you"
p food["hey"] #=> "you"
p food.hey #=> "you"
```

## No-Op

Identity function for getting rid of if statements

```ruby
require "grimoire/noop"

bomb = "hello I am a water balloon please"
print "Will you [explode] the balloon or [chill]? >"
input = gets.chomp

p {
  "explode" => lambda { "KABOOM!" },
  "chill" => NOOP
}[input].call(bomb)
```

## Smart ARGV

Schemaless ARGV interaction for simple scripts.

```ruby
require "grimoire/smart_argv"

# script.rb -ari git --file foo.yaml
ARGV.flag :a #=> true
ARGV.flag :r #=> true
ARGV.flag :read #=> true (first character, would also return true if --read passed)
ARGV.option :ignore #=> "git"
ARGV.option :file #=> "foo.yaml"
```

## Smart Deindent

Normalize indents of nested heredocs.

```ruby
require "grimoire/smart_deindent"

module Application
  GREETING = <<-EOF.smart_deindent
    This line will have 0 indent. It defines the indent level of the heredoc.
      This line will have 2 spaces of its indent preserved.
    Back to 0.
  EOF
end
```

## Smart Variables

Define and set positional constructor parameters with duck-typed contracts.

```ruby
require "grimoire/smart_variables"

class Recipe
  smart_variables do
    Text RO Required name
    List RW Optional ingredients
    Date RO Optional pub_date
  end
end

recipe = Recipe.new "Cake"
recipe.name #=> "Cake"
recipe.ingredients #=> []
recipe.pub_date #=> Date.today
```

Each smart variable declaration has four parts:

- **Contract**: One of `Text`, `List`, `Date`, `Time`, `Epoc`, `Int`, `Hash`
- **Permissions**: `RO` => `attr_reader`, `RW` => `attr_accessor`
- **Arity**: `Required` results in `ArgumentError` if not specified. `Optional` sets default by contract
- **Name**: Snake case, please!

Some contracts support smart typecasting:

```ruby
recipe.pub_date = "11/22" #=> #<Date: 2017-11-22 ((2458080j,0s,0n),+0s,2299161j)>
```

## Bash Styles

Reusable shell styles.

```ruby
require "grimoire/bash_styles"

message = "You must construct additional pylons."
style = Style.new ["fg light red", "bold"]
puts style.wrap(message)
```

- **ANSI Colors**:
  ```ruby
  Style.new ["fg blue", "bg light red"]
  ```
- **Bold**:
  ```ruby
  Style.new ["bold"]
  ```
- **RGB**:
  ```ruby
  Style.new ["fg 0 0 0", "bg 5 5 5"]` # (black on white)
  ```
- **Grayscale**:
  ```ruby
  Style.new ["fg gray 0", "bg gray 20"]` # (darkest on lightest)
  ```

