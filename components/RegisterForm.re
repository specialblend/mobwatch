open Tyxml;

module NameInput = {
  let styles = [
    "w-full",
    "px-3",
    "py-2",
    "rounded-md",
    "bg-neutral-900",
    "bg-opacity-25",
    "text-green",
    "border-solid",
    "border-neutral-900",
    "placeholder:text-zinc-500",
    "focus:outline-none",
    "focus:placeholder:text-zinc-100",
  ];

  let style = name =>
    switch (name) {
    | Some(Error(_)) => ["border-red-500", ...styles]
    | _ => ["border-zinc-500", ...styles]
    };

  let value = name =>
    switch (name) {
    | Some(Ok(name)) => name
    | Some(Error(name)) => name
    | _ => ""
    };

  let createElement = (~name, ()) => {
    <fieldset class_="">
      <label for_="name" class_="block text-zinc-200">
        "please enter your name"
      </label>
      <div class_="mt-1 mb-4 text-zinc-400">
        "# max. 32 characters: A-z, 0-9, _"
      </div>
      <input
        type_="text"
        name="name"
        placeholder="name"
        pattern="^[A-Za-z ][A-Za-z0-9_ ]{0,31}$"
        value={value(name)}
        class_={style(name)}
        required=()
        autofocus=()
      />
    </fieldset>;
  };
};

module SubmitBtn = {
  let styles = [
    "px-3",
    "py-1",
    "my-4",
    "text-neutral-100",
    "rounded-md",
    "bg-orange",
    "border-2",
    "border-transparent",
    "focus:outline-none",
    "focus:text-neutral-100",
    "focus:border-neutral-100",
  ];

  let createElement = () =>
    <button type_="submit" class_=styles> "|> Start" </button>;
};

module Msg = {
  let createElement = (~msg, ()) => {
    switch (msg) {
    | Some(msg: string) => <p id="msg"> {Tyxml.Html.txt(msg)} </p>
    | None => <p id="msg" />
    };
  };
};

module Form = {
  let createElement = (~name, ()) =>
    <form
      id="register" _hx_post="/api/register" _hx_target="#register-container">
      <NameInput name />
      <SubmitBtn />
    </form>;
};

module UX = {
  let createElement = (~name, ~msg, ()) =>
    <div id="register-container">
      <Form name />
      <div class_="my-4"> <Msg msg /> </div>
      <script type_="text/hyperscript">
        "
          on htmx:afterOnLoad from #register
          if event.detail.xhr.status is 200 then
            wait 2s then go to url '/'
          end
        "
      </script>
    </div>;
};
