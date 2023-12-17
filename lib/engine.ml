let secure_add_player_room ~db room_r player_r =
  match Room.secure_lookup room_r ~db with
  | Error e -> Error e
  | Ok None -> Ok None
  | Ok (Some room) ->
  match Player.secure_lookup player_r ~db with
  | Error e -> Error e
  | Ok None -> Ok None
  | Ok (Some player) -> Room.add_player room player ~db
