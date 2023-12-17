include Redis_sync.Client

let init () =
  lazy
    (Redis_sync.Client.connect
       { host = "localhost"; port = 6379 })
