/-
Copyright (c) 2018 Bruno Bentzen. All rights reserved.
Released under the Apache License 2.0 (see "License");
Author: Bruno Bentzen
-/

import .language.basic .context.basic

variable {σ : nat}

/- the K system -/

inductive prf (Γ : ctx σ) : form σ → Prop
| ax {p : form σ} (h : p ∈ Γ) : prf p
| pl1 {p q : form σ} : prf (p ⊃ (q ⊃ p))
| pl2 {p q r : form σ} : prf ((p ⊃ (q ⊃ r)) ⊃ ((p ⊃ q) ⊃ (p ⊃ r)))
| pl3 {p q : form σ} :  prf (((~p) ⊃ ~q) ⊃ (((~p) ⊃ q) ⊃ p))
| mp {p q : form σ} (hpq: prf (p ⊃ q)) (hp : prf p) : prf q
| k  {p q : form σ} : prf ((◻(p ⊃ q)) ⊃ ((◻p) ⊃ (◻q)))
| nec {p : form σ} (cnil : Γ = ·) (h : prf p) : prf (◻p)

axiom nec_weak {Γ Δ : ctx σ} {p : form σ} (h : Δ ⊆ Γ) :
  (prf Δ ◻p) → (prf Γ ◻p)

notation Γ `⊢ₖ` p := prf Γ p
notation Γ `⊬ₖ` p := prf Γ p → false

/- metaconnectives -/

notation α `⇒` β := α → β 
notation α `⇔` β := α ↔ β 