open Fun
open Lwt.Syntax
open Ppx_yojson_conv_lib.Yojson_conv.Primitives
module Res = Fun.Http.Res

let is_valid = Re2.matches (Re2.create_exn Mobwatch.Config._REGEXP_VALID_NAME)

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
  module GenericRes = struct
    type t = { message: string } [@@deriving yojson]

    let serialize message = Yojson.Safe.to_string (yojson_of_t { message })
  end

  let get req =
    let name = Option.map validate (Dream.query req "name") in
    match name with
    | Some (Error _) -> Res.bad (GenericRes.serialize "Invalid name")
    | _ -> Res.ok "ok"

  let post req =
    let* name = parse_post req in
    match name with
    | None -> Res.ok "ok"
    | Some (Error _) -> Res.bad (GenericRes.serialize "Invalid name")
    | Some (Ok name) ->
    match Mobwatch.Red.init () with
    | Error _ -> Res.err (GenericRes.serialize "DB Error")
    | Ok db ->
    match Mobwatch.Player.create name ~db with
    | Error _ -> Res.err (GenericRes.serialize "Internal Error")
    | Ok player -> Res.ok (Mobwatch.Player.serialize_json player)
end

module Page = struct
  let show _req =
    Pages.Register.createElement ()
    |> Format.asprintf "%a" (Tyxml.Html.pp ())
    |> Dream.html
end
