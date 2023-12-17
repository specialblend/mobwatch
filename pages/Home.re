open Tyxml;
open Components;

module Home = {
  let createElement = () =>
    <AppLayout> <div class_="container mx-auto"> "Welcome" </div> </AppLayout>;
};

include Home;
