open Fun
open Lwt.Syntax
module M = Mobwatch
module Res = Fun.Http.Res

let is_valid name =
  String.length name < 32
  && String.length name > 0
  && Str.string_match (Str.regexp "^[A-Za-z ][A-Za-z0-9_ ]*$") name 0

let validate name =
  match is_valid name with
  | true -> Ok name
  | false -> Error name

let parse_post req =
  (* TODO implement csrf token *)
  let+ data = Dream.form req ~csrf:false in
  match data with
  | `Ok [ ("name", name) ] -> Some (validate name)
  | _ -> None

module Api = struct
  let get req =
    let name = Option.map validate (Dream.query req "name") in
    match name with
    | Some (Error _) -> Res.bad "invalid name"
    | _ -> Res.ok "ok"

  let post req =
    let* name = parse_post req in
    match name with
    | None -> Res.ok "ok"
    | Some (Error _) -> Res.bad "invalid name"
    | Some (Ok name') ->
    match M.Red.init () with
    | Error _ -> Res.err "db error"
    | Ok db ->
    match M.Player.create name' ~db with
    | Error _ -> Res.err "internal error"
    | Ok player -> Res.ok player.id
end

module Page = struct
  let show _req =
    Pages.Register.createElement ()
    |> Format.asprintf "%a" (Tyxml.Html.pp ())
    |> Dream.html
end
