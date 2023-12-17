module Page = struct
  let show _req =
    Pages.Home.createElement ()
    |> Format.asprintf "%a" (Tyxml.Html.pp ())
    |> Dream.html
end
