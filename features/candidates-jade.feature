Feature company-web-jade candidate

  Scenario: jade tag candidates
    Given the buffer is empty
    When I turn on jade-mode
    And I insert:
    """
    t
    """
    And I execute company-web-jade candidates command at current point
    Then company-web-jade candidates contains "template"
    And company-web-jade candidates contains "table"
    And company-web-jade candidates not contains "class"
     
    When I insert "empl"
    And I execute company-web-jade candidates command at current point
    Then company-web-jade candidates are "("template")"
 
  Scenario: jade attribute candidates
    Given the buffer is empty
    When I turn on jade-mode
    And I insert:
    """
      div(cla
    """
    And I execute company-web-jade candidates command at current point
    Then company-web-jade candidates are "("class")"
    And company-web-jade candidates not contains "div"

  Scenario: jade attribute value candidates
    Given the buffer is empty
    When I turn on jade-mode
    And I insert:
    """
     div(dir=""
    """
    And I press "<left>"
    And I execute company-web-jade candidates command at current point
    Then company-web-jade candidates contains "auto"

  Scenario: jade attribute value candidates quoted by "'"
    Given the buffer is empty
    When I turn on jade-mode
    And I insert:
    """
     div(dir=""
    """
    And I press "<left>"
    And I execute company-web-jade candidates command at current point
    Then company-web-jade candidates contains "auto"

  Scenario: jade attribute style candidates
    Given the buffer is empty
    When I turn on jade-mode
    And I insert:
    """
      div(style=""
    """
    And I press "<left>"
    And I execute company-web-jade candidates command at current point
    Then company-web-jade candidates contains "animation"
    And company-web-jade candidates contains "font"
    And company-web-jade candidates not contains "div"

  Scenario: jade attribute CSS candidates
    Given the buffer is empty
    When I turn on jade-mode
    And I insert:
    """
      div(style="font-family:  ")
    """
    And I press "<left><left>"
    And I execute company-web-jade candidates command at current point
    Then company-web-jade candidates contains "Courier"
    And company-web-jade candidates not contains "div"
    And company-web-jade candidates not contains "color"
    And company-web-jade candidates not contains "red"

    And I insert "; "
    And I execute company-web-jade candidates command at current point
    Then company-web-jade candidates contains "color"