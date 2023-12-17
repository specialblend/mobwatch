open Fun
open Sexplib.Std
open Ppx_yojson_conv_lib.Yojson_conv.Primitives
module U = Ulid

type ref =
  | Ref of {
      id: string;
      key: string;
    }

type t = {
  id: string;
  key: string option;
  name: string;
  players: Player.t list;
}
[@@deriving sexp, yojson]

let serialize t = Sexplib.Sexp.to_string (sexp_of_t t)
let serialize_json t = Yojson.Safe.to_string (yojson_of_t t)

let deserialize str =
  try str |> Sexplib.Sexp.of_string |> t_of_sexp |> Option.some with
  | _ -> None

let deserialize_json str =
  try str |> Yojson.Safe.from_string |> t_of_yojson |> Option.some with
  | _ -> None

let ttl = 24 * 60 * 60 (* 24 hours *)

let write ~db room =
  try
    room
    |> serialize
    |> Red.setex db ("rooms" // room.id) ttl
    |> always (Ok room)
  with
  | exn -> Error exn

let create ~db name =
  let room = { id = U.ulid (); key = Some (U.ulid ()); name; players = [] } in
  write room ~db

let lookup ~db id =
  try
    Red.get db ("rooms" // id) |> Option.flat_map deserialize |> Result.ok
  with
  | exn -> Error exn

let secure_lookup ~db (Ref ref) =
  let verify = function
    | Some room when room.key = Some ref.key -> Some room
    | _ -> None
  in
  lookup ~db ref.id |> Result.map verify

let add_player ~db room player =
  let players = player :: room.players in
  let room = { room with players } in
  Result.map Option.some (write room ~db)
