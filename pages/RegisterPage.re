open Tyxml;

module RegisterPage = {
  let createElement = () =>
    <html lang="en">
      <head>
        <meta charset="UTF-8" />
        <title> "Home" </title>
        <script src="https://cdn.tailwindcss.com" />
        <script src="https://unpkg.com/hyperscript.org@0.9.12" />
        <script
          src="https://unpkg.com/htmx.org@1.9.9"
          integrity="sha384-QFjmbokDn2DjBjq+fM+8LUIVrAgqcNW2s0PjAxHETgRn9l4fvX31ZxDxvwQnyMOX"
          crossorigin=`Anonymous
        />
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link
          rel="preconnect"
          href="https://fonts.gstatic.com"
          crossorigin=`Anonymous
        />
        <link
          href="https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@300&display=swap"
          rel="stylesheet"
        />
      </head>
      <body
        class_="text-white bg-zinc-900 font-light"
        style="font-family: 'JetBrains Mono', monospace">
        <div class_="container mx-auto">
          <div class_="flex flex-col items-center justify-center h-screen">
            <h1 class_="text-2xl"> "enter your name to continue" </h1>
            <div
              class_="flex flex-col items-center justify-center mt-8"
              _hx_get="/api/register"
              _hx_target="this"
              _hx_swap="innerHTML"
              _hx_trigger="load"
            />
          </div>
        </div>
      </body>
    </html>;
};

include RegisterPage;
