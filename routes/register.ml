open Lwt.Syntax
module M = Mobwatch

let is_valid name =
  String.length name < 32
  && String.length name > 1
  && Str.string_match (Str.regexp "^[a-zA-Z0-9_]+$") name 0

let validate name =
  if is_valid name then
    Ok name
  else
    Error name

let parse_post req =
  (* TODO implement csrf token *)
  let+ data = Dream.form req ~csrf:false in
  match data with
  | `Ok [ ("name", name) ] -> begin
      if is_valid name then
        Some (Ok name)
      else
        Some (Error name)
    end
  | _ -> None

let print_elt e = Format.asprintf "%a" (Tyxml.Html.pp_elt ()) e

let render_form ~name ~msg =
  Components.RegisterForm.Form.createElement ~name ~msg ()
  |> print_elt
  |> Dream.html

module Api = struct
  let get req =
    let name = Option.map validate (Dream.query req "name") in
    let msg =
      match name with
      | Some (Error _) -> Some "invalid name"
      | _ -> None
    in
    render_form ~name ~msg

  let post req =
    let* name = parse_post req in
    let show_form = render_form ~name in
    match name with
    | None -> show_form ~msg:None
    | Some (Error _) -> show_form ~msg:(Some "invalid name")
    | Some (Ok name') ->
    match M.Red.init () with
    | Error _ -> show_form ~msg:(Some "db error")
    | Ok db ->
    match M.Player.create name' ~db with
    | Error _ -> show_form ~msg:(Some "internal error")
    | Ok player -> show_form ~msg:(Some ("welcome, " ^ player.name))
end

module Page = struct
  let show _req =
    Pages.RegisterPage.createElement ()
    |> Format.asprintf "%a" (Tyxml.Html.pp ())
    |> Dream.html
end
