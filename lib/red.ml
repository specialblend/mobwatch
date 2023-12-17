include Redis_sync.Client

let init () =
  try
    { host = "localhost"; port = 6379 }
    |> Redis_sync.Client.connect
    |> Result.ok
  with
  | exn -> Error exn
