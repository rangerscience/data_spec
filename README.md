data_spec
========

[![Build Status](https://secure.travis-ci.org/narfanator/data_spec.png)](http://travis-ci.org/narfanator/data_spec) [![Dependency Status](https://gemnasium.com/narfanator/data_spec.png)](https://gemnasium.com/narfanator/data_spec) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/narfanator/data_spec)

Easily compare hashes and arrays in RSpec and Cucumber

Originally inspired by collectiveidea's json_spec gem

Installation
------------

    gem 'data_spec'

# Cucumber

Setup:
------------

Include `data_spec/cucumber` and define `data` in your Cucumber environment:
```ruby
# features/support/env.rb
require "data_spec/cucumber"

def data
  #...
end
```

Usage:
------------
**The step `Given the data is:` is not supplied by this gem**

Use either YAML or JSON:
````ruby
Given the data is:
"""
chunky: bacon
"""
Then the data should be:
"""
{
  "chunky": "bacon"
}
"""
```

Use path selection:
```ruby
Given the data is:
"""
interleaved:
- hashes:
    and:
    - arrays
"""
Then the data at "interleaved/0/hashes" should be:
"""
and:
- arrays
"""
```

Check inclusion:
```ruby
Given the data is:
"""
- 1
- 2
- 3
- even:
    'in a': hash
    'with only': some keys
"""
Then the data includes:
"""
- 1
- 2
"""
And the data at "3/even" includes "'in a': hash"
```

Check types:
```ruby
Given the data is:
"""
- bacon
- 1
- 2013-07-06 20:09:32.824102000 -07:00
"""
Then the data at "0" is of type String
Then the data at "1" is of type Fixnum
Then the data at "2" is of type Time
```

Use embedded code:
```ruby
Given the data is:
"""
- `1+1`
- '$1e2$'
- `'bacon'.class`
"""
Then the data at "0" should be 2
Then the data at "1" should be 100
Then the data at "2" should be `"chunky".class`
```
(Among other things, this lets you work around Ruby YAML's lack of support for scientific notation)

**Note: This is done via a raw `eval`, so it's dangerous**

Steps
----------

Matching:
* `Then the data should be:`
* `Then the data should be "..."`
* `Then the data at "..." should be:`
* `Then the data at "..." should be "..."`

Inclusion:
* `Then the data includes:`
* `Then the data includes "..."`
* `Then the data at "..." includes:`
* `Then the data at "..." includes "..."`

Type checking:
* `Then the data is of type ...`
* `Then the data at "..." if of type ...`

Pathing is done like so: `data[:chunky]['Bacon'][0]` would be "chunky/bacon/0". Each element (when looking in a hash) is first tried as a symbol, then as a string.

When checking inclusion against an array, you need to supply an array: `[1,2,3]` includes `[2]`, or `[1, [2,3], 4]` includes `[[2,3]]`.

When checking inclusion against a hash, you need to supply a hash: `{one: :two, three: four}` includes `{one: :two}`

You don't see this quite the same in the Cucumber steps because YAML parsing from a string does this inherently: `"one: two"` becomes `{'one' => 'two'}` and
`"[one, two]"` or `"- one\n- two"` becomes `['one', 'two']`

# RSpec

Setup
--------
```ruby
#in spec/spec_helper.rb
require 'data_spec'
```

Matchers
--------
Three matchers:
* `match_data(...).at(...)`
* `includes_data(...).at(...)`
* `match_block(lambda{...}).at(...)`

Exact matching is handled by `==`, while partial matching is handled by 
[`deep_include?`](http://stackoverflow.com/questions/3826969/ruby-hash-include-another-hash-deep-check)

Note that pathing is applied to the object being checked:

    hash1.should match_data(hash2).at("path/0")

results in:

    hash1[:path][0].should match_data(hash2)

# Library

Helpers
--------
* `DataSpec::Helpers.at_path(data, path)`
* `DataSpec.parse`

`at_path` is what provides the "pathing" functionality, while `parse` provides the interpreting of embedded code.

As seen in the examples, you can use $ at the beginning and end, or backticks instead of quotes. 
The backticks will actually be converted to dollar signs (YAML parsers choke on backticks), 
but they're prettier and easier to read.

Refinements
-------
Defined in `DataSpec::Refinements`; to use, `using DataSpec::Refinements`

* `Array.tree_walk_with_self{|(key, value), array| ... }`
* `Array.deep_include? sub_array`
* `Hash.tree_walk_with_self{|(key, value), hash| ... }`
* `Hash.deep_include? sub_hash`

`tree_walk_with_self` allows you to apply a block to every key/value pair in the hash or array, traversing recursively.
The third yielded value is the current node: `hash[key] == value`  - this allows you to alter the values of the hash during traversal.

`Array.deep_include? sub_array` simply does `(sub_array - self).empty?`, which is true when all elements of the sub-array
are present in `self`

`Hash.deep_include? sub_hash` is used to detect if every key/value pair in the `sub_hash` is present in `self`

#Contributing

Remaining Issues
-------
* The error messages suck. Plan is to provide them as a diff'd YAML, although I'm not sure what to do for blocks
* No table syntax as in `json_spec`
* No explicit testing of `tree_walks_with_self`
* No support for XML

Pull Requests
-----------
Go for it! Accepted code will have Cucumber and RSpec testing and be minimalist; if you spot a bug, try to provide a failing test in the report.

"Minimalist" doesn't mean fewest lines of code (although that's usually the case); it means "fewest new functions and objects"
