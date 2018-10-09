/-
Copyright (c) 2018 Bruno Bentzen. All rights reserved.
Released under the Apache License 2.0 (see "License");
Author: Bruno Bentzen
-/

import .basic ..language.basic

variable {σ : nat}

def simp_mem {Γ : ctx σ} {p : form σ} : Γ p → p ∈ Γ := id

/- context membership operations -/

def trivial_mem_left {Γ : ctx σ} {p : form σ} :
  p ∈ (Γ ⸴ p) :=
by apply or.intro_left; reflexivity

def trivial_mem_right {Γ : ctx σ} {p : form σ} :
  p ∈ ({p} ⊔ Γ) :=
by repeat {apply or.intro_left}; reflexivity

def mem_ext_cons_left {Γ : ctx σ} {p q : form σ} :
  p ∈ Γ → p ∈ (Γ ⸴ q) :=
by intro h; apply or.intro_right; exact h

def mem_ext_cons_left_cp {Γ : ctx σ} {p q : form σ} :
  p ∉ (Γ ⸴ q) → p ∉ Γ :=
by intros hnpq hnp; apply hnpq; apply mem_ext_cons_left; exact hnp

def mem_ext_cons_right {Γ : ctx σ} {p q : form σ} :
  p ∈ Γ → p ∈ ({q} ⊔ Γ) :=
by intro h; apply or.intro_right; exact h

def mem_ext_append_left {Γ Δ : ctx σ} {p : form σ} :
  p ∈ Γ → p ∈ (Γ ⊔ Δ) :=
by intro; apply or.intro_left; assumption

def mem_ext_append_right {Γ Δ : ctx σ} {p : form σ} :
  p ∈ Δ → p ∈ (Γ ⊔ Δ) :=
by intro; apply or.intro_right; assumption

def mem_contr_cons_right {Γ : ctx σ} {p q : form σ} :
  p ∈ (Γ ⸴ q ⸴ q) → p ∈ (Γ ⸴ q) :=
begin
  intro h,
  cases h,
    induction h,
      apply trivial_mem_left,
      exact h
end

def mem_contr_append_right {Γ Δ : ctx σ} {p : form σ} :
  p ∈ (Γ ⊔ Δ ⊔ Δ) → p ∈ (Γ ⊔ Δ) :=
begin
  intro h,
    apply or.elim h,
      exact id,
      exact mem_ext_append_right,
end

def mem_exg_cons_right {Γ : ctx σ} {p q r : form σ} :
  p ∈ (Γ ⸴ q ⸴ r) → p ∈ (Γ ⸴ r ⸴ q) :=
begin
  intro h,
  cases h,
    induction h,
      apply mem_ext_cons_left,
        apply trivial_mem_left,
        cases h,
          induction h,
            apply trivial_mem_left,
          apply mem_ext_cons_left,
            apply mem_ext_cons_left,
              exact h
end

def mem_exg_append_right {Γ Δ : ctx σ} {p : form σ} :
  p ∈ (Γ ⊔ Δ) → p ∈ (Δ ⊔ Γ) :=
begin
  intro h,
    apply or.elim h,
      exact mem_ext_append_right,
      exact mem_ext_append_left
end

def mem_exg_three_append_right {Γ Δ Θ : ctx σ} {p : form σ} :
  p ∈ (Γ ⊔ Δ ⊔ Θ) → p ∈ (Γ ⊔ Θ ⊔ Δ) :=
begin
  intro h,
    apply or.elim h,
      intro h_1,
        apply or.elim h_1,
          intro, repeat {apply or.intro_left}, assumption, 
          intro, apply or.intro_right, assumption, 
      intro, apply or.intro_left, apply or.intro_right, assumption
end

/- subcontext operations -/

def sub_cons_left {Γ Δ : ctx σ} {p : form σ} :
  (Δ ⊆ Γ) → (Δ ⸴ p) ⊆ (Γ ⸴ p) :=
begin
 intros s q qmem, cases qmem, 
   induction qmem, apply trivial_mem_left,
   apply mem_ext_cons_left (s qmem), 
end

def sub_cons_is_sub {Γ Δ : ctx σ} {p : form σ} :
  (Δ ⸴ p) ⊆ Γ → Δ ⊆ Γ :=
by intros s q qmem; apply s; apply mem_ext_cons_left qmem

def mem_union_sub {Γ Δ Θ : ctx σ} :
  (Γ ⊆ Θ) → (Δ ⊆ Θ) → (Γ ⊔ Δ) ⊆ Θ :=
begin
  intros hg hd,
    intros p pm, cases pm,
      apply hg, assumption,
      apply hd, assumption
end

def empty_sub_every_ctx {Γ : ctx σ} :
  · ⊆ Γ :=
by intros p pm; apply false.rec; assumption

/- context equality -/

def ctx_ext {Γ Δ : ctx σ} (h : ∀ p, p ∈ Γ ↔ p ∈ Δ) : Γ = Δ :=
funext (assume x, propext (h x))

def empty_ctx_eq {Γ : ctx σ} :
  (∀ p : form σ, p ∉ Γ) → Γ = · :=
begin
  intro h, apply ctx_ext,
    intro p, apply iff.intro,
      intro pm, apply false.rec, apply h, assumption,
      intro pm, apply false.rec, assumption
end

def has_mem_iff_nonempty_ctx {Γ : ctx σ} :
  (∃ p, p ∈ Γ) ↔ Γ ≠ · :=
begin 
  apply iff.intro,
    intros h heq,
      cases h,
        revert h_h, rewrite heq, apply id,
  cases (classical.prop_decidable (∀ p , p ∉ Γ)),
    intro, apply classical.by_contradiction,
      intro, apply h, apply forall_not_of_not_exists, assumption,
    intro neq, apply false.rec, apply neq, 
      apply empty_ctx_eq, assumption  
end

def has_append_ctx_not_empty {Γ : ctx σ} {p : form σ} :
  (Γ ⸴ p) ≠ · :=
begin
  intro h,
    have emem : p ∈ ∅ := by rewrite (eq.symm h); apply trivial_mem_left,
  assumption
end

def ctx_eq (Γ : ctx σ) :
  Γ = · ∨ (∃ Δ p, Γ = (Δ ⸴ p)) :=
begin
  cases (classical.prop_decidable (Γ = ∅)),
    right, cases has_mem_iff_nonempty_ctx.2 h,
      fapply exists.intro, exact (set.sep (λ p, p ≠ w) Γ),
      fapply exists.intro, exact w,
        apply ctx_ext,
          intro p, apply iff.intro,
            intro pm,
                cases (classical.prop_decidable (p = w)),
                  right, split, repeat {assumption},
                  left, assumption,
            intro pm, cases pm,
              repeat {cases pm, assumption},
    left, assumption
end