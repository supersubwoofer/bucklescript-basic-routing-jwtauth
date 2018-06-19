(* This line opens the Tea.App modules into the current scope for Program access functions and types *)
open Tea.App

(* This opens the Elm-style virtual-dom functions and types into the current scope *)
open Tea.Html

(* Let's create a new type here to be our main message type that is passed around *)
type msg =
  | Location_changed of Web.Location.location
  [@@bs.deriving {accessors}] (* This is a nice quality-of-life addon from Bucklescript, it will generate function names for each constructor name, optional, but nice to cut down on code, this is unused in this example but good to have regardless *)

type 'a option =
  | Some of 'a
  | None

type ('success, 'failure) result = 
  | Ok of 'success
  | Error of 'failure

type route =
  | Sign_up
  | Sign_in
  | Index

type identity = {
  user_id: string option;
}

type model = {
  current_user: identity;
  route: route
}

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
  | route when model.route = route -> model, Tea.Cmd.none
  | Sign_up -> { model with route = Sign_up }, Tea.Cmd.none
  | Sign_in -> { model with route = Sign_in }, Tea.Cmd.none
  | Index -> { model with route = Index }, Tea.Cmd.none

let init_model =
  { current_user = {user_id = None}
  ; route = Sign_up
  }

let init () location =
  let model, cmd =
    route_of_location location |> update_route init_model in
  model, cmd

(* This is the central message handler, it takes the model as the first argument *)
let update model = function (* These should be simple enough to be self-explanatory, mutate the model based on the message, easy to read and follow *)
  | Location_changed location ->
    route_of_location location |> update_route model

(* This is just a helper function for the view, a simple function that returns a button based on some argument *)
let view_button title msg =
  button
    [ onClick msg
    ]
    [ text title
    ]

(* This is the main callback to generate the virtual-dom.
  This returns a virtual-dom node that becomes the view, only changes from call-to-call are set on the real DOM for efficiency, this is also only called once per frame even with many messages sent in within that frame, otherwise does nothing *)
let view model =
  div
    []
    [ span
        [ style "text-weight" "bold" ]
        [ text (location_of_route model.route) ]
    ; br []
    ; a [ "#/sign_in" |> href ]
        [ text "sign_in" ]
    ; br []
    ; a [ "#/sign_up" |> href ]
        [ text "sign_up" ]
    ; br []
    ; a [ "#/landing" |> href ]
        [ text "landing" ]
    ]

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
    ; shutdown = (fun _ -> Tea.Cmd.none)
    }