open Fun
open Sexplib.Std

type ref =
  | Ref of {
      id: string;
      key: string;
    }
[@@deriving sexp]

type t = {
  id: string;
  key: string option;
  name: string;
  players: Player.t list;
}
[@@deriving sexp]

let serialize t = Sexplib.Sexp.to_string (sexp_of_t t)

let deserialize s =
  try Some (t_of_sexp (Sexplib.Sexp.of_string s)) with
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
  let room =
    {
      id = Ulid.ulid ();
      key = Some (Ulid.ulid ());
      name;
      players = [];
    }
  in
  write room ~db

let lookup ~db id =
  try
    Red.get db ("rooms" // id)
    |> Option.flat_map deserialize
    |> Result.ok
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
