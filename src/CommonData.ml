(* common data *)
(*type 'a option' =
  | Some of 'a
  | None
  [@@bs.deriving {accessors}]

type ('success, 'failure) result = 
  | Ok of 'success
  | Error of 'failure
  [@@bs.deriving {accessors}]*)

(* async data *)
type ('success, 'failure) transfer =
  | Idle
  | Loading
  | Failed of 'failure
  | Received of 'success
  [@@bs.deriving {accessors}]