open Tyxml;
open Components;

module Register = {
  let createElement = () =>
    <AppLayout>
      <div class_="container mx-auto">
        <div class_="flex flex-col items-center justify-center h-screen">
          <h1 class_="text-2xl"> "enter your name to continue" </h1>
          <RegisterForm.UX name=None msg=None />
        </div>
      </div>
    </AppLayout>;
};

include Register;
