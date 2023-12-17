open Tyxml;

module NameInput = {
  let styles = [
    "px-4",
    "py-2",
    "rounded-lg",
    "bg-zinc-800",
    "border-2",
    "focus:outline-none",
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
    <input
      type_="text"
      name="name"
      value={value(name)}
      placeholder="your name"
      class_={style(name)}
    />;
  };
};

module SubmitBtn = {
  let styles = [
    "px-4",
    "py-2",
    "mt-4",
    "rounded-lg",
    "bg-zinc-800",
    "border-2",
    "border-zinc-500",
    "focus:border-zinc-500",
    "focus:outline-none",
  ];

  let createElement = () =>
    <button type_="submit" class_=styles> "Start" </button>;
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
    <form id="register" _hx_post="/api/register">
      <NameInput name />
      <SubmitBtn />
    </form>;
};

module UX = {
  let createElement = (~name, ~msg, ()) =>
    <div> <Form name /> <Msg msg /> </div>;
};
