open Tea.Html
open Helper

type msg =
  | Update_userid of string
  | Update_password of string
  | Update_confirm_password of string
  | Signup_submit
  [@@bs.deriving {accessors}]
  
let view _model =
    div
    []
    [ fieldset [] [ legend [] [ text "Sign up" ]
    ; view_labeled_textbox {id = "mail"; input_type = "email"; name = "usermail"; text = "E-mail:"} (fun x -> Update_userid x)
    ; view_labeled_textbox {id = "pwd"; input_type = "password"; name = "password"; text = "Password:"} (fun x -> Update_password x)
    ; view_labeled_textbox {id = "confirm_pwd"; input_type = "password"; name = "confirm_password"; text = "Confirm Password:"} (fun x -> Update_confirm_password x)
    ; p [] [ view_button "Sign up" Signup_submit ]
    ]
    ;
    a [ "#/sign_in" |> href ]
    [ text "sign_in" ]
    ]