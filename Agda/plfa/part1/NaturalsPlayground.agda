module plfa.part1.NaturalsPlayground where

open import Data.Nat using (ℕ; zero; suc; _+_; _*_)
import Relation.Binary.PropositionalEquality as Eq
open Eq using (_≡_; refl)
open Eq.≡-Reasoning using (begin_; _≡⟨⟩_; _∎)

data Bin : Set where
  ⟨⟩ : Bin
  _O : Bin → Bin
  _I : Bin → Bin

inc : Bin → Bin
inc ⟨⟩ = ⟨⟩ I
inc (b O) = b I
inc (b I) = (inc b) O

inc-example₁ : inc (⟨⟩ I O I I) ≡ ⟨⟩ I I O O
inc-example₁ = refl

inc-example₂ : inc (⟨⟩ I I I) ≡ ⟨⟩ I O O O
inc-example₂ = refl

to : ℕ → Bin
to 0 = ⟨⟩
to (suc n) = inc (to n)

to-example₀ : to 0 ≡ ⟨⟩
to-example₀ = refl
to-example₁ : to 1 ≡ ⟨⟩ I
to-example₁ = refl
to-example₂ : to 2 ≡ ⟨⟩ I O
to-example₂ = refl
to-example₃ : to 3 ≡ ⟨⟩ I I
to-example₃ = refl
to-example₄ : to 4 ≡ ⟨⟩ I O O
to-example₄ = refl

from : Bin → ℕ
from ⟨⟩ = 0
from (n O) = 2 * (from n)
from (n I) = 1 + 2 * (from n)

from-example₀ : from ⟨⟩ ≡ 0
from-example₀ = refl
from-example₁ : from (⟨⟩ I) ≡ 1
from-example₁ = refl
from-example₂ : from (⟨⟩ I O) ≡ 2
from-example₂ = refl
from-example₃ : from (⟨⟩ I I) ≡ 3
from-example₃ = refl
from-example₄ : from (⟨⟩ I O O) ≡ 4
from-example₄ = refl
