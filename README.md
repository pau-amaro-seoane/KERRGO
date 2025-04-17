# Kerr Extreme Relativity & Relativistic Gravity Operations
# KERRGO [/ˈkɜːr.iˌɡoʊ/], "KUR-ee-go" 

## Overview

KERRGO is an ongoing suite of Julia modules for relativistic astrophysics calculations in Kerr spacetime. This growing collection currently features:

1. **DISCO** (Deterministic ISCO Solver for Compact Objects)  
2. *[Future modules: TANGO, MAMBO, CHA-CHA]*

## DISCO Module

`disco.jl` computes exact solutions for the Innermost Stable Circular Orbit (ISCO) around rotating (Kerr) black holes.

### Key Features

- **Exact analytic solutions** using Bardeen-Press-Teukolsky formalism
- **Physical unit conversions** (geometric → pc/AU/km)
- **Prograde & retrograde orbits** support
- **Error-controlled precision** (default tol=1e-8)
- **Zero dependencies** (pure Julia implementation)

## Mathematical Foundations

The ISCO calculation derives from the Kerr metric geodesic equations:

1. Radial potential for timelike geodesics:
   R(r) = [E(r² + a²) - aL]² - Δ[r² + (L - aE)² + Q]
   where Δ = r² - 2Mr + a²

2. ISCO conditions (dR/dr = d²R/dr² = 0) yield:
   r_isco = 3 + Z2 ∓ √[(3 - Z1)(3 + Z1 + 2Z2)]
   
   with:
   Z1 = 1 + (1 - a²)^(1/3)[(1 + a)^(1/3) + (1 - a)^(1/3)]
   Z2 = √(3a² + Z1²)


## Installation

```zsh/bash
git clone https://github.com/pau-amaro-seoane/KERRGO.git
cd KERRGO/DISCO
```

## Usage

### As a Module

```julia
include("disco.jl")
using .DISCO
```

### Calculate ISCO for a=0.9 (prograde)

```
r_isco = compute_isco(0.9)
```

### Convert to physical units

```
convert_units(r_isco, 1e6)  # For 1 million solar mass BH
```

## Command Line Interface

### Basic usage (zsh/bash)
```bash
$ julia disco.jl 0.9 prograde
```

### High-precision mode
```bash
$ julia disco.jl 0.5 retrograde 1e-12
```

### Example output:
```
Equatorial ISCO Results (a=0.90, prograde):
ISCO radius: 2.3209 gravitational radii
Conversion factor: 1 gravitational radius = 4.786e-14 pc/Msun
For 10 Msun BH: 1.111e-12 pc
For 1e6 Msun BH: 1.111e-07 pc
```

## API Documentation

### Core Functions

```julia
    compute_isco(a; prograde=true, tol=1e-8)

Compute ISCO radius for given spin parameter `a`.
- `a`: Dimensionless spin (-1 < a < 1)
- `prograde`: Orbit direction (default true)
- `tol`: Fractional convergence tolerance
```

```julia
    convert_units(r_g, mass_sun)

Convert geometric units to physical scales.
Returns Dict with:
- :geometric - Input value (GM/c²)
- :pc - Parsecs
- :km - Kilometers
- :au - Astronomical Units
```

## Precision Control

The `tol` parameter controls solution accuracy:

| Tolerance | Relative Error | Use Case |
|-----------|----------------|----------|
| 1e-4      | ~0.01%         | Quick estimates |
| 1e-8      | ~1e-6%         | Default precision |
| 1e-12     | ~1e-10%        | High-precision needs |

## Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b new-feature`)
3. Commit changes (`git commit -am 'Add feature'`)
4. Push branch (`git push origin new-feature`)
5. Submit Pull Request

## Roadmap

- [ ] Add inclined orbit support
- [ ] Implement ISCO frequency calculator
- [ ] GUI interface development

## License

Copyright (c) 2025, Pau Amaro Seoane, amaro@riseup.net

If you use any piece of this software, please cite the source.

Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted, provided that the above copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
