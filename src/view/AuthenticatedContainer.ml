open Tea.Html
open Helper

type msg =
  | Sign_out 
  | Index_msg of Index.msg
  [@@bs.deriving {accessors}]

let view_top_menu children =
  div
    []
    [ label [] [ text "Top" ]
    ; p [] [ view_button "Sign out" Sign_out ]
    ; children
    ]

let view children = function
  | Some _jwt -> view_top_menu children
  | None -> Error.view "Not Identified User"