open Tea

(* messages *)
type msg =
  | Signin_msg of SignIn.msg
  | Signup_msg of SignUp.msg
  | Location_changed of Web.Location.location
  [@@bs.deriving {accessors}]
  
(* routes *)
type route =
  | Sign_up
  | Sign_in
  | Index
  [@@bs.deriving {accessors}]

(* model *)
type identity = 
{ user_id: string option
; jwt: string option
}

type model = 
{ signin_model: SignIn.model
; current_user: identity
; route: route
}

(* route helpers *)
let route_of_location location =
  let route = Js.String.split "/" location.Web.Location.hash in
  match route with
  | [|"#"; ""|] -> Sign_in
  | [|"#"; "sign_in"|] -> Sign_in
  | [|"#"; "sign_up"|] -> Sign_up
  | [|"#"; "landing"|] -> Index
  | _ -> Sign_up (* default route *)

let location_of_route = function
  | Sign_in -> "#/sign_in"
  | Sign_up -> "#/sign_up"
  | Index -> "#/landing"
    
let update_route model = function
  | route when model.route = route -> model, Cmd.none
  | route -> 
  { model with route = route }, 
  location_of_route route |> Tea.Navigation.modifyUrl
