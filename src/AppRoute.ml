open Tea

(* messages *)
type msg =
  | Signin_msg of SignIn.msg
  | Signup_msg of SignUp.msg
  | Auth_container_msg of AuthenticatedContainer.msg
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

let skip_to_index dest = function 
  | Some _value -> Index
  | None -> dest

let skip_to_signin dest = function 
  | Some _value -> dest
  | None -> Sign_in

(* route helpers *)
let route_of_location location jwt =
  let route = Js.String.split "/" location.Web.Location.hash in
  match route with
  | [|"#"; ""|] -> skip_to_index Sign_in jwt
  | [|"#"; "sign_in"|] -> skip_to_index Sign_in jwt
  | [|"#"; "sign_up"|] -> skip_to_index Sign_up jwt
  | [|"#"; "index"|] -> skip_to_signin Index jwt
  | _ -> Sign_up (* default route *)

let location_of_route = function
  | Sign_in -> "#/sign_in"
  | Sign_up -> "#/sign_up"
  | Index -> "#/index"
    
let update_route model = function
  | route when model.route = route -> model, Cmd.none
  | route -> 
    { model with route = route }, 
    location_of_route route |> Tea.Navigation.modifyUrl
