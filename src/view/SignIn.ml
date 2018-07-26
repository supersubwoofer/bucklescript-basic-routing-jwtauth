open Tea
open Tea.Html
open Tea.Json.Decoder
open CommonData
open Helper
open Network

external alert : (string -> unit) = "alert" [@@bs.val]

type msg =
  | Update_userid of string
  | Update_password of string
  | Signin_submit  
  | Identify_user of httpResult
  | Jwt_saved of (unit, string) Result.t
  [@@bs.deriving {accessors}] 
  
type model = 
  { user_id: string option
  ; password: string option
  ; jwt: request_user_token
  }

let init = 
  { user_id = None
  ; password = None
  ; jwt = Idle 
  }

let request_token_to_option rq_token =
  match rq_token with
  | Received data -> Some data
  | _ -> None

let decode_jwt jwt_str =
  decodeString (field "token" string) jwt_str

let value_from_json_str json_str =
  match decode_jwt json_str with
  | Ok value -> value
  | Error _e -> ""

let update model = function 
  | Update_userid uid -> let user_id = Some uid in
    { model with user_id }, Cmd.none
  | Update_password pwd -> let password = Some pwd in
    { model with password }, Cmd.none
  | Signin_submit ->
    begin match model.jwt with
      | Loading -> model, Cmd.none
      | Received _ -> model, Tea.Navigation.modifyUrl "#/index"
      | Idle | Failed _ ->
        begin match model.user_id, model.password with
          | Some userid, Some password -> 
            model, identity_jwt_request userid password identify_user
          | _ -> model, Cmd.none
        end
    end
  | Identify_user (Ok data) -> 
    let jwt = Received data in
    { model with jwt }, 
    Storage.save_local "jwt" (value_from_json_str data)
    |> Tea_task.attempt jwt_saved
  | Identify_user (Error _e) -> 
    Printf.sprintf "User is not identified" |> alert;
    let jwt = Failed "failed" in 
    { model with jwt }, Cmd.none
  | Jwt_saved (Ok _) -> model, Tea.Navigation.modifyUrl "#/index"
  | Jwt_saved (Error e) ->
    Printf.sprintf "jwt couldn't be saved because of error %s" e |> alert;
    model, Cmd.none

let view _model =
    div
    []
    [ fieldset [] [ legend [] [ text "Sign in" ]
    ; view_labeled_textbox 
      { id = "mail"; input_type = "email"; name = "usermail"; text = "E-mail:" } (fun x -> Update_userid x)
    ; view_labeled_textbox 
      { id = "pwd"; input_type = "password"; name = "password"; text = "Password:" } (fun x -> Update_password x)
    ; p [] [ view_button "Sign in" Signin_submit ]
    ]
    ; a [ "#/sign_up" |> href ]
    [ text "sign_up" ]
    ]