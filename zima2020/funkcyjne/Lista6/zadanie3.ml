(*Dawid Żywczak, Zadanie 3, lista 6*)
let next, reset =
  let cnt = ref 0 in
  ((fun () -> let r = !cnt in cnt := r+1; r), (fun () -> cnt := 0));;