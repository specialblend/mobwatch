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

let parse_get req =
  Option.map validate (Dream.query req "name")

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

module RegisterForm = struct
  module NameInput = struct
    let styles =
      [
        "px-4";
        "py-2";
        "rounded-lg";
        "bg-zinc-800";
        "border-2";
        "focus:outline-none";
        "border-zinc-500";
      ]

    let styles name =
      match name with
      | Some (Error _) -> "border-red-500" :: styles
      | _ -> styles

    let render name =
      let open Tyxml.Html in
      let name' =
        match name with
        | Some (Ok name) -> name
        | Some (Error name) -> name
        | None -> ""
      in
      input
        ~a:
          [
            a_input_type `Text;
            a_name "name";
            a_value name';
            a_class (styles name);
            a_user_data "hx-get" "/register/validate";
            a_user_data "hx-target" "#register";
            a_placeholder "Your name";
          ]
        ()
  end

  module SubmitBtn = struct
    let styles =
      [
        "px-4";
        "py-2";
        "mt-4";
        "rounded-lg";
        "bg-zinc-800";
        "border-2";
        "border-zinc-500";
        "focus:outline-none";
      ]

    let render _ =
      let open Tyxml.Html in
      button
        ~a:[ a_class styles; a_button_type `Submit ]
        [ txt "Start" ]
  end

  let render name =
    let open Tyxml.Html in
    let a =
      [
        a_id "register";
        a_method `Post;
        a_user_data "hx-post" "/register";
        a_user_data "hx-swap" "/none";
      ]
    in
    form ~a [ NameInput.render name; SubmitBtn.render () ]
end

let print_elt e =
  Format.asprintf "%a" (Tyxml.Html.pp_elt ()) e

module Register = struct
  let get req =
    let name = parse_get req in
    RegisterForm.render name |> print_elt |> Dream.html

  let post req =
    let* name = parse_post req in
    match name with
    | None ->
        RegisterForm.render name |> print_elt |> Dream.html
    | Some (Error _) ->
        RegisterForm.render name |> print_elt |> Dream.html
    | Some (Ok name) ->
    match M.Red.init () with
    | Error _ -> Dream.respond ~code:500 "db error"
    | Ok db ->
    match M.Player.create name ~db with
    | Error _ -> Dream.respond ~code:500 "internal error"
    | Ok player ->
        Dream.json (M.Player.serialize_json player)
end
