open Fun
open Sexplib.Std

type t = {
  id: string;
  key: string option;
  name: string;
}
[@@deriving sexp]

type ref =
  | Ref of {
      id: string;
      key: string;
    }
[@@deriving sexp]

module Role = struct
  type t =
    | Copilot
    | Controller
    | Passenger
    | Pilot
  [@@deriving sexp]
end

let serialize t = Sexplib.Sexp.to_string (sexp_of_t t)

let deserialize s =
  try Some (t_of_sexp (Sexplib.Sexp.of_string s)) with
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
  let player = { id = Ulid.ulid (); key = None; name } in
  write player ~db

let lookup ~db id =
  try
    Red.get db ("players" // id)
    |> Option.flat_map deserialize
    |> Result.ok
  with
  | exn -> Error exn

let secure_lookup ~db (Ref r) =
  let verify = function
    | Some player when player.key = Some r.key -> Some player
    | _ -> None
  in
  Result.map verify (lookup r.id ~db)
