(* This opens the Elm-style virtual-dom functions and types into the current scope *)
open Tea
open App
open AppRoute

(* models *)
let init_model =
  { signin_model = SignIn.init
  ; current_user = { user_id = None; jwt = None }
  ; route = Sign_up
  }

let init () location =
  let model, cmd =
    route_of_location location None |> update_route init_model in
    model, cmd

(* This is the central message handler, it takes the model as the first argument *)
let update model = function (* These should be simple enough to be self-explanatory, mutate the model based on the message, easy to read and follow *)
  | Signup_msg _msg -> model, Cmd.none
  | Signin_msg msg -> 
    let signin_model, cmd = SignIn.update model.signin_model msg in
    let current_user  = 
      { user_id = signin_model.user_id
      ; jwt = (SignIn.request_token_to_option signin_model.jwt) 
      } in
    { model with signin_model; current_user }, Cmd.map signin_msg cmd
  | Location_changed location ->
    model.current_user.jwt 
    |> route_of_location location 
    |> update_route model

(* This is the main callback to generate the virtual-dom.
  This returns a virtual-dom node that becomes the view, only changes from call-to-call are set on the real DOM for efficiency, this is also only called once per frame even with many messages sent in within that frame, otherwise does nothing *)
let view model = 
  let route = model.route in
  match route with
  | Sign_in -> SignIn.view model.signin_model |> map signin_msg
  | Sign_up -> SignUp.view model |> map signup_msg
  | Index -> AuthenticatedContainer.view model

let subscriptions _model = Tea.Sub.none

(* This is the main function, it can be named anything you want but `main` is traditional.
  The Program returned here has a set of callbacks that can easily be called from
  Bucklescript or from javascript for running this main attached to an element,
  or even to pass a message into the event loop.  You can even expose the
  constructors to the messages to javascript via the above [@@bs.deriving {accessors}]
  attribute on the `msg` type or manually, that way even javascript can use it safely. *)
let main =
  Tea.Navigation.navigationProgram location_changed
    { init
    ; update
    ; view
    ; subscriptions = subscriptions
    ; shutdown = (fun _ -> Cmd.none)
    }