let ( // ) s1 s2 = s1 ^ ":" ^ s2
let ( +: ) s1 s2 = s1 ^ ":" ^ s2
let ( >> ) g f x = f (g x)
let always x _ = x

module Option = struct
  include Option

  let flat_map f = function
    | None -> None
    | Some x -> f x
end

module Result = struct
  include Result

  let flat_map f = function
    | Error e -> Error e
    | Ok x -> f x
end

module Http = struct
  module Res = struct
    let ok = Dream.respond ~code:200
    let bad = Dream.respond ~code:400
    let err = Dream.respond ~code:500
  end
end
