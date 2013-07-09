Feature: Storage of local information

  Scenario: Variable Assignment
    Given `@var` is "chunky"
    And the data is:
    """
    `@var`
    """
    Then the data should be:
    """
    chunky
    """

  Scenario: Array Assignment
    Given `@var` is:
    """
    - chunky
    - bacon
    """
    And the data is:
    """
    - `@var[0]`
    - `@var[1]`
    """
    Then the data at "0" should be "`@var[0]`"
    And the data should be:
    """
    `@var`
    """

  Scenario: Array Appending
    Given `@var` is:
    """
    - chunky
    - bacon
    """
    And `@var` includes:
    """
    - two
    - three
    """
    And the data is:
    """
    `@var`
    """
    Then the data should include "`@var[2,3]`"

  Scenario: Hash Assignment
    Given `@var` is:
    """
    chunky: bacon
    bacon: chunky
    """
    And the data is:
    """
    `@var`
    """
    Then the data at "chunky" should be "bacon"
    And the data should be:
    """
    bacon: chunky
    chunky: bacon
    """

  Scenario: Hash Appending
    Given `@var` is:
    """
    chunky: bacon
    bacon: chunky
    """
    And `@var` includes:
    """
    bacon: bacon
    one: two
    """
    And the data is:
    """
    `@var`
    """
    Then the data at "bacon" should be "bacon"
    And the data at "one" should be "two"

  Scenario: Nesting:
    Given `@var` is:
    """
    nested:
      hash:
        chunky: bacon
    """
    And `@var['nested']` includes:
    """
    array:
    - 1
    - 2
    """
    And the data is:
    """
    - `@var['nested']['hash']['chunky']`
    - `@var['nested']['array']`
    """
    Then the data should be:
    """
    - bacon
    - - 1
      - 2
    """

  Scenario: Multiple Variables
    Given `@one` is:
    """
    one: two
    """
    And `@two` is:
    """
    two: three
    """
    And the data is:
    """
    - `@one`
    - `@two`
    """
    Then the data is:
    """
    - one: two
    - two: three
    """
