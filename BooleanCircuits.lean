import Std

/-! Boolean circuit simplification with semantics preservation. -/
namespace BooleanCircuits

inductive Circuit where
  | constant : Bool → Circuit
  | input : Nat → Circuit
  | negate : Circuit → Circuit
  | conjunction : Circuit → Circuit → Circuit
  | disjunction : Circuit → Circuit → Circuit
  deriving Repr, DecidableEq

/-- Evaluate a circuit under an arbitrary total input assignment. -/
def evaluate (env : Nat → Bool) : Circuit → Bool
  | .constant value => value
  | .input index => env index
  | .negate x => !(evaluate env x)
  | .conjunction x y => evaluate env x && evaluate env y
  | .disjunction x y => evaluate env x || evaluate env y

/-- Fold negation of a constant. -/
def smartNot : Circuit → Circuit
  | .constant b => .constant (!b)
  | x => .negate x

/-- Eliminate a constant left operand from conjunction. -/
def smartAnd : Circuit → Circuit → Circuit
  | .constant true, y => y
  | .constant false, _ => .constant false
  | x, y => .conjunction x y

/-- Eliminate a constant left operand from disjunction. -/
def smartOr : Circuit → Circuit → Circuit
  | .constant true, _ => .constant true
  | .constant false, y => y
  | x, y => .disjunction x y

theorem smartNot_correct (env : Nat → Bool) (x : Circuit) :
    evaluate env (smartNot x) = !(evaluate env x) := by
  cases x <;> rfl

theorem smartAnd_correct (env : Nat → Bool) (x y : Circuit) :
    evaluate env (smartAnd x y) = (evaluate env x && evaluate env y) := by
  cases x with
  | constant b => cases b <;> simp [smartAnd, evaluate]
  | input n => rfl
  | negate a => rfl
  | conjunction a b => rfl
  | disjunction a b => rfl

theorem smartOr_correct (env : Nat → Bool) (x y : Circuit) :
    evaluate env (smartOr x y) = (evaluate env x || evaluate env y) := by
  cases x with
  | constant b => cases b <;> simp [smartOr, evaluate]
  | input n => rfl
  | negate a => rfl
  | conjunction a b => rfl
  | disjunction a b => rfl

/-- Recursively simplify children before applying a local folding rule. -/
def simplify : Circuit → Circuit
  | .constant b => .constant b
  | .input n => .input n
  | .negate x => smartNot (simplify x)
  | .conjunction x y => smartAnd (simplify x) (simplify y)
  | .disjunction x y => smartOr (simplify x) (simplify y)

/-- Every assignment gives the same result before and after simplification. -/
theorem simplify_correct (env : Nat → Bool) (circuit : Circuit) :
    evaluate env (simplify circuit) = evaluate env circuit := by
  induction circuit with
  | constant b => rfl
  | input n => rfl
  | negate x ih => simp [simplify, smartNot_correct, evaluate, ih]
  | conjunction x y hx hy => simp [simplify, smartAnd_correct, evaluate, hx, hy]
  | disjunction x y hx hy => simp [simplify, smartOr_correct, evaluate, hx, hy]

end BooleanCircuits
