open Lwt.Syntax
module H = Dream
module M = Mobwatch

let is_valid name =
  String.length name < 32
  && String.length name > 1
  && Str.string_match (Str.regexp "^[a-zA-Z0-9_]+$") name 0

let validate req =
  let validate_name name =
    match is_valid name with
    | true -> Ok name
    | false -> Error "invalid name"
  in
  (* TODO implement csrf token *)
  let+ data = H.form req ~csrf:false in
  match data with
  | `Ok [ ("name", name) ] -> validate_name name
  | _ -> Error "bad request"

let register req =
  let* r = validate req in
  match r with
  | Error msg -> H.respond ~code:400 msg
  | Ok name ->
  match M.Red.init () with
  | Error _ -> H.respond ~code:500 "db error"
  | Ok db ->
  match M.Player.create name ~db with
  | Error _ -> H.respond ~code:500 "internal error"
  | Ok player -> H.json (M.Player.serialize_json player)
