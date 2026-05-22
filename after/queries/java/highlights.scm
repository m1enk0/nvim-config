; extends
(local_variable_declaration
  type: (type_identifier) @keyword
  (#eq? @keyword "var")
  (#set! priority 127))

(explicit_constructor_invocation
  constructor: (super) @keyword)

(constructor_declaration
  name: (identifier) @function
  (#set! priority 127))
