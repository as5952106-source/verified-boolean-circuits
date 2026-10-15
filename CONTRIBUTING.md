# Contributing

Use the toolchain in `lean-toolchain`. Run `python3 scripts/check_proofs.py` and
`lake build` before submitting a change. Add theorem-level regression examples
for changed assumptions or boundary cases. Do not introduce unproved facts,
unsafe code, or external proof-checker bypasses. Keep theorem assumptions explicit.

Toolchain upgrades must update the Mathlib revision when applicable and pass a
clean build. CI must pass before merging. A passing workflow does not configure
branch protection; repository administrators manage that separately.
