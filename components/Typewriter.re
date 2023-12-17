open Tyxml;

module Typewriter = {
  let createElement = (~text, ()) => {
    <div>
      <div id="ghost" class_="hidden"> {Tyxml.Html.txt(text)} </div>
      <p id="typewriter" />
      <script type_="text/hyperscript">
        "on type(msg) append msg to #typewriter"
      </script>
      <script type_="text/hyperscript" data_msg=text>
        "
        on load from window
        set msg to #ghost.innerText then
        for i in msg
          wait 20ms then
          send type(msg:it)
        end
        "
      </script>
    </div>;
  };
};

include Typewriter;
