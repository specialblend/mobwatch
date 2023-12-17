module Api = struct
  let show req =
    let _room_id = Dream.param req "room_id" in
    Dream.respond ~code:200 "ok"

  let create req =
    let _name = Dream.param req "name" in
    Dream.respond ~code:200 "ok"

  let join_room req =
    let _room_id = Dream.param req "room_id"
    and _room_key = Dream.param req "room_key"
    and _player_id = Dream.param req "player_id"
    and _player_key = Dream.param req "player_key" in
    Dream.respond ~code:200 "ok"
end
