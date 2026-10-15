import BooleanCircuits
open BooleanCircuits

example : simplify (.negate (.constant true)) = .constant false := rfl
example : simplify (.conjunction (.constant true) (.input 7)) = .input 7 := rfl
example : simplify (.disjunction (.constant false) (.input 4)) = .input 4 := rfl
example : simplify (.conjunction (.constant false) (.input 0)) = .constant false := rfl
example : simplify (.disjunction (.constant true) (.input 0)) = .constant true := rfl
example : simplify (.negate (.conjunction (.constant false) (.input 3))) =
    .constant true := rfl
example (env : Nat → Bool) (c : Circuit) : evaluate env (simplify c) = evaluate env c :=
  simplify_correct env c
