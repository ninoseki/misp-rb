# misp-rb

[![Build Status](https://travis-ci.com/ninoseki/misp-rb.svg?branch=master)](https://travis-ci.com/ninoseki/misp-rb)
[![Coverage Status](https://coveralls.io/repos/github/ninoseki/misp-rb/badge.svg?branch=master)](https://coveralls.io/github/ninoseki/misp-rb?branch=master)
[![CodeFactor](https://www.codefactor.io/repository/github/ninoseki/misp-rb/badge)](https://www.codefactor.io/repository/github/ninoseki/misp-rb)

A dead simple MISP API wrapper for Ruby.

If you aren't a Rubyist, I highly recommend to use the official [PyMISP](https://github.com/MISP/PyMISP).

## Installation

```bash
gem install misp
```

## Usage

### Configuration

```ruby
require "misp"

# In default, it tries to load configurations from environmental variables:
# - API endpoint(URL) from ENV["MISP_API_ENDPOINT"]
# - API key via from ENV["MISP_API_KEY"]
# You can configure them manually
MISP.configure do |config|
  config.api_endpoint = "MISP_URL(e.g. https://misppriv.circl.lu)"
  config.api_key = "MISP_API_KEY"
end
```

### Create an event

```ruby
event = MISP::Event.create(info: "my event")
```

### Retrive an event

```ruby
event = MISP::Event.get(15)
```

### Update an event

```ruby
event = MISP::Event.get(17)
event.info = "my new info field"
event.update
```

### Add an attribute

```ruby
event = MISP::Event.get(17)
event.add_attribute(value: "8.8.8.8", type: "ip-dst")
# or
attribute = MISP::Attribute(value: "1.1.1.1", type: "ip-dst")
event.add_attribute attribute
event.update
```

### Tag an event

```ruby
event = MISP::Event.get(17)
event.add_tag name: "my tag"
event.update
```

### Tag an attribute

```ruby
attribute = MISP::Attribute.search(value: "8.8.8.8").first
attribute.add_tag(name: "my tag")
```

### Create an event with attributes and tags already applied

```ruby
event = MISP::Event.new(
  info: "my event",
  Attribute: [
    value: "8.8.8.8",
    type: "ip-dst",
    Tag: [
      { name: "my attribute-level tag" }
    ]
  ],
  Tag: [
    { name: "my event-level tag" }
  ]
)
event.create
```

## Acknowledgement

The implementation design of this gem is highly influenced by [FloatingGhost/mispex](https://github.com/FloatingGhost/mispex).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
