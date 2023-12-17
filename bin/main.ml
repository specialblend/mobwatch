module H = Dream
module R = Routes

let () =
  H.router
    [
      H.get "/register" R.Register.Page.show;
      H.get "/api/register" R.Register.Api.get;
      H.post "/api/register" R.Register.Api.post;
      H.get "/api/rooms/:room_id" R.Rooms.Api.show;
      H.post "/api/rooms/create" R.Rooms.Api.create;
      H.post "/api/rooms/:room_id/join" R.Rooms.Api.join_room;
      H.get "/" (H.from_filesystem "./pages" "index.html");
    ]
  |> H.logger
  |> H.run
