open AppRoute

let view model = 
  let route = model.route in
  match route with
  | Index -> 
    begin match model.current_user.jwt with
      | Some _jwt -> Index.view model
      | None -> Error.view "Not Identified User"
    end
  | _ -> Error.view "403 Forbidden"