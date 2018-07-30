open Tea.Html

type msg = | None [@@bs.deriving {accessors}]

let view _model =
  div
    []
    [ label [] [ text "landing" ]
    ]