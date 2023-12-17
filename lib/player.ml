open Fun
open Sexplib.Std
open Ppx_yojson_conv_lib.Yojson_conv.Primitives

type t = {
  id: string;
  key: string option;
  name: string;
}
[@@deriving sexp, yojson]

type ref =
  | Ref of {
      id: string;
      key: string;
    }
[@@deriving sexp, yojson]

module Role = struct
  type t =
    | Copilot
    | Controller
    | Passenger
    | Pilot
  [@@deriving sexp]
end

let serialize t = Sexplib.Sexp.to_string (sexp_of_t t)
let serialize_json t = Yojson.Safe.to_string (yojson_of_t t)

let deserialize str =
  try str |> Sexplib.Sexp.of_string |> t_of_sexp |> Option.some with
  | _ -> None

let deserialize_json str =
  try str |> Yojson.Safe.from_string |> t_of_yojson |> Option.some with
  | _ -> None

let ttl = 14 * 24 * 60 * 60 (* 14 days *)

let write ~db player =
  try
    player
    |> serialize
    |> Red.setex db ("players" // player.id) ttl
    |> always (Ok player)
  with
  | exn -> Error exn

let create ~db name =
  let player = { id = Ulid.ulid (); key = Some (Ulid.ulid ()); name } in
  write player ~db

let lookup ~db id =
  try
    Red.get db ("players" // id) |> Option.flat_map deserialize |> Result.ok
  with
  | exn -> Error exn

let secure_lookup ~db (Ref r) =
  let verify = function
    | Some player when player.key = Some r.key -> Some player
    | _ -> None
  in
  Result.map verify (lookup r.id ~db)
