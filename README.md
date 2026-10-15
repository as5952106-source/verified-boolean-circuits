# verified-boolean-circuits

A Lean 4 demonstration of a semantics-preserving Boolean circuit simplifier.
Circuit syntax includes constants, indexed variables, negation, conjunction,
and disjunction. Evaluation uses an arbitrary total variable assignment.

The main theorem `BooleanCircuits.simplify_correct` proves that simplification
preserves evaluation for every circuit and assignment. Supporting lemmas verify
each smart constructor independently. Regression examples cover constant
propagation, absorbing operands, variables, and nested folding.

## Verify

Install [elan](https://github.com/leanprover/elan), then run:

```sh
lake build
python3 scripts/check_proofs.py
```

Lean 4.33.0-rc1 is explicitly pinned to match the companion projects. CI builds
on Ubuntu 24.04 and treats warnings as errors. There are no external Lean
package dependencies and no proof placeholders in the source.

## Limits

This is a new demonstration, not a hardware verification claim. Simplification
is deliberately partial: it folds constants in negations and on the left of
binary operations. No optimality, size reduction, or canonical-form claim is
made. Circuits are finite trees; shared graphs, timing, and physical gates are
outside the model.

Created alongside downstream editions of the Lean examples at
[qritwik](https://github.com/qritwik). No license has been selected.
See [CONTRIBUTING.md](CONTRIBUTING.md).
