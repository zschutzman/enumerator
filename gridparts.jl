
# These are the packages we need to use.  If you don't
# have one, uncomment and run in the next block the
# appropriate lines and then run this block again

using Pkg
using LightGraphs, MetaGraphs
using IterTools
using DataStructures
using Base
using Combinatorics
using StatsBase
using Dates


# Pkg.add("LightGraphs")
# Pkg.add("IterTools")
# Pkg.add("DataStructures")
# Pkg.add("Combinatorics")
# Pkg.add("MetaGraphs")
# Pkg.add("StatsBase")

"""
Checks if an omino is 'valid'. 
A valid omino is a binary matrix where
all of the ones are positioned such that
they form a single (rook/queen)-connected
component.
"""
function valid_omino(omino,cont="rc")
    if 2 in omino
        return false
    end
    n1 = size(omino)[1]
    n2 = size(omino)[2]
    check = zeros(Int8, n1,n2)
    _f = false
    g = Grid([n1,n2])
 
    if cont == "qc" 
        for i=1:n1-1
           for j=1:n2-1
               add_edge!(g,((i-1)*n2+j),i*n2+j+1) 
            end
        end
        
        for i=1:n1-1
            for j=2:n2
                add_edge!(g,((i-1)*n2+j),i*n2+j-1)
            end
        end
    end
    
    for i=n1:-1:1
        for j=n2:-1:1
           if omino[i,j] ==0
                rem_vertex!(g,((i-1)*n2+j))
            end  
        end   
    end
    
    return length(connected_components(g)) == 1  
end
    



"""
Given a list of indices [(i_1,j_1),(i_2,j_2),...]
checks if setting the values at those indices in
a grid of size grid[1]xgrid[2] yields a valid
omino as according to the specified continuity
rule.  

If so, returns that omino.  If not,
returns the grid[1]xgrid[2] zeros matrix.
"""
function make_omino(inds,grid,cont="rc")
    
    p = zeros(Int8,grid[1],grid[2])
    for loc in inds
        p[loc[1],loc[2]]=1
    end
    
    if valid_omino(p,cont)
        return p
    else
        return zeros(Int8,grid[1],grid[2])
    end
end


"""
Returns the set of valid grid[1]xgrid[2] ominos, 
according to the continuity rule, which have 
cells ones.

Note: starting with make_omino_set(1,[...]) and
calling biggen(...) in a loop is generally much
faster than this method.  Since this operates
by combinatorial enumeration, checking all
possible subsets of indices.
"""
function make_omino_set(cells,grid,cont="rc")
    
   pair_idx = []
    for i=1:grid[1]
        for j=1:grid[2]
            push!(pair_idx, (i,j))
        end
    end
    
    ominos = []
    for t in subsets(pair_idx, Val{cells}())
        p = make_omino(t,grid,cont)
        
        if sum(p)!=0
            push!(ominos,p)
        end
    end   
    return ominos    
end

"""
Takes as input a collection of ominos
and returns the list of valid ominos on
the same shape grid which can be formed
by changing a single zero to a one in
any element of omlist.
"""
function biggen(omlist,cont="rc")
    grid = size(omlist[1])
    new_oms = Set()
    for o in omlist
        
        for i = 1:grid[1]
            for j = 1:grid[2]
                z = zeros(Int8,grid[1],grid[2])
                z[i,j]+=1
                if o[i,j]==0 && valid_omino(z+o,cont)
                    push!(new_oms,z+o)                 
                end
            end
        end       
    end
    return collect(new_oms)
end

"""
Given an omino, and a collection of bad
hole sizes (bad_holes), returns true
if none of the connected components formed
by the ominos zeros are of a size in that
list.

For example if we're looking at splitting the 3x3
grid into 3 rook connected pieces of size 3, then we
might have bad_holes=[1,2,4,5], since it's going to
be impossible to add any collection of our 3-ominos
to this omino to complete the partitioning.  Therefore,
if we call this method on

0 1 0
1 1 0
0 0 0

it would return false.
"""
function check_holes(omino, bad_holes,cont="rc")

    n1 = size(omino)[1]
    n2 = size(omino)[2]
    check = ones(Int8, n1,n2)-omino
    _f = false
    g = Grid([n1,n2])
     
    if cont == "qc"
        for i=1:n1-1
           for j=1:n2-1
               add_edge!(g,((i-1)*n2+j),i*n2+j+1  ) 
            end
        end
        
        for i=1:n1-1
            for j=2:n2
                add_edge!(g,((i-1)*n2+j),i*n2+j-1)
            end
        end        
    end
    
    for i=n1:-1:1
        for j=n2:-1:1
           if check[i,j] ==0
                rem_vertex!(g,((i-1)*n2+j))
            end            
        end   
    end
    
    for c in connected_components(g)
        if length(c) in bad_holes
            return false
        end
    end
    
    return true
end


"""
Given a list of ominos, a list of bad hole sizes, the number
of parts we want to partition into, and a continuity rule,
generates two dictionaries to guide the dynamic program.

It is important that omlist indeed be a list, since we do our
hashing by indexing into that list, so it's order needs
to be fixed.

The first dictionary, firstdict, has a key for each (row,col)
pair to index into the ominos.  The values are the set of ominos
for which first_one(omino)==(row,col).  This will allow the 
algorithm to easily ask for the list of ominos which have their
first one in a particular index.

The second dictionary, conflict, has a key for each omino and
the values are the set of ominos which are 'compatible' with
the key.  Here, compatibility means they do not overlap, and
combining both of them does not create any bad holes.  These
are necessary conditions for the pair of ominos to be able
to be used together in some partitioning.
"""
function build_conflicts(omlist, bad_holes,cont="rc")
    
    
    firstdict = DefaultDict(Set)
    
    for o in 1:length(omlist)
        k = first_one(omlist[o])
        push!(firstdict[k],o)
    end
    
    conflict = DefaultDict(Set)
    for os in subsets(1:length(omlist),Val{2}())
        i = os[1]
        j = os[2]
        _c = true
        for p in zip(omlist[i],omlist[j])
            if _c && p[1]*p[2] ==1
                _c = false
            end
        end
        if _c && check_holes(omlist[i]+omlist[j],bad_holes,cont)
            push!(conflict[i],j)
            push!(conflict[j],i)
        end        
    end
    return firstdict,conflict
end

"""
Returns the first (lexicographically)
(row,column) index where the entry
of mat is zero.
"""
function first_zero(mat)
    
   for i=1:size(mat,1)
        for j=1:size(mat,2)
            if mat[i,j]==0
                return (i,j)
            end
        end
    end
    return nothing  
end

"""
Returns the first (lexicographically)
(row,column) index where the entry
of mat is one.
"""
function first_one(mat)
    
   for i=1:size(mat,1)
        for j=1:size(mat,2)
            if mat[i,j]==1
                return (i,j)
            end
        end
    end
    return nothing 
end

"""
The enumerator. Takes five arguments:
- grid: a pair [m,n] which give the dimension of
        the grid to be partitioned
- om_sizes: a list of integers [a,b,...] which 
            are the allowed sizes of ominos
- num_parts: an integer, the number of parts
- cont: a string "rc" or "qc" to give a continuity rule
- io: a boolean, whether or not to write the list of partitions
      to a file.

returns: an integer, counting the number of valid partitions

usage: to partition the 4x6 grid into 4 rook connected pieces
       of size 4,5,6, with file output, you would call
       enumerator([4,6],[4,5,6],4,"rc",true)

The output format is a text file, where each partition
is on its own line.  The components are numbered 1,2,...num_parts
and the linear order corresponds with the lexicographic order of the
indexing of the grid.  For example, the representation of

1 2 2
1 1 2
3 3 3

is

1,2,2,1,1,2,3,3,3

The file naming convention is [<m>,<n>]_[<p_1>,<p_2>,...,<p_l>]_k_<cont>.txt where 
m and n are the dimensions of the grid, the p_i are the allowed sizes of the chunks, 
k is the number of pieces, and cont is either rc for rook contiguity or qc for queen contiguity.



includes three helper methods defined locally:

verify(a,b) checks if the ominos at indices a,b
conflict with each other as according to the 
conflict dictionary constructed by make_conflicts()

get_next() takes a partial partitioning and gives the
collection of ominos which have their first one where
the partial partition has its first zero and which do not
conflict with any of the ominos in the partial partition

recurs_part() uses get_next() to recursively build
all of the partitions.  If it finds a valid one,
it increments the counter and (if io==true) writes
it to the output file
"""
function enumerator(grid, om_sizes, num_parts, cont="rc", io=false)
    count = 0
    oms = []
    plans = []
    bad_hole_sizes = [ [i for i = 1:minimum(om_sizes)-1] ;[i for i = maximum(om_sizes)+1:2*minimum(om_sizes)-1]        ]
    
    tmp_oms = make_omino_set(1,grid,cont)
    if io
        os = om_sizes
        gr = grid
        np = num_parts
        outfile = open(replace("../pentominos/enum_$(gr)_$(os)_$(Int8(np))_$(cont).txt"," "=>""),"w")
    end
    
    
    if 1 in om_sizes
        oms = [oms;tmp_oms]
    end
    
    for sz = 2:maximum(om_sizes)
        tmp_oms = biggen(tmp_oms,cont)
        if sz in om_sizes
            oms = [oms;tmp_oms]
        end
        #print("MADE SZ ",sz ,' ',length(tmp_oms),"\n")


    end
    
    
    oms = [ o for o in oms if check_holes(o,bad_hole_sizes,cont)]
    
    #print("MADE OMINOS\n")
    
    
    
    fd,cf = build_conflicts(oms,bad_hole_sizes,cont)
    #print("MADE DICTIONARIES\n")           
    
    function verify(plan)
        #print(plan,'\n')
        
        for p in subsets(plan,Val{2}())
            if !(p[2] in cf[p[1]])
                return false
            end
        end
        return true
    end
           

    function get_next(fd, curr_inds, omlist) 
       return [d for d in fd[first_zero(sum([omlist[j] for j in curr_inds]))] if verify(curr_inds + d)]     
    end                  
                
    function recurs_part(plan,steps)
        
        if steps == num_parts-3
            print(" ",plan,"\n ")
        end
        # if count % 100000 == 0
        #     print(count,"\r")
        # end
        #IJulia.clear_output(true)                        
        #print("plan:",plan)
        if steps == 0
            if sum(sum( [oms[j] for j in plan])) == grid[1]*grid[2] #&& sort!(collect([sum(oms[j]) for j in plan    ] )) == om_sizes
                count +=1
                #push!(plans, [oms[j] for j in plan] )
                if io
                    strrep = "$(sum([j.*oms[plan[j]] for j in 1:length(plan)]))\n"
                    strrep = replace(strrep," "=>",")
                    strrep = replace(strrep,"["=>"")
                    strrep = replace(strrep,";"=>"")
                    strrep = replace(strrep,"]"=>"")
                    write(outfile,  strrep)
                end
                return
            end
        elseif sum(sum( [oms[j] for j in plan])) == grid[1]*grid[2]
        return
        end
        for q in fd[first_zero( sum([oms[j] for j in plan     ]))]
            if verify([plan;[q]])
                recurs_part([plan;[q]],steps-1)
            end
        end
    end
    
    print("NEED TO DO ",length(fd[(1,1)]), " TOP-LEVELS\n")

    for p in fd[(1,1)]
                                
        #print(" ",p," ")
        recurs_part([p],num_parts-1)
    end
    
   #print('\n')
    if io
        close(outfile)
    end
                            
    oms  = [reshape(transpose(o),(grid[1],grid[2])) for o in oms]
   return (count, plans, oms)
    
end

# Run the enumerator. Recall, the signature is
# enumerator([grid size], [omino sizes], number of pieces, contiguity, output)


tic = now()

print("\n 6:6: \n",(enumerator([6,6],[4],9,"rc",true)[1]))
print("\n")
print("took $(canonicalize(Dates.CompoundPeriod(now()-tic))) \n")

