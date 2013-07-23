Feature: Core Steps

  Scenario: JSON / YAML Equality
    Given the data is:
    """
    chunky: bacon
    ordered_by:
    - person: joe
      wants:
        pieces: `1+1`
    - person: josephina
      wants:
        pieces: `1e2`
    """
    Then the data should be:
    """
    {
      "ordered_by": [
        {
          "wants": {
            "pieces": "`1+1`"
          },
          "person": "joe"
        }, 
        {
          "wants": {
            "pieces": "`1e2`"
          }, 
          "person": "josephina"
        }
      ],
      "chunky": "bacon"
    }
    """

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
    url: "https://www.google.com/images/srpr/logo4w.png"
    """
    Then the data at "date" should be of type Time
    And the data at "fixnum" should be of type Fixnum
    And the data at "float" should be of type Float
    And the data at "string" should be of type String
    And the data at "hash" should be of type Hash
    And the data at "array" should be of type Array
    And the data at "url" should be of type URI
    #Note: ^^ Actually fetches the URL
