open AppRoute

let view model = 
  let route = model.route in
  match route with
  | Index -> Landing.view model
  | _ -> Error.view "403 Forbidden"