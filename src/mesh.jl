
# SU2 mesh utilities
import Meshes

function read_su2_section(io, sec)
    r = Regex("^$(uppercase(sec))=")
    
    nchars = length(sec)
    
    for line in eachline(io)
        if occursin(r, line)
            m = match(r, line)
            i1 = ncodeunits(sec) + 2
            return line[i1:end]
        end
    end
    
end

function read_su2_dim(io)

    nstr = read_su2_section(io, "NDIME")
    N = parse(Int, split(strip(nstr), keepempty=false)[begin])
    return N
end

function read_su2_points(io, ndime)
    pstr = read_su2_section(io, "NPOIN")
    npts = parse(Int, split(strip(pstr), keepempty=false)[begin])

    if ndime==2
        ncomp = 2
    else
        ncomp = 3
    end
            
    pts = zeros(npts, ncomp)

    i = 1
    for line in eachline(io)
        pts[i,:] .= parse.(Float64, split(strip(line), keepempty=false)[1:ncomp])
        i += 1
        if i > npts
            break
        end
    end

    return pts
end

const nverts_per_elem = Dict{Int,Int}(3=>2,
                                      5=>3, 9=>4,
                                      10=>4, 12=>8, 13=>6, 14=>5)

function read_su2_elems(io, sec="NELEM")
    estr = read_su2_section(io, sec)
    nelems = parse(Int, split(strip(estr), keepempty=false)[begin])

    etype = zeros(Int, nelems)
    everts = fill(-1, (nelems, 8))
    i = 1
    for line in eachline(io)
        ii = split(strip(line), keepempty=false)
        etype[i] = parse(Int, ii[1])
        nv = nverts_per_elem[etype[i]]
        everts[i,1:nv] .= parse.(Int, ii[2:(1+nv)]) .+ 1
        i += 1
        if i > nelems
            break
        end
        
    end

    return etype, everts
    
end

function read_su2_markers(io)
    nstr = read_su2_section(io, "NMARK")
    nmarks = parse(Int, split(strip(nstr), keepempty=false)[begin])

    markers = Dict{String,Tuple{Vector{Int},Matrix{Int}}}()

    for imark in 1:nmarks
        mstr = strip(read_su2_section(io, "MARKER_TAG"))
        markers[mstr] = read_su2_elems(io, "MARKER_ELEMS")
    end
 
    return markers
end

const element_types = Dict(3=>Meshes.Segment,
                           5=>Meshes.Triangle, 9=>Meshes.Quadrangle,
                           10=>Meshes.Tetrahedron, 12=>Meshes.Hexahedron,
                           13=>Prism, 14=>Meshes.Pyramid)

function read_su2_mesh(fname)

    open(io, "r") do io
        ndime = read_su2_dim(io)
        seek(io,0)
        pts = read_su2_points(io, ndime)
        elems = read_su2_elems(io)
        markers = read_su2_markers(io)

        # Let's create Meshes.jl structures!
        npts = size(pts,1)
        if ndime == 2
            points = [Point2(v[i,:]) for i in 1:npts]
        else
            points = [Point3(v[i,:]) for i in 1:npts]
        end

        
        
    end
    
    
    
end

