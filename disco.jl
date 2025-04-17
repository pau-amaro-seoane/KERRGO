# ======================================================================
# KERRGO - Kerr Extreme Relativity & Relativistic Gravity Operations
# Module: DISCO (Deterministic ISCO Solver for Compact Objects)
# ======================================================================
#
# Purpose:
# Computes ISCO radii for Kerr black holes using exact analytic solutions
# with conversion to physical units.
#
# Mathematics:
# The ISCO is derived from the Kerr metric geodesic equations:
#
# 1. Radial potential for equatorial orbits:
#    R(r) = (E(r^2 + a^2) - aL)^2 - Delta(r^2 + (L - aE)^2)
#    where Delta = r^2 - 2Mr + a^2
#
# 2. ISCO conditions (dR/dr = d^2R/dr^2 = 0) yield the exact solution:
#    r_isco = 3 + Z2 -+ sqrt((3 - Z1)(3 + Z1 + 2Z2))
#    where:
#    Z1 = 1 + (1 - a^2)^(1/3)[(1 + a)^(1/3) + (1 - a)^(1/3)]
#    Z2 = sqrt(3a^2 + Z1^2)
#
# Dependencies:
# - Julia 1.6+ (base installation only)
#
# Command-line Examples:
# $ julia disco.jl 0.9 prograde 1e-6
# Equatorial ISCO Results (a=0.90, prograde):
# ISCO radius: 2.3209 gravitational radii
# Conversion factor: 1 gravitational radius = 4.786e-14 pc/Msun
# For 10 Msun BH: 1.111e-12 pc
# For 1e6 Msun BH: 1.111e-07 pc
#
# $ julia disco.jl 0.5 retrograde
#
# $ julia disco.jl -0.2 prograde
# (for counter-rotating black holes)
#
# Author: Pau Amaro Seoane, amaro@riseup.net
# License: ISC
# Copyright (c) 2025, Pau Amaro Seoane
#
# If you use this software in your research, please cite the source.
#
# ======================================================================

using Printf

# Physical constants (SI units, CODATA 2018 values)
const G = 6.67430e-11       # m^3 kg^-1 s^-2
const c = 2.99792458e8      # m/s
const Msun = 1.98847e30     # kg
const pc = 3.08567758e16    # m
const AU = 1.495978707e11   # m

function compute_isco(a::Float64; prograde::Bool=true)
    # Validate spin parameter
    abs(a) >= 1.0 && error("Spin parameter must satisfy -1 < a < 1")

    # Bardeen's exact solution (1972)
    z1 = 1 + (1 - a^2)^(1/3) * ((1 + a)^(1/3) + (1 - a)^(1/3))
    z2 = sqrt(3*a^2 + z1^2)
    prograde ? 3 + z2 - sqrt((3 - z1)*(3 + z1 + 2*z2)) :
              3 + z2 + sqrt((3 - z1)*(3 + z1 + 2*z2))
end

function convert_units(r_g, mass_sun)
    # Convert geometric units to physical units
    meters = r_g * G * mass_sun * Msun / c^2
    Dict(
        :pc => meters / pc,
        :au => meters / AU,
        :km => meters / 1000,
        :geometric => r_g  # Return input for reference
    )
end

function main()
    if length(ARGS) < 1
        println("Usage: julia disco.jl spin [prograde|retrograde]")
        println("Examples:")
        println("  julia disco.jl 0.9 prograde")
        println("  julia disco.jl 0.5 retrograde")
        return
    end

    a = parse(Float64, ARGS[1])
    prograde = length(ARGS) > 1 ? ARGS[2] == "prograde" : true

    r_isco = compute_isco(a, prograde=prograde)
    conv = convert_units(r_isco, 1.0)  # 1 Msun conversion factor

    println("\nEquatorial ISCO Results (a=$a, $(prograde ? "prograde" : "retrograde")):")
    @printf("ISCO radius: %.12f gravitational radii\n", r_isco)
    @printf("Conversion factor: 1 gravitational radius = %.12e pc/Msun\n", conv[:pc])

    # Display for standard mass scales
    for M in [10.0, 1e6]
        m_conv = convert_units(r_isco, M)
        @printf("For %.0e Msun BH: %.12e pc (%.3f AU)\n",
               M, m_conv[:pc], m_conv[:au])
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
