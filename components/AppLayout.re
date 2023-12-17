open Tyxml;

module AppLayout = {
  let createElement = (~children, ()) =>
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
        <link href="/style.css" rel="stylesheet" />
      </head>
      <body
        class_="text-white bg-dark"
        style="font-family: 'JetBrains Mono', monospace">
        ...children
      </body>
    </html>;
};

include AppLayout;
