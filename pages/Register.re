open Tyxml;
open Components;

module Register = {
  let createElement = () =>
    <AppLayout>
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
    </AppLayout>;
};

include Register;
