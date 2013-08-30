# DebControl

DebControl contains helper classes to read Debian control files. Write support is planed.

**This gem is under development. Every 0.x release might break backwards compatibility.**

## Installation

Add this line to your application's Gemfile:

    gem 'deb_control', '~> 0.0.1'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install deb_control


## Usage

The Class DebControl::ControlFileBase implements a generic parser for control files:

```ruby
control = DebControl::ControlFileBase.read 'debian/control'
// receive the array from paragraphs
control.paragraphs.size
// receive fields of paragraph
control.paragraphs.first['Source']
```

Each paragraph is a Hash containing its fields and values.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
