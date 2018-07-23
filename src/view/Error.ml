open Tea.Html

let view error_description =
  div
    []
    [ label []
      [ text error_description ]
    ]