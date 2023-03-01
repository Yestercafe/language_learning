module plfa.part1.InductionPlayground where

import Relation.Binary.PropositionalEquality as Eq
open Eq using (_≡_; refl; cong; sym)
open Eq.≡-Reasoning using (begin_; _≡⟨⟩_; step-≡; _∎)
open import Data.Nat using (ℕ; zero; suc; _+_; _*_; _∸_;_^_)

_ : (3 + 4) + 5 ≡ 3 + (4 + 5)
_ =
  begin
    (3 + 4) + 5
  ≡⟨⟩
    7 + 5
  ≡⟨⟩
    12
  ≡⟨⟩
    3 + 9
  ≡⟨⟩
    3 + (4 + 5)
  ∎

+-assoc : ∀ (m n p : ℕ) → (m + n) + p ≡ m + (n + p)
+-assoc zero n p =
  begin
    (zero + n) + p
  ≡⟨⟩
    n + p
  ≡⟨⟩
    zero + (n + p)
  ∎
+-assoc (suc m) n p =
  begin
    (suc m + n) + p
  ≡⟨⟩
    suc (m + n) + p
  ≡⟨⟩
    suc ((m + n) + p)
  ≡⟨ cong suc (+-assoc m n p) ⟩
    suc (m + (n + p))
  ≡⟨⟩
    suc m + (n + p)
  ∎

+-identityʳ : ∀ n → n + zero ≡ n
+-identityʳ zero =
  begin
    zero + zero
  ≡⟨⟩
    zero
  ∎
+-identityʳ (suc n) =
  begin
    (suc n) + zero
  ≡⟨⟩
    suc (n + zero)
  ≡⟨ cong suc (+-identityʳ n) ⟩
    suc n
  ∎

+-suc : ∀ n m → n + suc m ≡ suc (n + m)
+-suc zero m =
  begin
    zero + suc m
  ≡⟨⟩
    suc m
  ≡⟨⟩
    suc (zero + m)
  ∎
+-suc (suc n) m =
  begin
    (suc n) + (suc m)
  ≡⟨⟩
    suc (n + (suc m))
  ≡⟨ cong suc (+-suc n m) ⟩
    suc (suc (n + m))
  ≡⟨⟩
    suc ((suc n) + m)
  ∎

+-comm : ∀ n m → n + m ≡ m + n
+-comm n zero =
  begin
    n + zero
  ≡⟨ +-identityʳ n ⟩
    n
  ∎
+-comm n (suc m) =
  begin
    n + (suc m)
  ≡⟨ +-suc n m ⟩
    suc (n + m)
  ≡⟨ cong suc (+-comm n m) ⟩
    suc (m + n)
  ≡⟨⟩
    (suc m) + n
  ∎

+-rearrange : ∀ (m n p q : ℕ) → (m + n) + (p + q) ≡ m + (n + p) + q
+-rearrange m n p q =
  begin
    (m + n) + (p + q)
  ≡⟨ sym (+-assoc (m + n) p q) ⟩
    ((m + n) + p) + q
  ≡⟨ cong (_+ q) (+-assoc m n p) ⟩
    m + (n + p) + q
  ∎
