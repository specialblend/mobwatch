open Fun
open Lwt.Syntax
module Res = Fun.Http.Res

let rex = Re2.create_exn Mobwatch.Config._REGEXP_VALID_NAME
let is_valid name = Re2.matches rex name

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
    | Some (Ok name) ->
    match Mobwatch.Red.init () with
    | Error _ -> Res.err "db error"
    | Ok db ->
    match Mobwatch.Player.create name ~db with
    | Error _ -> Res.err "internal error"
    | Ok player -> Res.ok player.id
end

module Page = struct
  let show _req =
    Pages.Register.createElement ()
    |> Format.asprintf "%a" (Tyxml.Html.pp ())
    |> Dream.html
end
