Feature: Core Steps

  Scenario: Array Equality
    Given the data is:
    """
    - 1
    - array:
      - 2
      - chunky: bacon
    """
    Then the data at "1/array/1" should be "chunky: bacon"
    Then the data should be:
    """
    - 1
    - array:
      - 2
      - chunky: bacon
    """

  Scenario: Hash Equality
    Given the data is:
    """
    one: two
    three: four
    five:
      chunky: bacon
      bacon: chunky
    """
    Then the data at "five/chunky" should be "bacon"
    Then the data should be:
    """
    five:
      bacon: chunky
      chunky: bacon
    three: four
    one: two
    """

  Scenario: Inclusion
    Given the data is:
    """
    array:
    - chunky: bacon
    - 2
    bacon: chunky
    """
    Then the data should include "bacon: chunky"
    And the data at "array" should include "[2]"
    And the data should include:
    """
    array:
    - chunky: bacon
    - 2
    """

  Scenario: Interpolation
    Given the data is:
    """
    - 1
    - `1+1`
    - `1+1+1`
    """
    Then the data should be:
    """
    - 1
    - 2
    - 3
    """

   Scenario: Types
    Given the data is:
    """
    date: 2013-07-06 20:09:32.824102000 -07:00
    fixnum: 1
    float: 1.0
    string: bacon
    hash: {}
    array: []
    """
    Then the data at "date" is of type Time
    And the data at "fixnum" is of type Fixnum
    And the data at "float" is of type Float
    And the data at "string" is of type String
    And the data at "hash" is of type Hash
    And the data at "array" is of type Array
