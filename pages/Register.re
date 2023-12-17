open Tyxml;
open Components;

module Register = {
  let createElement = () =>
    <AppLayout>
      <div class_="flex items-center justify-center h-screen">
        <RegisterForm.UX name=None msg=None />
      </div>
    </AppLayout>;
};

include Register;
