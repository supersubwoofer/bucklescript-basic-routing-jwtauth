open Tea
open CommonData

type httpResult = (string, string Http.error) Result.t

(* jwt authentication *)
type request_user_token = (string, string) transfer

let post_request url body =
  Http.request
    { method' = "POST"
    ; headers = [ Http.Header ("Content-Type", "application/json; charset=utf-8") ]
    ; url = url
    ; body = body
    ; expect = Http.expectString
    ; timeout = None
    ; withCredentials = false
    }

let identity_jwt_request userid password identify_user_callback =
  post_request 
    (Config.base_url ^ "/api/auth/identity/callback")
    (StringBody ("{\"user\": {\"email\": \"" ^ userid ^ "\", \"password\": \"" ^ password ^ "\"}}"))
    |> Http.send identify_user_callback