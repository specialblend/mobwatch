module H = Dream
module R = Routes

let () =
  H.router
    [
      H.get "/rooms/:room_id" R.Rooms.show;
      H.post "/rooms/create" R.Rooms.create;
      H.post "/rooms/:room_id/join" R.Rooms.join_room;
      H.get "/" @@ H.from_filesystem "./pages" "index.html";
    ]
  |> H.logger
  |> H.run
