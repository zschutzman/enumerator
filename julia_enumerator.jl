
using Pkg
using LightGraphs
using IterTools
using DataStructures
using Base
using Combinatorics
#use Pkg.add("<<name>>") if you don't have a particular package




function valid_omino(omino)
    if 2 in omino
        return false
    end
    n1 = size(omino)[1]
    n2 = size(omino)[2]
    check = zeros(Int8, n1,n2)
    _f = false
    g = Grid([n1,n2])
    for i=n1:-1:1
        for j=n2:-1:1
           if omino[i,j] ==0
                rem_vertex!(g,(i-1)*n1+j)
            end
            
            
            
            
            
        end   
    end
    
    return length(connected_components(g)) == 1
            
    
end



function make_omino(inds,dim)
    
    p = zeros(Int8,dim[1],dim[2])
    for loc in inds
        p[loc[1],loc[2]]=1
    end
    if valid_omino(p)
        return p
    else
        return zeros(Int8,dim[1],dim[2])
    end

end


function make_omino_set(cells,grid)
    
   pair_idx = []
    for i=1:grid[1]
        for j=1:grid[2]
            push!(pair_idx, (i,j))
        end
    end
    ominos = []
    for t in subsets(pair_idx, Val{cells}())
        p = make_omino(t,grid)
        
        if sum(p)!=0
            push!(ominos,p)
        end
    end
    
    
    return ominos
        
    
    
    
    
end


function valid_omino_qc(omino)
    if 2 in omino
        return false
    end
    n1 = size(omino)[1]
    n2 = size(omino)[2]
    check = zeros(Int8, n1,n2)
    _f = false
    g = Grid([n1,n2])
    
    
    for i=1:n1-1
       for j=1:n2-1
            
           add_edge!(g,(i-1)*n1+j,i*n1+j+1  ) 
            
        end
        
        
    end
    for i=1:n1-1
        for j=2:n2
            add_edge!(g,(i-1)*n1+j,i*n1+j-1)
            
        end
    end
    
    for i=n1:-1:1
        for j=n2:-1:1
           if omino[i,j] ==0
                rem_vertex!(g,(i-1)*n1+j)
            end
            
            
            
            
            
        end   
    end
    
    return length(connected_components(g)) == 1
            
    
end



function make_omino_qc(inds,dim)
    
    p = zeros(Int8,dim[1],dim[2])
    for loc in inds
        p[loc[1],loc[2]]=1
    end
    if valid_omino_qc(p)
        return p
    else
        return zeros(Int8,dim[1],dim[2])
    end

end


function make_omino_set_qc(cells,grid)
    
   pair_idx = []
    for i=1:grid[1]
        for j=1:grid[2]
            push!(pair_idx, (i,j))
        end
    end
    ominos = []
    for t in subsets(pair_idx, Val{cells}())
        p = make_omino_qc(t,grid)
        
        if sum(p)!=0
            push!(ominos,p)
        end
    end
    
    
    return ominos
        
    
    
    
    
end


make_omino_set_qc(1,[4,4])

function biggen(omlist,grid,bad)
    new_oms = Set()
    for o in omlist
        
        for i = 1:grid[1]
            for j = 1:grid[2]
                z = zeros(Int8,grid[1],grid[2])
                z[i,j]+=1
                if o[i,j]==0 && valid_omino(z+o)
                    push!(new_oms,z+o)
 
                    
                end
            end
        end
    
        
        
        
        
        
    end
       
    return collect(new_oms)
end

function biggen_qc(omlist,grid,bad)
    new_oms = Set()
    for o in omlist
        
        for i = 1:grid[1]
            for j = 1:grid[2]
                z = zeros(Int8,grid[1],grid[2])
                z[i,j]+=1
                if o[i,j]==0 && valid_omino_qc(z+o)
                    push!(new_oms,z+o)
 
                    
                end
            end
        end
    
        
        
        
        
        
    end
       
    return collect(new_oms)
end

function check_holes(omino, bad_holes)

    n1 = size(omino)[1]
    n2 = size(omino)[2]
    check = ones(Int8, n1,n2)-omino
    _f = false
    g = Grid([n1,n2])
    for i=n1:-1:1
        for j=n2:-1:1
           if check[i,j] ==0
                rem_vertex!(g,(i-1)*n1+j)
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
function check_holes_qc(omino, bad_holes)

    n1 = size(omino)[1]
    n2 = size(omino)[2]
    check = ones(Int8, n1,n2)-omino
    _f = false
    g = Grid([n1,n2])
    
    for i=1:n1-1
       for j=1:n2-1
            
           add_edge!(g,(i-1)*n1+j,i*n1+j+1  ) 
            
        end
        
        
    end
    for i=1:n1-1
        for j=2:n2
            add_edge!(g,(i-1)*n1+j,i*n1+j-1)
            
        end
    end    
    
    
    
    
    
    
    for i=n1:-1:1
        for j=n2:-1:1
           if check[i,j] ==0
                rem_vertex!(g,(i-1)*n1+j)
            end
            
            
            
            
            
        end   
    end
    
    
    #nc = 0
    
    for c in connected_components(g)
        #nc+=1
        if length(c) in bad_holes
            return false
        end
    end
    return true
            
    
    
end

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

function build_conflicts(omlist, bad_holes,num_parts)
    
    
    firstdict = DefaultDict(Set)
    
    for o in 1:length(omlist)
        k = first_one(omlist[o])
        push!(firstdict[k],o)
    end
    
    
    
    
    
    conflict = DefaultDict(Set)
    print(length(omlist),"  ")
    for os in subsets(1:length(omlist),Val{2}())
        i = os[1]
        j = os[2]
        if i%500 == 0 && j==i+1
            print(i,"  ")
        end
        _c = true
            for p in zip(omlist[i],omlist[j])
                if _c && p[1]*p[2] ==1
                    _c = false
                end
            end
            if _c && check_holes(omlist[i]+omlist[j],bad_holes)
                push!(conflict[i],j)
                push!(conflict[j],i)
            end
        
    end
    return firstdict,conflict
end




function build_conflicts_qc(omlist, bad_holes,num_parts)
    
    
    firstdict = DefaultDict(Set)
    
    for o in 1:length(omlist)
        k = first_one(omlist[o])
        push!(firstdict[k],o)
    end
    
    
    
    
    
    conflict = DefaultDict(Set)
    print(length(omlist),"  ")
    for i=1:length(omlist)
        if i%500==0
            print(i," ")
        end
        for j=i+1:length(omlist)
            if 2 in omlist[i]+omlist[j]
                push!(conflict[i],j)
                push!(conflict[j],i)
            elseif !check_holes_qc(omlist[i]+omlist[j],bad_holes)
                push!(conflict[i],j)
                push!(conflict[j],i)
            end
        end
    end
    return firstdict,conflict
end


function get_next(fd, curr_inds, omlist)
    
   return [ d for d in fd[first_zero( sum([omlist[j] for j in curr_inds    ])     )] if verify(curr_inds + d)   ] 
    
end
            

function enumerator(grid, om_sizes,num_parts)
    count = 0
    oms = []
    bad_hole_sizes = [ [i for i = 1:minimum(om_sizes)-1] ;[i for i = maximum(om_sizes)+1:2*minimum(om_sizes)-1]        ]
    
    tmp_oms = make_omino_set(1,grid)
    
    if 1 in om_sizes
        oms = [oms;tmp_oms]
    end
    
    for sz = 2:maximum(om_sizes)
        tmp_oms = biggen(tmp_oms,grid,bad_hole_sizes)
        if sz in om_sizes
            oms = [oms;tmp_oms]
        end
        print("MADE SZ ",sz ,' ',length(tmp_oms),"\n")


    end
    
    
    oms = [ o for o in oms if check_holes(o,bad_hole_sizes)]

    print("MADE OMINOS\n")
    
    
    
    fd,cf = build_conflicts(oms,bad_hole_sizes,num_parts)
    print("MADE DICTIONARIES\n")           
    
    function verify(plan)
        #print(plan,'\n')
        
        for p in subsets(plan,Val{2}())
            if !(p[2] in cf[p[1]])
                return false
            end
        end
        return true
    end
                
                
    function recurs_part(plan,steps)
        #print("plan:",plan,"  sum: ",sum([oms[j] for j in plan]),'\n')
        if steps == 0
            if sum(sum( [oms[j] for j in plan])) == grid[1]*grid[2] && sort!(collect([sum(oms[j]) for j in plan    ] )) == om_sizes
                count +=1
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
        print(" ",p," ")
        recurs_part([p],num_parts-1)
    end
    
    
   print('\n') 
   return count 
    
end

function enumerator_qc(grid, om_sizes,num_parts)
    count = 0
    oms = []
    bad_hole_sizes = [ [i for i = 1:minimum(om_sizes)-1]      ;[i for i = maximum(om_sizes)+1:2*minimum(om_sizes)-1]        ]
    
    tmp_oms = make_omino_set_qc(1,grid)
    
    if 1 in om_sizes
        oms = [oms;tmp_oms]
    end
    
    for sz = 2:maximum(om_sizes)
        tmp_oms = biggen_qc(tmp_oms,grid,bad_hole_sizes)
        if sz in om_sizes
            oms = [oms;tmp_oms]
        end
        print("MADE SZ ",sz, "\n")

    end
    
    oms = [ o for o in oms if check_holes_qc(o,bad_hole_sizes)]

    print("MADE OMINOS\n")
    
    
    
    fd,cf = build_conflicts_qc(oms,bad_hole_sizes,num_parts)
    print("MADE DICTIONARIES\n")           
    
    function verify(plan)
        #print(plan,'\n')
        for p in subsets(plan,Val{2}())
            if p[2] in cf[p[1]]
                return false
            end
        end
        return true
    end
                
                
    function recurs_part(plan,steps)
        #print("plan:",plan,"  sum: ",sum([oms[j] for j in plan]),'\n')
        if steps == 0
            if sum(sum( [oms[j] for j in plan])) == grid[1]*grid[2] && sort!(collect([sum(oms[j]) for j in plan    ] )) == om_sizes
                count +=1
            
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
    
    #print(fd,'\n')
    for p in fd[(1,1)]
        print(" ",p," ")
        recurs_part([p],num_parts-1)
    end
    
    
   print('\n') 
   return count 
    
end


@time tot = enumerator([7,7],[7,7,7,7,7,7,7],7)

#@time tot = enumerator([6,6],[6,6,6,6,6,6],6)
#@time tot = enumerator([4,4],[4,4,4,4],4)
print("\n",tot,"\n")

#@time print("  ",enumerator([6,6],[6,6,6,6,6,6],6))

#@time print("  ",enumerator([7,7],[7,7,7,7,7,7,7],7))



