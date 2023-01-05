# Implementing Prism in Meshes.jl

"""
    `Prism(p1, p2, p3, p4, p5, p6)`

A prism with points `p1`...`p6`
"""

import Meshes: Point, Polyhedron, nvertices, boundary

struct Prism{Dim,T,V<:AbstractVector{Point{Dim,T}}} <: Polyhedron{Dim,T}
  vertices::V
end

nvertices(::Type{<:Prism}) = 6
nvertices(p::Prism) = nvertices(typeof(p))

function boundary(p::Prism)
    indices = [(1,2,3), (4,6,5), (1,4,5,2), (2,5,6,3), (3,6,4,1)]
    Meshes.SimpleMesh(p.vertices, Meshes.connect.(indices))
end

